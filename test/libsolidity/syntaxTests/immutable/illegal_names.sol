contract C {
    uint immutable super;
    uint immutable _;
    uint immutable this;
}
// ----
// DeclarationError 3726: (17-37): The name "super" is reserved.
// Warning 6335: (17-37): "super" will be promoted to keyword in the next breaking version and will not be allowed as an identifier anymore.
// DeclarationError 3726: (43-59): The name "_" is reserved.
// DeclarationError 3726: (65-84): The name "this" is reserved.
// Warning 6335: (65-84): "this" will be promoted to keyword in the next breaking version and will not be allowed as an identifier anymore.
// Warning 2319: (17-37): This declaration shadows a builtin symbol.
// Warning 2319: (65-84): This declaration shadows a builtin symbol.
