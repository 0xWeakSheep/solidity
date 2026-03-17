contract B {
    uint256 public x;
    uint256 public y;
    constructor(uint _x, uint _y) { x = _x; y = _y; }
}

contract C is B {
    constructor() B({y: 2, x: 1}) {}
}

// ----
// ParserError 6933: (152-153): Expected primary expression.
