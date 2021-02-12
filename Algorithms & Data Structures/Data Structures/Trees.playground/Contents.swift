import UIKit


//A tree consists of nodes, and these nodes are linked to one another.

//                      Node

//                 Node             Node

//      Node    Node    Node        Leaf

//      Leaf    Leaf    Node

//                  Leaf    Leaf


public class TreeNode<T>{
    //importants
    public var value: T
    public weak var parent: TreeNode?
    public var children = [TreeNode<T>]()
    
    
    public init(value: T){
        self.value = value
    }
    
    public func addChild(_ node: TreeNode){
        children.append(node)
        node.parent = self
    }
}

extension TreeNode: CustomStringConvertible{
    public var description: String{
        var s  = "\(value)"
        if !children.isEmpty{
            s += "{ " + children.map { $0.description }.joined(separator: ", ") + "}"
        }
        return s
    }
}

//the tree
let tree = TreeNode(value: "beverages")

//addable nodes
let hotNode = TreeNode(value: "hot")
let coldNode = TreeNode(value: "cold")

let teaNode = TreeNode(value: "tea")
let coffeeNode = TreeNode(value: "coffee")
let cocoaNode = TreeNode(value: "cocoa")

let blackTeaNode = TreeNode(value: "black")
let greenTeaNode = TreeNode(value: "green")
let chaiTeaNode = TreeNode(value: "chai")

let sodaNode = TreeNode(value: "soda")
let milkNode = TreeNode(value: "milk")

let gingerAleNode = TreeNode(value: "ginger ale")
let bitterLemonNode = TreeNode(value: "bitter lemon")

//setting to tree
tree.addChild(hotNode)
tree.addChild(coldNode)

//setting to tree subcategories
//hot
hotNode.addChild(teaNode)
hotNode.addChild(coffeeNode)
hotNode.addChild(cocoaNode)

//tea
teaNode.addChild(blackTeaNode)
teaNode.addChild(greenTeaNode)
teaNode.addChild(chaiTeaNode)

//cold
coldNode.addChild(milkNode)
coldNode.addChild(sodaNode)

//soda
sodaNode.addChild(bitterLemonNode)
sodaNode.addChild(gingerAleNode)

print(tree)
teaNode.parent?.parent


//Searching within a Tree

extension TreeNode where T: Equatable{
    func search(_ value: T) -> TreeNode?{
        if value == self.value{
            return self
        }
        for child in children{
            if let found = child.search(value){
                return found
            }
        }
        return nil
    }
}


tree.search("cocoa")
tree.search("chai")
tree.search("bubbly")
