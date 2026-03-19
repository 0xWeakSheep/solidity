contract C {
    error MyError(string message);
    function customError() pure external {
        require(false, MyError("Error"));
    }
    function stringLiteral() pure external {
        require(false, "Error");
    }
}
// ====
// revertStrings: strip
// ----
// customError() -> FAILURE, hex"8b3d2d43", hex"0000000000000000000000000000000000000000000000000000000000000020", hex"0000000000000000000000000000000000000000000000000000000000000005", hex"4572726f72000000000000000000000000000000000000000000000000000000"
// stringLiteral() -> FAILURE
