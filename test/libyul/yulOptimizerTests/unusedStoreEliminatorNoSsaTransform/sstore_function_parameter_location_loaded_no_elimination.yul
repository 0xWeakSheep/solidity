{
    function direct(arg, value)
    {
        sstore(arg, value)
        pop(sload(arg))
        let value1 := add(value, 1)
        sstore(arg, value1)
    }

    function indirect(arg, value)
    {
        let loc := arg
        sstore(loc, value)
        pop(sload(arg))
        let value1 := add(value, 1)
        sstore(loc, value1)
    }

    function mix_elimination(arg, value)
    {
        let loc := add(arg, 1)
        sstore(arg, value)
        pop(sload(loc))
        let value1 := add(value, 1)
        sstore(arg, value1)
    }

    function mix_no_elimination(arg, value)
    {
        let loc := arg
        sstore(arg, value)
        pop(sload(loc))
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
//         pop(sload(arg))
//         sstore(arg, add(value, 1))
//     }
//     function indirect(arg_1, value_2)
//     {
//         let loc := arg_1
//         sstore(loc, value_2)
//         pop(sload(arg_1))
//         sstore(loc, add(value_2, 1))
//     }
//     function mix_elimination(arg_4, value_5)
//     {
//         pop(sload(add(arg_4, 1)))
//         sstore(arg_4, add(value_5, 1))
//     }
//     function mix_no_elimination(arg_8, value_9)
//     {
//         let loc_10 := arg_8
//         sstore(arg_8, value_9)
//         pop(sload(loc_10))
//         sstore(arg_8, add(value_9, 1))
//     }
// }
