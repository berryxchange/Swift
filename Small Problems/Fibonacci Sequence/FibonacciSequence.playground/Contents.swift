import UIKit

//# 1The fibonacci sequence is a series of numbers such that any number, excpet the first two is the sum of the previous two

//0, 1, 1, 2, 3, 5, 8, 13, 21.....


//how to get the value of any fibonacci number
//The Formula
//fib(n) = fib(n - 1) + fib(n - 2)


/* - will throw infinate recursion
 func fib1(n: UInt) -> UInt {
    return fib1(n: n - 1) + fib1(n: n - 2)
}

fib1(n: 1)
*/

/*
func fib2(n: UInt) -> UInt{
    //print("\(fib2(n: n - 2))")
    if (n < 2){
        return n
    }
    return fib2(n: n - 2) + fib2(n: n - 1)
}

fib2(n: 4)
*/



//# 2  Using Memoization in computational tasks - a technique in which you store the results of  computational task when they are completed, so that when you need them again, you can look them up again without needed to compute all over again




/*fibonacci Sequence with memoization
var fibMemo: [UInt: UInt] = [0:0, 1: 1] // our old base case

func fib3(n: UInt) -> UInt{

    //if fibMemo contains n value, it will just return the current array
    if let result = fibMemo[n]{
        print(fibMemo)
        return result
    }else{
        // will add the n value to the array of dictionary
        //and compute the values from the last fibMemo to the input value
        fibMemo[n] = fib3(n: n - 1) + fib3(n: n - 2) //memoization
        print(fibMemo)
    }
    return fibMemo[n]!
}


fib3(n: 6)
fib3(n: 12)
//fib3(n: 6)


//fib3(n: 4)
*/


//# 3 Keep it simple Fibonacci

func fib4(n: UInt) -> UInt{
    if (n == 0){
        return n
    }
    var last: UInt = 0, next: UInt = 1//Initially set to fib(0) & fib(1)
    for _ in 1..<n{
        (last, next) = (next, last + next)
    }
    return next
}

fib4(n: 2)
fib4(n: 3)
fib4(n: 4)
