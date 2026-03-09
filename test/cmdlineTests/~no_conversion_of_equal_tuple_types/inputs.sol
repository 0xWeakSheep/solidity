// SPDX-License-Identifier: GPL-3.0
pragma solidity >= 0.0.0;

contract C {
    function g_int(uint[] calldata a) public pure returns(uint[] memory, uint[] calldata) {
        uint[] memory ops1; // we take two arrays so the compiler won't short-circuit the conditional
        uint[] memory ops2;

        (uint[] memory a1, uint[] calldata b1) = true ? (ops1, a) : (ops2, a);

        return (a1, b1);
    }
}
