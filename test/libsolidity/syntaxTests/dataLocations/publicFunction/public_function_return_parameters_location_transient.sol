contract C {
    function h() public pure returns(uint[] transient) {}
}
// ----
// Warning 6335: (50-66): "transient" will be promoted to keyword in the next breaking version and will not be allowed as an identifier anymore.
// TypeError 6651: (50-66): Data location must be "memory" or "calldata" for return parameter in function, but none was given.
