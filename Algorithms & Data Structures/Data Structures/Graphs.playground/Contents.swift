import UIKit

//Edges & Verticies of a Graph

public enum EdgeType {
    case directed, undirected
    
}

public struct Edge<T: Hashable> {
  public var from: Vertex<T> // 1
  public var to: Vertex<T>
  public let weight: Double? // 2
}

extension Edge: Hashable {
  
  public var hashValue: Int {
      return "\(from)\(to)\(weight)".hashValue
  }
  
  static public func ==(lhs: Edge<T>, rhs: Edge<T>) -> Bool {
    return lhs.from == rhs.from &&
      lhs.to == rhs.to &&
      lhs.weight == rhs.weight
  }
}

public struct Vertex<T: Hashable> {
    public var data: T
    
}



extension Vertex: Hashable {
    public var hashValue: Int{
        return "\(data)".hashValue
    }
    
    static public func ==(lhs: Vertex, rhs: Vertex) -> Bool {
        return lhs.data == rhs.data
    }
}

//There are many ways ti implement graphs. The codde given here is just one possible way. You probably want to tailer the graph code to each individual problem you are trying to solve. For instance, your edges may not need a weight property, or you might not have the need to distinguish between directed and undirected edges.

//              V5
//              ^
//              |
//              |   3.2
//              |
//     1.0      |       1.0
// V1 -------> V2 ----------> V3
// ^                          |
// |                          |
// |                          |
// |    2.8            4.5    |
//  ---------- V4 <-----------


//We can represent it as an adjacent matrix or adjacency list. The classes implementing those concepts both inherit a common API from AbstractGraph, so they can be created in an identical fashion, with different optimized data structures behind the scenes.

protocol Graphable{
    
    associatedtype Element: Hashable
    var description: CustomStringConvertible{ get }
    
    func createVertex(data: Element) -> Vertex<Element>
    func add(_ type: EdgeType, from: Vertex<Element>, to: Vertex<Element>, weight: Double?)
    func weight(from: Vertex<Element>, to: Vertex<Element>) -> Double?
    func edges(from: Vertex<Element>) -> [Edge<Element>]
}

open class AdjacencyList<T: Hashable>{
    public var adjacencyDict: [Vertex<T>:  [Edge<T>]] = [:]
    public init(){
        
    }
    
    fileprivate func addDirectedEdge(from: Vertex<Element>, to: Vertex<Element>, weight: Double?){
        let edge = Edge(from: from, to: to, weight: weight)
        adjacencyDict[from]?.append(edge)
    }

    fileprivate func addUndirectedEdge(vertices: (Vertex<Element>, Vertex<Element>), weight: Double?) {
      let (source, destination) = vertices
      addDirectedEdge(from: source, to: destination, weight: weight)
      addDirectedEdge(from: destination, to: source, weight: weight)
    }
    
}

extension AdjacencyList: Graphable{
    public typealias Element = T
    
    public func createVertex(data: Element) -> Vertex<Element> {
        let vertex = Vertex(data: data)
        
        if adjacencyDict[vertex] == nil{
            adjacencyDict[vertex] = []
        }
        
        return vertex
    }
    
    public func add(_ type: EdgeType, from: Vertex<Element>, to: Vertex<Element>, weight: Double?) {
      switch type {
      case .directed:
        addDirectedEdge(from: from, to: to, weight: weight)
      case .undirected:
        addUndirectedEdge(vertices: (from, to), weight: weight)
      }
    }
    
    public func weight(from source: Vertex<Element>, to destination: Vertex<Element>) -> Double? {
      guard let edges = adjacencyDict[source] else { // 1
        return nil
      }
      
      for edge in edges { // 2
        if edge.from == destination { // 3
          return edge.weight
        }
      }
      
      return nil // 4
    }
    
    public func edges(from: Vertex<Element>) -> [Edge<Element>]? {
      return adjacencyDict[source]
    }
    
    public var description: CustomStringConvertible {
      var result = ""
      for (vertex, edges) in adjacencyDict {
        var edgeString = ""
        for (index, edge) in edges.enumerated() {
          if index != edges.count - 1 {
            edgeString.append("\(edge.to), ")
          } else {
            edgeString.append("\(edge.to)")
          }
        }
        result.append("\(vertex) ---> [ \(edgeString) ] \n ")
      }
      return result
    }
}




for graph in [AdjacencyMatrixGraph<Int>(), AdjacencyListGraph<Int>()]{
    let v1 = graph.createVertex(1)
    let v2 = graph.createVertex(2)
    let v3 = graph.createVertex(3)
    let v4 = graph.createVertex(4)
    let v5 = graph.createVertex(5)
}

