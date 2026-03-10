// This test ensures that `returndatacopy` is NOT optimized away.
// The optimization that eliminated `returndatacopy` operations
// was intentionally removed because it is very rarely used and complicates the implementation
// of UnusedStoreEliminator. I.e. a variable which is initialized to `returndatasize()` becomes
// stale when a call changing the size is used in between the variable initialization and `returndatacopy`.
// ```
// let x = returndatasize()
// staticcall(...)
// returndatacopy(0, 0, x) // Cannot be optimized away, becasue it can revert.
// ```
{
  let s := returndatasize()
  returndatacopy(0,0,s)
}
// ====
// EVMVersion: >homestead
// ----
// step: unusedStoreEliminator
//
// {
//     {
//         returndatacopy(0, 0, returndatasize())
//     }
// }
