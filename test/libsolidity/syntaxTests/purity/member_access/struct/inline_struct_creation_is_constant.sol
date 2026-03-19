struct S {
    uint256 v;
}

library L {
    function double(S memory s) pure public returns(uint256) {
        return 2 * s.v;
    }
}

using L for S;

contract C
{
    uint256 constant s = S(1).v;

    function test() pure private {
        S(1);
        S(1).v;
        S(1).double;
    }
}
// ----
// Warning 6133: (243-247): Statement has no effect.
// Warning 6133: (257-263): Statement has no effect.
// Warning 6133: (273-284): Statement has no effect.
