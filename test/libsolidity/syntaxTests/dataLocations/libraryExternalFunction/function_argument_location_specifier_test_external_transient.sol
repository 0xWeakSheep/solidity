library test {
    function f(bytes transient) external {}
}
// ----
// Warning 6335: (30-45): "transient" will be promoted to keyword in the next breaking version and will not be allowed as an identifier anymore.
// TypeError 6651: (30-45): Data location must be "storage", "memory" or "calldata" for parameter in external function, but none was given.
