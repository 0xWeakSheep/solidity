uint constant this = 1;
uint constant super = 2;
uint constant _ = 3;
contract C {
	address this;
	int super;
	mapping (address => address) _;
}

contract D {
	address[] this;
	struct _ { uint super; }
}
// ----
// DeclarationError 3726: (0-22): The name "this" is reserved.
// Warning 6335: (0-22): "this" will be promoted to keyword in the next breaking version and will not be allowed as an identifier anymore.
// DeclarationError 3726: (24-47): The name "super" is reserved.
// Warning 6335: (24-47): "super" will be promoted to keyword in the next breaking version and will not be allowed as an identifier anymore.
// DeclarationError 3726: (49-68): The name "_" is reserved.
// DeclarationError 3726: (84-96): The name "this" is reserved.
// Warning 6335: (84-96): "this" will be promoted to keyword in the next breaking version and will not be allowed as an identifier anymore.
// DeclarationError 3726: (99-108): The name "super" is reserved.
// Warning 6335: (99-108): "super" will be promoted to keyword in the next breaking version and will not be allowed as an identifier anymore.
// DeclarationError 3726: (111-141): The name "_" is reserved.
// DeclarationError 3726: (160-174): The name "this" is reserved.
// Warning 6335: (160-174): "this" will be promoted to keyword in the next breaking version and will not be allowed as an identifier anymore.
// DeclarationError 3726: (177-201): The name "_" is reserved.
// DeclarationError 3726: (188-198): The name "super" is reserved.
// Warning 6335: (188-198): "super" will be promoted to keyword in the next breaking version and will not be allowed as an identifier anymore.
// Warning 2519: (84-96): This declaration shadows an existing declaration.
// Warning 2519: (99-108): This declaration shadows an existing declaration.
// Warning 2519: (111-141): This declaration shadows an existing declaration.
// Warning 2519: (160-174): This declaration shadows an existing declaration.
// Warning 2519: (177-201): This declaration shadows an existing declaration.
// Warning 2319: (0-22): This declaration shadows a builtin symbol.
// Warning 2319: (24-47): This declaration shadows a builtin symbol.
