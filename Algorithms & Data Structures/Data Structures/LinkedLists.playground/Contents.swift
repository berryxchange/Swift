import UIKit

//A linked list is a sequence of data items of data like an array. But where an array allocates a big block of memory to store the objects, the elements in a linked list are totally separate in memory and are connected through links

// Item1 --> Item2 --> Item3 --> Item4

//The elements of a linked list are reffered to as nodes. The above picture shows a singly linked list, where each node only has a reference -- or a "pointer"-- to the next node. in a doubly linked list shown below, nodes also have pointers to the previous node:

//     -->     -->     -->
//Item1   Item2   Item3   Item4
//     <--     <--     <--
    
//You need to keep up with were the list begins. Thats usually done with a pointer called the Head.

//Head       -->     -->     -->    nil
//      Item1   Item2   Item3   Item4
//nil        <--     <--     <--    tail




//its also useful to have a reference to the end of the list, known as te tail. Note that the "next" pointer of the last node is "nil", just like the previous pointer of the very first node

//most operations on a linked list have a O(n) time. so linked lists are generally slower than arrays. however, they are also much more flexible -- rather than having to copy large chunks of memory around as with an array, many operations on a linked list just require you to change a few pointers.

//** When dealing with a linked list, you should insert your new items at the front whenever possible. that is an O(1) operation. Likewise for inserting at the back if you keeping track of the tail pointer.


public class LinkedListNode<T>{
    var value: T
    var next: LinkedListNode?
    weak var previous: LinkedListNode?
    
    public init(value: T){
        self.value = value
    }
}


//Doubly Linked list

//Each node has a next and a previous pointer, these can be a nil if there are no next or previous nodes, so these variables must be a optionals

//** To avoid ownership cycles, declare the previous pointer to be weak, if you have a node A that is followed by B node, then A points to B and B points to A, In certain circumstances, this ownership cycle can cause nodes to be kept alive even after you deleted them. So make the pointers weak, to break the cycle.


public class LinkedList<T>{
    
    //node
    public typealias Node = LinkedListNode<T>
    
    
    //Head
    private var head: Node?
    
    //Tail
    private var tail: Node?
    
    //check if first Item in list
    public var first: Node?{
        return head
    }
    
    //check if last Item in list
    public var last: Node? {
        var node: Node? = head
        
        while node != nil && node!.next != nil{
            node = node!.next
        }
        return node
    }
    
    //isEmpty
    public var isEmpty: Bool{
        return head == nil
    }
    
    //check list item count
    public var count: Int{
        guard var node = head else{
            return 0
        }
        
        var count = 1
        while let next = node.next{
            node = next
            count += 1
        }
        return count
    }
    
    //get a node at specific index
    public func getNode(atIndex index: Int) -> Node{
        //check for the head
        if index == 0{
            return head!
        }else{
            //set the node for the next node after the head
            var node = head!.next
            for _ in 1..<index {
                node = node?.next
                if node == nil{
                    break
                }
            }
            return node!
        }
    }
    
    
    //subscript
    public subscript(index: Int) -> T{
        let node = getNode(atIndex: index)
        return node.value
    }
    
    
    public func runSubscript(index: Int) -> T{
        let node = getNode(atIndex: index)
        return node.value
    }
    
    
    
    public func getListValues(){
        
        var nodeCount = 0
        var values = [T]()
        
        while nodeCount != count{
            let node = runSubscript(index: nodeCount)
            values.append(node)
            nodeCount += 1
        }
        
        for item in values{
            print(item)
        }
    }
    
    
    
    
    
    // Add Node to the list
    public func append(value: T){
        let newNode = Node(value: value)
        if let lastNode = last{
            newNode.previous = lastNode
            lastNode.next = newNode
        }else{
            head = newNode
        }
    }
    
    
    //So far we've written code to add new nodes to the end of the list, but that's slow because you need to find the end of the list first. (It would be fast if we used a tail pointer.) For this reason, if the order of the items in the list doesn't matter, you should insert at the front of the list instead. That's always an O(1) operation.
    
    public func insert(_ node: Node, atIndex index: Int){
        let newNode = node
        if index == 0{
            //sets the new node as the head
            newNode.next = head
            head?.previous = newNode
            head = newNode
        }else{
            //gets and sets the previous node
            let prev = self.getNode(atIndex: index - 1)
            let next = prev.next
            
            //sets the new node data
            newNode.previous = prev
            //links back to itself as the new node and to not return a nil
            newNode.next = prev.next
            
            //sets the previous node with new data
            prev.next = newNode
            //sets the newNode previous as the new node
            next?.previous = newNode
        
        }
    }
    
    
    public func remove(node: Node) -> T{
        //gets and sets the previous node
        let prev = node.previous
        //gets and sets the next node
        let next = node.next
        
        //sets the current node as the place of the previous node
        if let prev = prev{
            print("head exists")
            //sets the next node as the place of the current node next node
            prev.next = next
            
        }else{
            print("this was the head..")
            head = next
        }
        
        //sets the current next node previous node as current node previous node
        next?.previous = prev
        
        
        node.previous = nil
        node.next = nil
        return node.value
    }
    
    public func removeAt(_ index: Int) -> T {
        let node = getNode(atIndex: index)
        assert(node != nil)
        return remove(node: node)
    }
    
    public func removeLast()-> T{
        assert(!isEmpty)
        return remove(node: last!)
    }
    
