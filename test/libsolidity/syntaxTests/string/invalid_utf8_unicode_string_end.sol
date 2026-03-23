contract C {
    string s = unicode"abc¿";
}
// ----
// SyntaxError 8452: (28-41): Contains invalid UTF-8 sequence at position 3.
// TypeError 7407: (28-41): Type literal_string hex"616263c0" is not implicitly convertible to expected type string storage ref. Contains invalid UTF-8 sequence at position 3.
