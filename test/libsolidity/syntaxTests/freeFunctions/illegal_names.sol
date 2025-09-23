function this() {}
function super() {}
function _() {}

contract C {
	function test() public {
		this();
		super();
		_();
	}
}
// ----
// DeclarationError 3726: (0-18): The name "this" is reserved.
// Warning 6335: (0-18): "this" will be promoted to keyword in the next breaking version and will not be allowed as an identifier anymore.
// DeclarationError 3726: (19-38): The name "super" is reserved.
// Warning 6335: (19-38): "super" will be promoted to keyword in the next breaking version and will not be allowed as an identifier anymore.
// DeclarationError 3726: (39-54): The name "_" is reserved.
// Warning 2319: (0-18): This declaration shadows a builtin symbol.
// Warning 2319: (19-38): This declaration shadows a builtin symbol.
