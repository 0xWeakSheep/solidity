pragma abicoder v2;

contract C {
    struct N {
        address addr;
        bytes data;
    }

    struct S {
        uint8 a;
        address addr;
        N[] ns;
        bytes data;
    }

    function g() public returns(S[] memory) {
        S[] memory ss = new S[](3);

        ss[0].a = 123;
        ss[0].addr = address(1);
        ss[0].ns = new N[](1);
        ss[0].ns[0].addr = address(1);
        ss[0].ns[0].data = "abdeff00";
        ss[0].data = "abdeff";

        ss[1].a = 124;
        ss[1].addr = address(2);
        ss[1].ns = new N[](2);
        ss[1].ns[0].addr = address(2);
        ss[1].ns[0].data = "abdeff10";
        ss[1].ns[1].addr = address(2);
        ss[1].ns[1].data = "abdeff11";
        ss[1].data = "deabff";

        ss[2].a = 125;
        ss[2].addr = address(3);
        ss[2].ns = new N[](3);
        ss[2].ns[0].addr = address(3);
        ss[2].ns[0].data = "abdeff20";
        ss[2].ns[1].addr = address(3);
        ss[2].ns[1].data = "abdeff21";
        ss[2].ns[2].addr = address(3);
        ss[2].ns[2].data = "abdeff22";
        ss[2].data = "deffab";

        return ss;
    }

    function g(S[] calldata a) public returns(S[] memory) {
        (S[] calldata b, ) = true ? (a, 0) : (a, 0);
        return b;
    }
}
// Result of g(), result and input of the last call must all be equal.
// ----
// g()
// ->
// 0x20, 0x03, 0x60, 0x01e0, 0x0400, 123, 1, 0x80, 0x0140, 0x01, 0x20, 1, 0x40, 8, "abdeff00", 6, "abdeff", 124, 2, 0x80, 0x01e0, 2, 0x40, 0xc0, 2, 0x40, 0x08, "abdeff10", 0x02, 0x40, 0x08, "abdeff11", 6, "deabff", 125, 3, 0x80, 0x0280, 3, 0x60, 0xe0, 0x0160, 3, 0x40, 0x08, "abdeff20", 0x03, 0x40, 0x08, "abdeff21", 0x03, 0x40, 0x08, "abdeff22", 6, "deffab"
// g((uint8,address,(address,bytes)[],bytes)[]):
// 0x20, 0x03, 0x60, 0x01e0, 0x0400, 123, 1, 0x80, 0x0140, 0x01, 0x20, 1, 0x40, 8, "abdeff00", 6, "abdeff", 124, 2, 0x80, 0x01e0, 2, 0x40, 0xc0, 2, 0x40, 0x08, "abdeff10", 0x02, 0x40, 0x08, "abdeff11", 6, "deabff", 125, 3, 0x80, 0x0280, 3, 0x60, 0xe0, 0x0160, 3, 0x40, 0x08, "abdeff20", 0x03, 0x40, 0x08, "abdeff21", 0x03, 0x40, 0x08, "abdeff22", 6, "deffab"
// ->
// 0x20, 0x03, 0x60, 0x01e0, 0x0400, 123, 1, 0x80, 0x0140, 0x01, 0x20, 1, 0x40, 8, "abdeff00", 6, "abdeff", 124, 2, 0x80, 0x01e0, 2, 0x40, 0xc0, 2, 0x40, 0x08, "abdeff10", 0x02, 0x40, 0x08, "abdeff11", 6, "deabff", 125, 3, 0x80, 0x0280, 3, 0x60, 0xe0, 0x0160, 3, 0x40, 0x08, "abdeff20", 0x03, 0x40, 0x08, "abdeff21", 0x03, 0x40, 0x08, "abdeff22", 6, "deffab"
