contract C {
	modifier this { _; }
	modifier super { _; }
	modifier _ { _; }
}
// ----
// DeclarationError 3726: (14-34): The name "this" is reserved.
// Warning 6335: (14-34): "this" will be promoted to keyword in the next breaking version and will not be allowed as an identifier anymore.
// DeclarationError 3726: (36-57): The name "super" is reserved.
// Warning 6335: (36-57): "super" will be promoted to keyword in the next breaking version and will not be allowed as an identifier anymore.
// DeclarationError 3726: (59-76): The name "_" is reserved.
// Warning 2319: (14-34): This declaration shadows a builtin symbol.
// Warning 2319: (36-57): This declaration shadows a builtin symbol.
