contract C {
    function f() pure public {
        uint super = 3;
        uint this = 4;
    }
}
// ----
// DeclarationError 3726: (52-62): The name "super" is reserved.
// Warning 6335: (52-62): "super" will be promoted to keyword in the next breaking version and will not be allowed as an identifier anymore.
// DeclarationError 3726: (76-85): The name "this" is reserved.
// Warning 6335: (76-85): "this" will be promoted to keyword in the next breaking version and will not be allowed as an identifier anymore.
// Warning 2319: (52-62): This declaration shadows a builtin symbol.
// Warning 2319: (76-85): This declaration shadows a builtin symbol.
