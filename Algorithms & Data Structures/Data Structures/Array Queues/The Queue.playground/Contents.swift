import UIKit
/*
public struct Queue<T>{
    fileprivate var array = [T]()
    
    public var isEmpty: Bool{
        return array.isEmpty
    }
    
    public var count: Int{
        return array.count
    }
    
    public mutating func enqueue(_ element: T){
        array.append(element)
    }
    
    //removes as FIFO
    public mutating func dequeue() -> T?{
        if isEmpty{
            return nil
        }else{
            return array.removeFirst()
        }
    }
    
    public var front: T?{
        return array.first
    }
}


var queue = Queue<Any>()
queue.enqueue(10)
queue.enqueue(60)
queue.enqueue(2)

queue.dequeue()
queue.front


//A queue is not always the best choice. If the order in which the items are added and removed from the list is not important, you can use a stack instead of a queue. Stacks are simpler and faster


//This Queue works well, but it is not optimal.
//Enqueuing is an O(1) operation because adding to the end of an array always takes the same amount of time reguardless of the size of the array.

//try:

var stringQueue = Queue<String>()

stringQueue.enqueue("Ada")
stringQueue.enqueue("Donna")
stringQueue.enqueue("Kelly")
stringQueue.enqueue("Grace")
*/

//There are only a limited amount of unused spots at the end of the array, whe the last item is placed at the end of the array and you want to add another Item, the array needs to resize to make more room.

//Resizing includes allocating new memory and copying all the existing data over to the new array. This is an O(n) process which is realatively slow.

//Since it happens occasionally, the time for appending a new element to the end of the array is still O(1) on average or O(1)"amortized".


//The story of Dequeuing is a different matter. To dequeue, we remove tge element from the beginning of the array. This is always an O(n) operationbecause it requires all remaining arrayelements to be shifted in memory


//A more efficient Queue
//To make more dequeuing efficient, we can also reserve some extra free space, but this time at the front of the array.

//** The main idea is whenever we dequeue an item, we do not shift the contents of the array to the front(slow processing), but rather mark the item's position in the array as empty(fast). After dequeuing "Ada", the array is


//Data:
//["Ada", "Donna", "Kelly"]

//originally after dequeuing would be:
//["Donna", "Kelly", "Grace"]

//but with the new style:
//[xxx, "Donna", "Kelly", "Grace"]


//after dequeuing "Donna":
//[xxx, xxx, "Kelly", "Grace"]


//because the spots at the fron never get used again, you can periodically trim the array by moving the remaining items to the front:

//["Kelly", "Grace", xxx, xxx, xxx, xxx]

//** This trimming procedure involves memory which is O(n) operation. Because this only happens once in a while, dequeuing is an O(1) operation on average.


//The new way to trim data

public struct TrimmableQueue<T>{
    fileprivate var array = [T?]()
    fileprivate var head = 0
    
    public var isEmpty: Bool {
        array.isEmpty
    }
    
    public var count: Int{
        return array.count
    }
    
    public mutating func enqueue(_ element: T){
        array.append(element)
        print("array \(array)")
    }
    
    public mutating func dequeue() -> T?{
        

        guard head < array.count, let element = array[head] else{
            return nil
        }
        
        //resets then adds one
       
        //[(head = nil)]
        array[head] = nil
        
        //[(head = 1)]
        head += 1
        
        print("head \(head)")
        print("array \(array)")
        
        //percentage = 1.0 / Array[count]
        let percentage = Double(head)/Double(array.count)
        
        /*The trimmer - keeps the array at even 25%?
        if array.count > 5 && percentage > 0.25{
            array.removeFirst(head)
            head = 0
        }*/
        
        //or
        
        if head > 2{
            //print("array head first: \(head)")
            array.removeFirst(head)
            //print("array head second: \(head)")
            head = 0
            //print("array head last: \(head)")
        }
        
        return element
    }
    
    //tells the items in front
    public var front: T?{
        if isEmpty{
            return nil
        }else{
            return array[head]
        }
    }
}


// Most of the new functionality sits in dequeue(). When we dequeue an item, we first set array[head] to nil to remove the object from the array. Then we increment head because the next item has become the front one:

//["Ada", "Donna", "Kelly", "Grace", xxx, xxx]
//  head

//to

//[xxx, "Donna", "Kelly", "Grace"]
//        head


var tQueue = TrimmableQueue<String>()

tQueue.enqueue("Beth")
tQueue.enqueue("Kenny")
tQueue.enqueue("Raz")
tQueue.enqueue("dave")
tQueue.dequeue()
tQueue.dequeue()
tQueue.dequeue()
tQueue.dequeue()


//There are many ways to create a queue. Alternatively, you can use a linked list, a circular buffer, or a heap