    public func removeAll(){
        head = nil
        //If you had a tail pointer, you'd set it to nil here too.
    }
    
    
    //Note: For a singly linked list, removing the last node is slightly more complicated. You can't just use last to find the end of the list because you also need a reference to the second-to-last node. Instead, use the nodesBeforeAndAfter() helper method. If the list has a tail pointer, then removeLast() is really quick, but you do need to remember to make tail point to the previous node.
    
    
    //How about reversing a list, so that the head becomes the tail and vice versa? There is a very fast algorithm for that:

    public func reverse(){
        var node = head
        tail = node // if you had a tail pointer
        while let currentNode = node{
            node = currentNode.next
            swap(&currentNode.next, &currentNode.previous)
            head = currentNode
        }
    }
    
    
    //maps and Filter
    public func map<U>(transform: (T) -> U) -> LinkedList<U>{
        let result = LinkedList<U>()
        var node = head
        while node != nil{
            result.append(value: transform(node!.value))
            node = node!.next
        }
        return result
    }
    
    
    public func filter(predicate: (T) -> Bool) -> LinkedList<T>{
        let result = LinkedList<T>()
        var node = head
        while node != nil{
            if predicate(node!.value){
                result.append(value: node!.value)
            }
            node = node!.next
        }
        return result
    }
    
    
    //Exercise for the reader: These implementations of map() and filter() aren't very fast because they append() the new node to the end of the new list. Recall that append is O(n) because it needs to scan through the entire list to find the last node. Can you make this faster? (Hint: keep track of the last node that you added.)
    
    //Types that conform to the Sequence protocol, whose elements can be traversed multiple times, nondestructively, and accessed by indexed subscript should conform to the Collection protocol defined in Swift's Standard Library.
    
    //Doing so grants access to a very large number of properties and operations that are common when dealing collections of data. In addition to this, it lets custom types follow the patterns that are common to Swift developers.

    //In order to conform to this protocol, classes need to provide:
    //1 startIndex and endIndex properties.
    //2 Subscript access to elements as O(1). Diversions of this time complexity need to be documented.
    
    
    /*
    public var startIndex: Index{
        get{
            return LinkedListIndex<T>(node: head, tag: 0)
        }
    }
    
    public var endIndex: Index{
        get {
            if let h = self.head{
                return LinkedListIndex<T>(node: h, tag: count)
            }else{
                return LinkedListIndex<T>(node: nil, tag: startIndex.tag)
            }
        }
    }
    
    public subscript(position: Index) -> T{
        get{
            return position.node!.value
        }
    }
    
    //Becuase collections are responsible for managing their own indexes, the implementation below keeps a reference to a node in the list. A tag property in the index represents the position of the node in the list.
    
    public struct LinkedListIndex<T>: Comparable{
        fileprivate let node: LinkedList<T>.LinkedListNode<T>?
        fileprivate let tag: Int
        
        public static func==<T>(lhs: LinkedListIndex<T>, rhs: LinkedListIndex<T>) -> Bool {
            return (lhs.tag == rhs.tag)
        }
        
        public static func < <T>(lhs: LinkedListIndex<T>, rhs: LinkedListIndex<T>) -> Bool{
            return (lhs.tag < rhs.tag)
        }
    }
    
    //Finally, the linked is is able to calculate the index after a given one with the following implementation.

    public func index(after idx: Index) -> Index{
        return LinkedListIndex<T>(node: idx.node?.next, tag: idx.tag+1)
    }
    */
    
    
    //**
    //Linked lists are flexible but many operations are O(n).

    //When performing operations on a linked list, you always need to be careful to update the relevant next and previous pointers, and possibly also the head and tail pointers. If you mess this up, your list will no longer be correct and your program will likely crash at some point. Be careful!

    //When processing lists, you can often use recursion: process the first element and then recursively call the function again on the rest of the list. You’re done when there is no next element. This is why linked lists are the foundation of functional programming languages such as LISP.
    
}


//Extensions
extension LinkedList: CustomStringConvertible{
    public var description: String{
        var s = "["
        var node = head
        
        while node != nil{
            s += "\(node!.value)"
            node = node!.next
            if node != nil{
                s += ", "
            }
        }
        
        return s + "]"
    }
}





//Example
//#1
let list = LinkedList<String>()
list.isEmpty
list.first

//# 2
list.append(value: "Hello World!")
//list.isEmpty

//because it is an optional node, it must be unwrapped
//going through the list from the front
list.first!.value
//going through the list from the back
list.last!.value

//#3
list.append(value: "Rubber babby buggy bumpers")
list.isEmpty
list.first!.value
list.last!.value


//#4
list.first!.previous
list.first!.value
list.first!.next
list.first!.next!.value
//or
list.last!.value
list.last!.previous!.value

//#5
list.count

//# 6
list.getNode(atIndex: 1).value

list[0]

list.insert(LinkedListNode(value: "Swift"), atIndex: 1)
list.insert(LinkedListNode(value: "Turtles"), atIndex: 1)
//list.count

//list.getListValues()

//list.getNode(atIndex: 0)

//list.removeAll()


list.remove(node: list.getNode(atIndex: 2))
list.count
list.getListValues()

list.description
list.reverse()
list.description

//maps and filters

// use
let newList = LinkedList<String>()
newList.append(value: "Kathy")
newList.append(value: "Meagan 3 stallion")
newList.append(value: "Dragon Ball Z")

let eachItemCount = newList.map(transform: { characters in
    characters.count
})

//call
eachItemCount
//....
let filteredList = newList.filter { item in
    item.contains("Z")
}

filteredList

