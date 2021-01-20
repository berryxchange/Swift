import UIKit

//Goal count how often certain values appear in an array

//You can do it with a linear search O(n)
//but there is an even faster way O(log n) by using a modification of binary search

//The trick is to have two binary searches, one to find where the duplication starts, and one to find where it ends:

func countOccurences<T: Comparable>(of key: T, in array: [T]) -> Int{
    
    var leftBoundary: Int {
        
        //the left side
        var low = 0
        
        //the amount of the array
        var high = array.count
        print("Left side high: \(high)")
        
        //while the low is < the amount of the array
        //the middle index = 0 + the amount of the array - 0 / 2 = half of the array
        //if the middle of the array object < the key object
        //the low = mid index + 1
        while low < high{
            let midIndex = low + (high - low)/2
            print("Left side MidIndex: \(midIndex)")
            if array[midIndex] < key{
                low = midIndex + 1
                print("Left side low: \(low)")
            }else{
                high = midIndex
            }
        }
        return low
    }
    
    var rightBoundary: Int{
        var low = 0
        var high = array.count
        print("Right side high: \(high)")
        //while the low is < the amount of the array
        //the middle index = 0 + the amount of the array - 0 / 2 = half of the array
        //if the middle of the array object > the key object
        //the high = mid index
        while low < high{
            let midIndex = low + (high - low)/2
            print("Right side MidIndex: \(midIndex)")
            if array[midIndex] > key{
                high = midIndex
                print("Right side low: \(high)")
            }else{
                low = midIndex + 1
            }
        }
        return low
        
    }
    
    return rightBoundary - leftBoundary
    
}

let a = [0, 1, 1, 3, 3, 3, 3, 6, 8, 10, 11, 11]
countOccurences(of: 3, in: a)
