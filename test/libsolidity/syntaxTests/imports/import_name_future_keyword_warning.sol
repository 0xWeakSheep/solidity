==== Source: a ====
uint constant CONST = 10;
==== Source: b ====
import "a" as transient;
contract C {
    uint x = transient.CONST;
}
// ----
// Warning 6335: (b:0-24): "transient" will be promoted to keyword in the next breaking version and will not be allowed as an identifier anymore.
