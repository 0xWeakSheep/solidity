#!/usr/bin/env python3
"""
Compare Yul test expected outputs between base and PR branch using the ASTComparator.
Handles:
  - yulOptimizerTests/*.yul (expected output after "// step:" header)
  - cmdlineTests/*/output (plain text with Yul objects)
  - cmdlineTests/*/output.json (Yul embedded in JSON string values)
"""

import argparse
import json
import os
import re
import subprocess
import tempfile


def git_show(ref, path):
    try:
        return subprocess.check_output(
            ["git", "show", f"{ref}:{path}"], text=True, stderr=subprocess.DEVNULL
        )
    except subprocess.CalledProcessError:
        return None


def sanitize_yul(source):
    """Replace unparsable test placeholders."""
    return re.sub(r'hex"<BYTECODE REMOVED>"', 'hex""', source)


def run_comparator(comparator, yul_a, yul_b):
    """Run the comparator on two Yul source strings. Returns (equivalent: bool, message: str)."""
    yul_a = sanitize_yul(yul_a)
    yul_b = sanitize_yul(yul_b)
    with tempfile.NamedTemporaryFile(mode="w", suffix=".yul", delete=False) as fa:
        fa.write(yul_a)
        fa_path = fa.name
    with tempfile.NamedTemporaryFile(mode="w", suffix=".yul", delete=False) as fb:
        fb.write(yul_b)
        fb_path = fb.name
    try:
        result = subprocess.run(
            [comparator, fa_path, fb_path],
            capture_output=True, text=True, timeout=10, check=False
        )
        if result.returncode == 0:
            return True, "EQUIVALENT"
        msg = result.stdout.strip()
        if not msg and result.stderr.strip():
            return False, f"PARSE_ERROR: {result.stderr.strip()}"
        return False, msg or "UNKNOWN ERROR"
    except subprocess.TimeoutExpired:
        return False, "TIMEOUT"
    except OSError as e:
        return False, f"ERROR: {e}"
    finally:
        os.unlink(fa_path)
        os.unlink(fb_path)


def extract_optimizer_expected(content):
    """Extract expected output from yulOptimizerTests .yul files."""
    lines = content.split("\n")

    try:
        idx = next(i for i, l in enumerate(lines) if l.strip() == "// ----")
    except StopIteration:
        return []

    result_lines = []
    for line in lines[idx + 1:]:
        if line.startswith("// "):
            result_lines.append(line[3:])
        elif line == "//":
            result_lines.append("")
        else:
            break
    expectation = "\n".join(result_lines)
    # skip step option
    match = re.match(r"step:\s+\S+\n\n", expectation)
    if not match:
        return []
    yul = expectation[match.end():].strip()
    if not yul:
        return []
    return [f'object "test" {{ code {{\n{yul}\n}} }}']


def trim_to_yul_object(text):
    """Given text starting with a Yul object, return just the object by finding the matching closing brace."""
    lines = text.split("\n")
    result = []
    depth = 0
    started = False
    for line in lines:
        # Strip string literals and comments for brace counting
        code = re.sub(r'"[^"]*"', '', re.sub(r'//.*$', '', line))
        opens = code.count("{")
        closes = code.count("}")
        if not started and opens > 0:
            started = True
        result.append(line)
        if started:
            depth += opens - closes
            if depth <= 0:
                break
    return "\n".join(result)


def extract_yul_objects_from_text(content):
    """Extract Yul objects from plain text output files by splitting on headers."""
    sections = re.split(r'^(?:Optimized IR:|IR:|Pretty printed source:|=+ .+ =+)\s*$', content, flags=re.MULTILINE)
    objects = []
    for section in sections:
        section = section.strip()
        if section.startswith("/// @use-src") or section.startswith("object "):
            objects.append(trim_to_yul_object(section))
    return objects


def extract_yul_from_json(content):
    """Extract Yul object strings from JSON output files."""
    try:
        data = json.loads(content, strict=False)
    except json.JSONDecodeError:
        return []
    yul_strings = []

    def walk(obj):
        if isinstance(obj, str):
            s = obj.strip()
            if s.startswith("/// @use-src") or s.startswith("object "):
                yul_strings.append(s)
        elif isinstance(obj, dict):
            for v in obj.values():
                walk(v)
        elif isinstance(obj, list):
            for v in obj:
                walk(v)

    walk(data)
    return yul_strings


def get_changed_files(base_ref, pr_ref):
    output = subprocess.check_output(
        ["git", "diff", "--name-only", base_ref, pr_ref], text=True
    )
    return output.strip().split("\n")


def classify_file(path):
    if "yulOptimizerTests" in path and path.endswith(".yul"):
        return "optimizer"
    if "yulControlFlowGraph" in path and path.endswith(".yul"):
        return "optimizer"
    if "yulStackLayout" in path and path.endswith(".yul"):
        return "optimizer"
    if "cmdlineTests" in path:
        if path.endswith("output.json"):
            return "json"
        if path.endswith("/output") or path.endswith("/err"):
            return "text"
    return None


