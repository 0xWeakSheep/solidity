enum this {
    a
}
enum super {
    b
}
enum _ {
    c
}

enum E {
    this,
    super,
    _
}

contract C {
    this a;
    super b;
    _ c;
    E e;
}
// ----
// DeclarationError 3726: (0-19): The name "this" is reserved.
// Warning 6335: (0-19): "this" will be promoted to keyword in the next breaking version and will not be allowed as an identifier anymore.
// DeclarationError 3726: (20-40): The name "super" is reserved.
// Warning 6335: (20-40): "super" will be promoted to keyword in the next breaking version and will not be allowed as an identifier anymore.
// DeclarationError 3726: (41-57): The name "_" is reserved.
// DeclarationError 3726: (72-76): The name "this" is reserved.
// Warning 6335: (72-76): "this" will be promoted to keyword in the next breaking version and will not be allowed as an identifier anymore.
// DeclarationError 3726: (82-87): The name "super" is reserved.
// Warning 6335: (82-87): "super" will be promoted to keyword in the next breaking version and will not be allowed as an identifier anymore.
// DeclarationError 3726: (93-94): The name "_" is reserved.
// Warning 2319: (0-19): This declaration shadows a builtin symbol.
// Warning 2319: (20-40): This declaration shadows a builtin symbol.
