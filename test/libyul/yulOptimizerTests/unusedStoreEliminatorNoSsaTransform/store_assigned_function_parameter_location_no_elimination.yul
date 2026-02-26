{
    function direct(arg, value)
    {
        sstore(arg, value)
        arg := add(arg, 1)
        let value1 := add(value, 1)
        sstore(arg, value1)
    }

    function indirect(arg, value)
    {
        let loc := arg
        sstore(loc, value)
        loc := add(loc, 1)
        let value1 := add(value, 1)
        sstore(loc, value1)
    }

    function mix(arg, value)
    {
        let loc := arg
        // It should be eliminated, because the location is the same, but if we look at the result, second pass of the
        // optimizer will eliminate properly first `sstore`.
        sstore(loc, value)
        let value1 := add(value, 1)
        sstore(arg, value1)
    }
}
// ----
// step: unusedStoreEliminatorNoSsaTransform
//
// {
//     { }
//     function direct(arg, value)
//     {
//         sstore(arg, value)
//         arg := add(arg, 1)
//         sstore(arg, add(value, 1))
//     }
//     function indirect(arg_1, value_2)
//     {
//         let loc := arg_1
//         sstore(loc, value_2)
//         loc := add(loc, 1)
//         sstore(loc, add(value_2, 1))
//     }
//     function mix(arg_4, value_5)
//     {
//         sstore(arg_4, value_5)
//         sstore(arg_4, add(value_5, 1))
//     }
// }