def extract_yul(content, file_type):
    if file_type == "optimizer":
        return extract_optimizer_expected(content)
    elif file_type == "json":
        return extract_yul_from_json(content)
    elif file_type == "text":
        return extract_yul_objects_from_text(content)
    return []


def resolve_pr_ref(pr_id):
    """Return a local ref for the given PR. Fetches if needed."""
    ref = f"pr-{pr_id}"
    # Check if the ref already exists locally
    ret = subprocess.run(["git", "rev-parse", "--verify", ref], capture_output=True, check=False)
    if ret.returncode != 0:
        # Try fetching from remotes
        remotes = subprocess.check_output(["git", "remote"], text=True).strip().split("\n")
        fetched = False
        for remote in remotes:
            try:
                subprocess.check_call(
                    ["git", "fetch", remote, f"pull/{pr_id}/head:{ref}"],
                    stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL,
                )
                fetched = True
                break
            except subprocess.CalledProcessError:
                continue
        if not fetched:
            raise RuntimeError(f"Could not fetch PR #{pr_id} from any remote")
    return ref


def find_base_ref(pr_ref, base_branch):
    return subprocess.check_output(
        ["git", "merge-base", base_branch, pr_ref], text=True
    ).strip()


def main():
    parser = argparse.ArgumentParser(
        description="Compare Yul test expected outputs between base and PR using the ASTComparator."
    )
    parser.add_argument("pr", type=int, help="PR number to compare")
    parser.add_argument(
        "comparator",
        help="Path to the yulASTComparator binary",
    )
    parser.add_argument(
        "--base", "-b",
        default="origin/develop",
        help="Base branch for merge-base calculation (default: origin/develop)",
    )
    args = parser.parse_args()

    comparator = os.path.abspath(args.comparator)
    if not os.path.isfile(comparator):
        parser.error(f"Comparator not found: {comparator}")

    pr_ref = resolve_pr_ref(args.pr)
    base_ref = find_base_ref(pr_ref, args.base)

    print(f"PR #{args.pr}: {pr_ref} (base: {base_ref})")

    files = get_changed_files(base_ref, pr_ref)

    equivalent = 0
    mismatches = []
    parse_errors = []
    skipped = []

    test_files = []
    classified = {}
    for f in files:
        ftype = classify_file(f)
        if ftype:
            test_files.append((f, ftype))
            classified[f] = ftype

    print("Changed files:")
    for f in files:
        if f in classified:
            print(f"  \033[92m{f}\033[0m [{classified[f]}]")
        else:
            print(f"  {f}")

    print(f"\n{len(test_files)} of {len(files)} files have comparable Yul content\n")

    for filepath, ftype in sorted(test_files):
        base_content = git_show(base_ref, filepath)
        pr_content = git_show(pr_ref, filepath)

        if base_content is None or pr_content is None:
            reason = "added" if base_content is None else "deleted"
            skipped.append((filepath, reason))
            continue

        if base_content == pr_content:
            equivalent += 1
            continue

        base_yuls = extract_yul(base_content, ftype)
        pr_yuls = extract_yul(pr_content, ftype)

        if not base_yuls and not pr_yuls:
            skipped.append((filepath, "no Yul objects extracted"))
            continue

        if len(base_yuls) != len(pr_yuls):
            mismatches.append((filepath, f"different number of Yul objects: {len(base_yuls)} vs {len(pr_yuls)}"))
            continue

        if not base_yuls:
            skipped.append((filepath, "no Yul objects extracted"))
            continue

        file_ok = True
        for idx, (yul_a, yul_b) in enumerate(zip(base_yuls, pr_yuls)):
            if yul_a == yul_b:
                continue

            equiv, msg = run_comparator(comparator, yul_a, yul_b)
            if equiv:
                continue
            if "PARSE_ERROR" in msg or "TIMEOUT" in msg or "ERROR" in msg:
                parse_errors.append((filepath, idx, msg))
                file_ok = False
                break
            mismatches.append((filepath, msg))
            file_ok = False
            break

        if file_ok:
            equivalent += 1

    print("=" * 50)
    print(f"RESULTS: {len(test_files)} test files")
    print(f"  Equivalent:   {equivalent}")
    print(f"  Mismatched:   {len(mismatches)}")
    print(f"  Parse errors: {len(parse_errors)}")
    print(f"  Skipped:      {len(skipped)}")
    print("=" * 50)

    if mismatches:
        print("\nMismatched files:")
        for f, msg in mismatches:
            print(f"  - {f}")
            for line in msg.split("\n"):
                print(f"    {line}")

    if parse_errors:
        print("\nParse errors:")
        for f, idx, msg in parse_errors:
            print(f"  - {f} (object {idx}): {msg}")

    if skipped:
        print("\nSkipped files:")
        for f, reason in skipped:
            print(f"  - {f} ({reason})")


if __name__ == "__main__":
    main()
