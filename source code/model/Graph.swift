//
//  Graph.swift
//  
//
//  Created by Don Willems on 04/01/16.
//
//

import Foundation

/**
 Instances of this class represent an RDF graph, i.e. a set of triples (or `Statement`s).
 A graph can either be named (with a `Resource` as identifier) or unnamed.
 
 Graphs can be used as lists of statements or as results of a SPARQL select query.
 */
public class Graph {
    
    /**
     The name (identifier) of the named graph.
     */
    public let name : Resource?
    
    private var statements = [Statement]()
    
    /**
     The subscript of the graph returns the statement at the specified index in the list of statements 
     contained by the `Graph`.
     */
    subscript(index : Int) -> Statement {
        get {
            assert( index >= 0 && index < statements.count, "Index \(index) is out of bounds [0,\(statements.count)).")
            return statements[index]
        }
    }
    
    /**
     The number of statements in the Graph.
     */
    public var count : Int {
        return statements.count
    }
    
    /**
     Creates an unnamed `Graph`.
     */
    public init() {
        name = nil
    }
    
    /**
     Creates a named graph with the specified name as the URI identifier for the named graph.
     
     - parameter name: The URI identifier (name) of the graph.
     */
    public init(name : Resource){
        self.name = name
    }
    
    /**
     Adds the specfied statement to the `Graph`. If the graph is a named graph, the URI identifier of
     this named graph is added as named graph to the statement.
     
     - parameter statement: The statement to be added to the graph.
     */
    public func addStatement(statement : Statement){
        if name != nil {
            statement.addToNamedGraph(name!)
        }
        statements.append(statement)
    }
    
    /**
     Creates a new statement of the specified subject, predicate, and object, and as part of the specified 
     named graphs and adds it to the `Graph`.
     If this graph is a named graph, the URI identifier of his named graph is added as named graph to the statement.
     
     - parameter subject: The subject of the new statement.
     - parameter predicate: The predicate of the new statement.
     - parameter object: The object of the new statement.
     - parameter namedGraph: The named graphs to which the statement belongs.
     */
    public func addStatement(subject: Resource, predicate: URI, object: Value, namedGraph: Resource...) {
        let statement = Statement(subject: subject, predicate: predicate, object: object)
        statement.namedGraphs = namedGraph
        if name != nil {
            statement.addToNamedGraph(name!)
        }
        self.addStatement(statement)
    }
    
    /**
     Deletes statements with the specified subject, predicate, and object from the `Graph`.
     If one of the optional parameters (e.g. subject) is `nil`, all values for that parameter in the 
     statement will match. If, for instance, this function is called with subject and object `nil`, and
     `RDFS.label` as predicate, then all statements that have `RDF.label` as predicate will be deleted
     from the graph, regardless the values for the subject or object in the statement. If all three parameters
     are `nil`, all statements will be deleted from the graph, as all statements will match with the conditions.
     
     - parameter subject: The subject of the statements to be deleted, or nill if the statement can have any
     subject value for it to be deleted.
     - parameter predicate: The predicate of the statements to be deleted, or nill if the statement can have any
     predicate value for it to be deleted.
     - parameter object: The object of the statements to be deleted, or nill if the statement can have any
     object value for it to be deleted.
     */
    public func deleteStatement(subject: Resource?, predicate: Resource?, object: Value?){
        let graph = subGraph(subject, predicate: predicate, object: object)
        let count = graph.count
        for var index = 0; index < count; index++ {
            let mindex = statements.indexOf(graph[index])
            statements.removeAtIndex(mindex!)
        }
    }
    
    /**
     Returns a subgraph containing all statements that match the conditions specified by the parameters.
     Statements are added to the subgraph when the subject of the statement matches the subject parameter,
     when the predicate of the statement matches the predicate parameter, when the object of the statement
     matches the object parameter, and if one of the named graphs to which the statement belongs is the
     same as one of the named graphs in the parameter.
     
     All parameters are optional. If a parameter is `nil` (e.g. the subject), then all statements will match
     for that parameter. The other parameters still need to match of course.
     
     For instance, when calling the function `myGraph.subGraph(subject: nil, predicate: RDFS.label, object: nil)`,
     will returns a sub graph with all statements that have a `RDFS.label` as a predicate, regardless of the
     subject or object values.
     
     If all parameters are `nil`, this function will return a sub graph containing all statements in the 
     reciever.
     
     - parameter subject: The subject of the statements to be added to the subgraph, or nill if all subjects match.
     - parameter predicate: The predicate of the statements to be added to the subgraph, or nill if all predicates match.
     - parameter object: The object of the statements to be added to the subgraph, or nill if all objects match.
     - parameter namedGraph: The set of named graph URIs that is matched with the named graphs of each statement.
     - returns: A subgraph containing all statements that match the conditions specified by the parameters.
     */
    public func subGraph(subject: Resource?, predicate: Resource?, object: Value?, namedGraph: Resource...) -> Graph {
        let graph = Graph()
        for statement in statements {
            if (subject == nil || subject! == statement.subject) && (predicate == nil || predicate! == statement.predicate) && (object == nil || object! == statement.object) {
                if namedGraph.count > 0 {
                    for ng in namedGraph {
                        if statement.inNamedGraph(ng) {
                            graph.addStatement(statement)
                            break
                        }
                    }
                } else {
                    graph.addStatement(statement)
                }
            }
        }
        return graph
    }
    
}