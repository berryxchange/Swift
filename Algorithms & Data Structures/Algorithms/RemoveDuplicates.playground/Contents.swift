import UIKit

var arrayOfDuplicates = [1,2,6,6,5,3,4,3,7,7,9,2,1,0]

func removeDuplicates(_ array: [Int]) -> [Int]{
    var sortedArray = [Int]()
    for (index, num) in array.enumerated(){
        if sortedArray.contains(num){
            print("contains Number")
            print("Number \(num)")
            print("index \(index)")
        }else{
            print("No such number")
            sortedArray.append(num)
        }
    }
    //print(sortedArray.count)
    return sortedArray
}

removeDuplicates(arrayOfDuplicates)
