contract C {
    int constant public transient = 0;
}
// ----
// Warning 6335: (17-50): "transient" will be promoted to keyword in the next breaking version and will not be allowed as an identifier anymore.
