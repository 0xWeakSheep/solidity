contract C {
    string s = unicode"ра";
}
// ----
// SyntaxError 8452: (28-39): Contains invalid UTF-8 sequence at position 0.
// TypeError 7407: (28-39): Type literal_string hex"e0a0" is not implicitly convertible to expected type string storage ref. Contains invalid UTF-8 sequence at position 0.
