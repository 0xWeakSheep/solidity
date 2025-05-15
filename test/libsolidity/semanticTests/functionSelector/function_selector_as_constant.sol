// File-level constant
bytes4 constant FILE_LEVEL_SELECTOR = Base.testFunc.selector;

contract Base {
    function testFunc() public {}
}

library TestLib {
    function libFunc() public {}
    bytes4 public constant LIB_SELECTOR = TestLib.libFunc.selector;
}

contract B {
    function g() public {}
}

contract ModifierTest {
    function modFunc() public {}

    modifier testModifier(bytes4 selector) {
        require(selector == this.modFunc.selector);
        _;
    }

    constructor() testModifier(this.modFunc.selector) {
    }
}

// Testing constructor args when called after 'is'
contract InheritanceTest is B {
    bytes4 public constant INHERIT_SELECTOR = B.g.selector;

    constructor(bytes4 expectedSelector) {
        assert(INHERIT_SELECTOR == expectedSelector);
    }
}

// Unrelated contract with constants
contract UnrelatedContract {
    bytes4 public constant UNRELATED_SELECTOR = B.g.selector;
}

// Main test contract - should be last
contract C is B {
    bytes4 public constant SELECTOR = B.g.selector;

    // State variable initialization
    bytes4 public stateSelector = B.g.selector;

    // Immutable initialization
    bytes4 public immutable IMMUTABLE_SELECTOR = B.g.selector;

    constructor() {
        assert(SELECTOR == B.g.selector);
        assert(stateSelector == B.g.selector);
        assert(IMMUTABLE_SELECTOR == B.g.selector);
    }

    function testFunctionReference() public view returns (bytes4) {
        // Using function reference without calling it - just accessing selector
        return B.g.selector;
    }

    function testFileLevelConstant() public pure returns (bytes4) {
        return FILE_LEVEL_SELECTOR;
    }

    function testLibraryConstant() public pure returns (bytes4) {
        return TestLib.LIB_SELECTOR;
    }

    function testUnrelatedConstant() public pure returns (bytes4) {
        // Test that we can access selector from unrelated contract's function
        return B.g.selector;
    }

    function testConstantNegation() public pure returns (bytes4) {
        // Force ConstantEvaluator to run by using negation on the constant
        return ~SELECTOR;
    }

    function testConstantArithmetic() public pure returns (bytes4) {
        // Force ConstantEvaluator to run by using arithmetic on the constant
        return bytes4(uint32(SELECTOR) + 1);
    }
}


// ----
// SELECTOR() -> 0xe2179b8e00000000000000000000000000000000000000000000000000000000
// stateSelector() -> 0xe2179b8e00000000000000000000000000000000000000000000000000000000
// IMMUTABLE_SELECTOR() -> 0xe2179b8e00000000000000000000000000000000000000000000000000000000
// testFunctionReference() -> 0xe2179b8e00000000000000000000000000000000000000000000000000000000
// testFileLevelConstant() -> 0x037a417c00000000000000000000000000000000000000000000000000000000
// testLibraryConstant() -> 0xb1678ce400000000000000000000000000000000000000000000000000000000
// testUnrelatedConstant() -> 0xe2179b8e00000000000000000000000000000000000000000000000000000000
// testConstantNegation() -> 0x1de8647100000000000000000000000000000000000000000000000000000000
// testConstantArithmetic() -> 0xe2179b8f00000000000000000000000000000000000000000000000000000000
