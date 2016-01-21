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
    
    // MARK: Properties
    
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
     The namespaces defined for this `Graph`. The key is the prefix and the value is the namespace URI.
     */
    public private(set) var namespaces = [String : String]()
    
    /**
     An array containing all namespace prefixes defined in this graph.
     */
    public var namespacePrefixes : [String] {
        return Array(namespaces.keys)
    }
    
    // MARK: Access to resources in the `Graph`
    
    /**
     The resources used in this `Graph` excluding properties (predicates).
     */
    public private(set) var resources = [Resource]()
    
    /**
     The different properties used in the `Graph`.
     */
    public private(set) var properties = [URI]()
    
    
    
    // MARK: Initialisers
    
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
    
    // MARK: Access to statements
    
    /**
     Adds the specfied statement to the `Graph`. If the graph is a named graph, the URI identifier of
     this named graph is added as named graph to the statement.
     
     - parameter statement: The statement to be added to the graph.
     */
    public func add(statement : Statement){
        if name != nil {
            statement.addToNamedGraph(name!)
        }
        statements.append(statement)
        extractDistinctResourcesAndProperties(statement)
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
        self.add(statement)
    }
    
    /**
     Adds the statements in the list to the `Graph`. If the graph is a named graph, the URI identifier of
     this named graph is added as named graph to the statement.
     
     - parameter statements: The statements to be added.
     */
    public func add(statements : [Statement]){
        for statement in statements {
            self.add(statement)
        }
    }
    
    /**
     Adds the contents of the specified graph to the reciever. If the recieving graph is a named graph, the URI identifier of
     this named graph is added as named graph to the statement.
     
     - parameter graph: The graph whose contents (statements) are added to the reciever.
     */
    public func add(graph : Graph){
        let count = graph.count
        for var index = 0; index < count; index++ {
            let statement = graph[index]
            add(statement)
        }
        let prefixes = graph.namespacePrefixes
        for prefix in prefixes {
            addNamespace(prefix, namespaceURI: graph.namespaceForPrefix(prefix)!)
        }
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
    public func deleteStatements(subject: Resource?, predicate: Resource?, object: Value?){
        let graph = subGraph(subject, predicate: predicate, object: object)
        let count = graph.count
        for var index = 0; index < count; index++ {
            let mindex = statements.indexOf(graph[index])
            statements.removeAtIndex(mindex!)
        }
        resources.removeAll()
        properties.removeAll()
        for var index = 0; index < self.count; index++ {
            extractDistinctResourcesAndProperties(self[index])
        }
    }
    
    /**
     Checks the statement for resources (in subject or object) and properties that have not been defined before and
     if so puts these in the `resources` or `properties` array.
     
     - parameter statement: The statement to be checked for distinct resources or properties.
     */
    private func extractDistinctResourcesAndProperties(statement : Statement) {
        if !resources.contains({$0 == statement.subject}){
            resources.append(statement.subject)
        }
        if (statement.object as? Resource) != nil && resources.contains({$0 == statement.object}){
            resources.append((statement.object as! Resource))
        }
        if !properties.contains({$0 == statement.predicate}){
            properties.append(statement.predicate)
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
                            graph.add(statement)
                            break
                        }
                    }
                } else {
                    graph.add(statement)
                }
            }
        }
        let prefixes = self.namespacePrefixes
        for prefix in prefixes {
            graph.addNamespace(prefix, namespaceURI: namespaceForPrefix(prefix)!)
        }
        return graph
    }
    
    // MARK: Namespace functions
    
    /**
     Returns the namespace URI defined in this `Graph` for the specified prefix.
     If no prefix is defined for this namespace, `nil` is returned.
     
     - parameter prefix: The prefix name of the requested namespace.
     - returns: The namespace URI.
     */
    public func namespaceForPrefix(prefix : String) -> String? {
        return namespaces[prefix]
    }
    
    /**
     Returns the first prefix encountered used for the specified namespace URI.
     If the namespace URI has no prefix, `nil` will be returned. 
     One namespace URI may have multiple prefixes. It is not defined which prefix
     will be returned.
     
     - parameter namespaceURI: The namespace URI whose prefix is requested.
     - returns: The prefix or `nil` if no prefix was defined for  the namespace.
     */
    public func prefixForNamespace(namespaceURI : String) -> String? {
        for (prefix, nsURI) in namespaces {
            if nsURI == namespaceURI {
                return prefix
            }
        }
        return nil
    }
    
    /**
     Returns all prefixes that were defined for the specified namespace URI.
     
     - parameter namespaceURI: The namespace URI whose prefixes are requested.
     - returns: The prefixes defined for the namespace URI.
     */
    public func allPrefixesForNamespace(namespaceURI : String) -> [String] {
        var prefixes = [String]()
        for (prefix, nsURI) in namespaces {
            if nsURI == namespaceURI {
                prefixes.append(prefix)
            }
        }
        return prefixes
    }
    
    /**
     Adds the specified namespace to the `Graph` and creates a prefix for that namespace,
     which will be `ns` with possibly a sequence number, e.g. `ns4:`.
     
     - parameter namespaceURI: The namespace URI.
     - returns: The prefix that will be used for the namespace.  
     Returns `nil` when the namespace URI is not a valid URI.
     */
    public func addNamespace(namespaceURI: String) -> String? {
        return addNamespace("ns", namespaceURI: namespaceURI)
    }
    
    /**
     Adds the namespace with the specified prefix to the `Graph`.
     If the prefix was defined for another namespace, the namespace will still be added
     to the `Graph` but with another prefix (with a number appended to the suggested prefix).
     The prefix that will be used is returned by this function.
     Namespaces are allowed to have multiple prefixes, but only one namespace is defined per prefix.
     
     - parameter suggestedPrefix: The suggested prefix.
     - parameter namespaceURI: The namespace URI.
     - returns: The suggested prefix or if that prefix has already been used, an
     alternative prefix. Returns `nil` when the namespace URI is not a valid URI.
     */
    public func addNamespace(suggestedPrefix: String, namespaceURI: String) -> String? {
        var prefix = suggestedPrefix
        if !prefix.validNCName {
            prefix = "ns"
        }
        var count = 0
        while namespaces[prefix] != nil {
            count = count + 1
            prefix = "\(prefix)\(count)"
        }
        namespaces[prefix] = namespaceURI
        return prefix
    }
    
    /**
     Removes the specified namespace from the graph.
     
     - parameter prefix: The prefix of the namespace to be removed.
     */
    public func deleteNamespace(prefix : String) {
        namespaces.removeValueForKey(prefix)
    }
    
    /**
     Returns the qualified name for the specified URI, using the namespaces that were added
     to this `Graph`, or `nil` if the no namespace was defined that can qualify the URI.
     
     - parameter uri: The URI whose qualified name is requested.
     - returns: The qualified name of the URI.
     */
    public func qualifiedName(uri : URI) -> String? {
        let ns = uri.namespace
        let prefix = prefixForNamespace(ns)
        if prefix == nil {
            return nil
        }
        let localname = uri.localName
        return "\(prefix!):\(localname)"
    }
    
    /**
     Returns all valid qualified names for the specified URI, using the namespaces that
     were added to this `Graph`. A namespace URI can have multiple prefixes. For each of
     these prefixes ad qualified names will be returned.
     
     - parameter uri: The URI whose qualified name is requested.
     - returns: All qualified names for this URI.
     */
    public func allQualifiedNames(uri : URI) -> [String] {
        let ns = uri.namespace
        let localname = uri.localName
        let prefixes = allPrefixesForNamespace(ns)
        var qnames = [String]()
        for prefix in prefixes {
            qnames.append("\(prefix):\(localname)")
        }
        return qnames
    }
    
    /**
     Returns the URI specified by the qualified name using the namespace defined for this
     `Graph`, or `nil` if the specified string was not a qualified name or if the qualified
     name could not be converted to a URI.
     
     - parameter qualifiedName: The qualified name specifying the URI given the namespace defined
     in this `Graph`.
     - returns: The URI, or `nil` if the qualified name could not be converted to a URI.
     */
    public func createURIFromQualifiedName(qualifiedName : String) -> URI? {
        if qualifiedName.isQualifiedName {
            let prefix = qualifiedName.qualifiedNamePrefix
            if prefix == nil {
                return nil
            }
            let nsURI = namespaceForPrefix(prefix!)
            if nsURI == nil {
                return nil
            }
            let localname = qualifiedName.qualifiedNameLocalPart
            if localname == nil {
                return nil
            }
            return URI(namespace: nsURI!, localName: localname!)
        }
        return nil
    }
    
    // MARK: Static functions
    
    /**
     Merges multiple graphs in a new (unnamed) graph by adding all statements from each graph into the merged graph.
     
     - parameter graphs: The graphs to be merged.
     - returns: The merged graph.
     */
    public static func merge(graphs : Graph...) -> Graph {
        let merged = Graph()
        for graph in graphs {
            merged.add(graph)
        }
        return merged;
    }
}