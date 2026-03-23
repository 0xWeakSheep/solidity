contract C { function f() public { assembly { let x := 1 }
/**ÿ*/
} }
// ----
// ParserError 8936: (59-65): Invalid UTF-8 sequence in comment.
