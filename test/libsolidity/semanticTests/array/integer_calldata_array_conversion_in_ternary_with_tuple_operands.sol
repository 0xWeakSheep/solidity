pragma abicoder v2;

contract C {
    function g_int(uint[] calldata a) public returns(uint, uint, uint, uint) {
        (uint[] calldata b, ) = true ? (a, 0) : (a, 0);
        return (b.length, b[0], b[1], b[2]);
    }

    function g_slice(uint[] calldata a) public returns(uint, uint, uint, uint) {
        (uint[] calldata b, ) = true ? (a[:], 0) : (a[0:1], 0);
        return (b.length, b[0], b[1], b[2]);
    }

    function g_mix_array_slice(uint[] calldata a) public returns(uint, uint, uint, uint) {
        (uint[] calldata b, ) = true ? (a, 0) : (a[:], 0);
        return (b.length, b[0], b[1], b[2]);
    }

    function g_static(uint[3] calldata a) public returns(uint, uint, uint, uint) {
        (uint[3] calldata b, ) = true ? (a, 0) : (a, 0);
        return (b.length, b[0], b[1], b[2]);
    }
}
// ----
// g_int(uint256[]): 0x20, 3, 11111111, 2222222, 888888888 -> 3, 11111111, 2222222, 888888888
// g_slice(uint256[]): 0x20, 3, 11111111, 2222222, 888888888 -> 3, 11111111, 2222222, 888888888
// g_mix_array_slice(uint256[]): 0x20, 3, 11111111, 2222222, 888888888 -> 3, 11111111, 2222222, 888888888
// g_static(uint256[3]): 11111111, 2222222, 888888888 -> 3, 11111111, 2222222, 888888888
