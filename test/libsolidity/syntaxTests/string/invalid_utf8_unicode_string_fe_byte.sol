contract C {
    string s = unicode"þ";
}
// ----
// SyntaxError 8452: (28-38): Contains invalid UTF-8 sequence at position 0.
// TypeError 7407: (28-38): Type literal_string hex"fe" is not implicitly convertible to expected type string storage ref. Contains invalid UTF-8 sequence at position 0.
