import UIKit

//You are given an integer array a. Write an algorithm that finds the k0th largest element in the array.

//The following is a semi-native, its time complexity is O(n log n) since it first sorts the array and therefore also uses an additional O(n)space

func kthLargest(a: [Int], k:Int) -> Int?{
    let arrayLength = a.count
    if k > 0 && k <= arrayLength{
        let sorted = a.sorted()
        return sorted[arrayLength - k]
    }else{
        return nil
    }
}

kthLargest(a: [7, 92, 23, 9, -1, 0, 11, 6], k: 3)
