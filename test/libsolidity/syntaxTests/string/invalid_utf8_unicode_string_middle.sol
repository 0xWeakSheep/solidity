contract C {
    string s = unicode"abc¿def";
}
// ----
// SyntaxError 8452: (28-44): Contains invalid UTF-8 sequence at position 7.
// TypeError 7407: (28-44): Type literal_string hex"616263c0646566" is not implicitly convertible to expected type string storage ref. Contains invalid UTF-8 sequence at position 7.
