import UIKit


//A Trie,(also known as a prefix tree, or radix tree, in some other implementations) is a special type of tree used to store associative data structures.
//Sorting the english language is a primary use case for a trie. Each node in the trie would represent a single character of a word. A series of a node then make up a word.

//Tries are very useful for certain situations. Here are some of the advantages:
//• Looking up a value typically have a better worst-case time complexity
//• unlike a hash map, a trie does not need to worry about key collisions.
//• Doesn't utilize hashing to huarantee a unique path to elements.
//• Trie structures can be alphabetically ordered by default

public class TrieNode<T: Hashable>{
    var value: T?
    var isTerminating: Bool = false
    weak var parent: TrieNode?
    var children: [T: TrieNode<T>] = [:]
    
    init(value: T? = nil, parent: TrieNode? = nil){
        self.value = value
        self.parent = parent
    }
    
    //Make sure the child does not already exist in the dictionary of children. If it does, return.
    //Create a new node for the new value, and add it to the children dictionary of the current node.
    func addAChild(child: T){
        guard children[child] == nil else{
            return
        }
        
        children[child] = TrieNode(value: child,parent: self)
    }
}


public class Trie {
    typealias Node = TrieNode<Character>
    fileprivate let root: Node
    
    init(){
        root = Node()
    }
    
    public func insert(word: String){
        guard !word.isEmpty else {
            return
        }
        
        //1
        var currentNode = root
        
        //2
        for character in word.lowercased(){
            if let childNode = currentNode.children[character]{
                currentNode = childNode
            }else{
                currentNode.addAChild(child: character)
                currentNode = currentNode.children[character]!
            }
        }
        
        //Word already present?
        guard !currentNode.isTerminating else{
            return
        }
        
        //4
        //wordCount += 1
        currentNode.isTerminating = true
        
    }
    
    
    public func contains(word: String) -> Bool{
        guard !word.isEmpty else{
            return false
        }
        var currentNode = root
        
        let characters = Array(word.lowercased())
        var currentIndex = 0
        
        while currentIndex < characters.count,
              let child = currentNode.children[characters[currentIndex]]{
            currentNode = child
            currentIndex += 1
        }
        
        if currentIndex == characters.count && currentNode.isTerminating{
            return true
        }else{
            return false
        }
    }
    
    /*
    public func remove(word: String){
        guard !word.isEmpty else{
            return
        }
        
        guard let terminalNode = findTerminalNodeOf(word: word) else{
            return
        }
        
        if terminalNode.isLeaf {
            deleteNodesForWordEndingWith(terminalNode: terminalNode)
        }else{
            terminalNode.isTerminating = false
        }
        wordCount -= 1
    }
 */
    
}



var newTrie = Trie.Node(value: "Y", parent: nil)

newTrie.addAChild(child: "o")

print("\(newTrie.value!)\(newTrie.children.description)")
