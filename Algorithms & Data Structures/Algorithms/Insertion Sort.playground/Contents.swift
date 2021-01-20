import UIKit

//The goal here is to sort an array from high to low or low to high

//You are given an array of numbers and need to put them in the right order.
//The insertion sort algorithm works as follows

//#1 put the numbers in on a pile, this pile is unsorted
//#2 pick a number from the pile, it doesnt really matter which one you pick, but it's easiest to pick from the top of the pile
//#3 insert this number into a new array
//#4 Pick tge next number from the unsorted pile and also insert that into the new array. It either goes before or after the first number you picked, so on that now these two numbers are sorted
//#5 again pick the next number from the pile and insert it into the array in the proper sorted position
//#6 Keep doing this until there are no more numbers on the pile, you end up with an empty pile and an array that is sorted

//This is why its called an "Insertion Sort", because you are taking a number from the pile of numbers and inserting them into a new array in its asorted position.
/*

//Example 1
var unsortedArray = [8, 3, 5, 4, 6]

//pick the first number and insert it into a new array


func insertionArray(_ array: [Int]) ->[Int]{
    //#1 create a new array variable of the inputed array
    var sortedArray = array
    
    //#2 set index for every item in the array
    for index in 1..<sortedArray.count{
        var currentIndex = index

        //#3 while the current index is greater than 0(the first item index)
        //and while 3 < 8(), swap the 8 with the 3
        // if not smaller, it will skip
        print("Current Value: \(sortedArray[index]) at: \(index)")
        while currentIndex > 0 && sortedArray[currentIndex] < sortedArray[currentIndex - 1]{
            
            sortedArray.swapAt(currentIndex - 1, currentIndex)
            //print("Current Index before: \(currentIndex)")
            print("After Swap Value: \(sortedArray[index]) at: \(index)")
            //then make current index the new starting point
            currentIndex -= 1
            //print("Current Index after: \(currentIndex)")
        }
    }
    return sortedArray
}

var list = [10, -1, 3, 9, 2, 27, 8, 5, 1, 3, 0, 26]

//insertionArray(unsortedArray)
insertionArray(list)

 */

/*
 
//Example 2

//** sort without Swap
func insertionSortWithoutSwap(_ array: [Int]) -> [Int]{
    var sortedArray = array
    for index in 1..<sortedArray.count{
        var currentIndex = index
        let temp = sortedArray[currentIndex]
        while currentIndex > 0 && temp < sortedArray[currentIndex - 1]{
            sortedArray[currentIndex] = sortedArray[currentIndex - 1]
            currentIndex -= 1
        }
        sortedArray[currentIndex] = temp
    }
    return sortedArray
}

insertionSortWithoutSwap(unsortedArray)

func insertionSortStringWithoutSwap(_ array: [String]) -> [String]{
    var sortedArray = array
    for index in 1..<sortedArray.count{
        var currentIndex = index
        let temp = sortedArray[currentIndex]
        while currentIndex > 0 && temp < sortedArray[currentIndex - 1]{
            sortedArray[currentIndex] = sortedArray[currentIndex - 1]
            currentIndex -= 1
        }
        sortedArray[currentIndex] = temp
    }
    return sortedArray
}

var stringArray = ["Xavier", "Eddie", "Annie", "Malcome", "Donna"]
insertionSortStringWithoutSwap(stringArray)

*/
 
 /*
#3 - Exmple 3 - Making it generic (fix!!)

//now you can sort other things than numbers

func insertionSortAsGeneric<T>(_ array: [T], _ isOrderedBefore: (T, T) -> Bool) -> [T] {
    var sortedArray = array
    for index in 1..<sortedArray.count{
        var currentIndex = index
        var temp = index
        while currentIndex > 0 && isOrderedBefore(T, T){
            sortedArray[currentIndex] = sortedArray[currentIndex - 1]
            currentIndex -= 1
        }
        sortedArray[currentIndex] = temp as! T
    }
    return sortedArray
}
 */*/


var unsortedItems = ["Kitten", "Doggy", "Wei Wei", "Angela", "Mikey", "Donna"]

func sortStringItems(_ array: [String]) -> [String]{
    var sortedStringArray = array
    
    for index in 1..<sortedStringArray.count{
        var currentIndex = index
        while currentIndex > 0 && sortedStringArray[currentIndex] < sortedStringArray[currentIndex - 1]{
            sortedStringArray.swapAt(currentIndex - 1, currentIndex)
            
            currentIndex -= 1
        }
    }
    return sortedStringArray
}

sortStringItems(unsortedItems)