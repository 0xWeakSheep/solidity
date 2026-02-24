// The purpose of this test is to check that the side-effect of
// the error parameter occurs and state is properly reverted
contract C {
    error MyError(uint errorCode, string errorMsg);
    uint public counter = 0;
    function count() public returns (uint) { return ++counter; }
    function f() external {
        string memory eMsg = "error";
        require(false, MyError(count(), eMsg));
        counter = 42;
    }
}
// ====
// revertStrings: strip
// ----
// f() -> FAILURE, hex"0b9344e2", hex"0000000000000000000000000000000000000000000000000000000000000001", hex"0000000000000000000000000000000000000000000000000000000000000040", hex"0000000000000000000000000000000000000000000000000000000000000005", hex"6572726f72000000000000000000000000000000000000000000000000000000"
// counter() -> 0
