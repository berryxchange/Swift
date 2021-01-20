import UIKit

public struct Stack<T>{
    
    fileprivate var array = [T]()
    
    public var isEmpty: Bool{
        return array.isEmpty
    }
    
    public var count: Int{
        return array.count
    }
    
    public mutating func push(_ element: T){
        array.append(element)
        print("array has \(array.count) count")
    }
    
    public mutating func pop() -> T?{
        return array.popLast()
    }
    
    public var peek: T?{
        return array.last
    }
}



//Example Usages
var stack = Stack<Any>()
stack.push(4)
stack.push(12)
stack.push("Alex Trabeck")

stack.pop()



//Example 2
struct User{
    var name: String
    var age: Int
    var address: String
}

var userStack = Stack<User>()

userStack.push(User(name: "Quinton", age: 35, address: "7708 Nw 84th st."))
userStack.peek?.address
userStack.count
userStack.pop()


