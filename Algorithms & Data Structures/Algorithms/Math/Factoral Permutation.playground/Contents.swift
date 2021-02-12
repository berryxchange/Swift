import UIKit

//A Permutation is a certain arrangement of the objects from a collection. For example, if we have the first five letters from the alphabet, then this is a permuttion:

//a, b, c, d

//This is also a permutation:
//b, e, d, a, c

//For a collection of n objects, there are n! possible permutations, where ! is the "factorial" function. So for our collection of five letters, the total number of permutations you can make is:

//5! = 5 * 4 * 3 * 2 * 1 = 120



func factoral(_ n: Int) -> Int{
    // the editable variable input and objet counter
    var n = n
    
    //To times the initial representing number
    var result = 1
    
    //while counting down the amount of numbers till 1
    //the result will multiply that number
    while n > 1{
        result *= n
        n -= 1
    }
    
    print("Result: \(result)")
    return result
}

factoral(5)
