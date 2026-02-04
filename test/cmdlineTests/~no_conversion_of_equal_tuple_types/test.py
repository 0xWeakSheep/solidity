#!/usr/bin/env python3

import os
import sys
import subprocess
from pathlib import Path
from textwrap import dedent

# pylint: disable=wrong-import-position
PROJECT_ROOT = Path(__file__).parents[3]
sys.path.insert(0, str(PROJECT_ROOT / 'scripts'))

from common.cmdline_helpers import add_preamble
from common.cmdline_helpers import inside_temporary_dir


@inside_temporary_dir(Path(__file__).parent.name)
def test_no_convert_fun_generated():
    source_file_path = Path(__file__).parent / 'inputs.sol'
    add_preamble(Path.cwd())

    solc_binary = os.environ.get('SOLC')
    if solc_binary is None:
        raise RuntimeError(dedent("""\
            `solc` compiler not found.
            Please ensure you set the SOLC environment variable
            with the correct path to the compiler's binary.
        """))

    output = subprocess.check_output(
        [solc_binary]
        + [source_file_path]
        + (["--ir"])
        + (["--optimize"]),
        encoding="utf8",
    )

    # This test verifies that the compiler does not generate a function converting between tuples of the same types.
    assert "function convert_" not in output, "Output should not contain 'function convert_*'"

    return 0


if __name__ == '__main__':
    sys.exit(test_no_convert_fun_generated())
