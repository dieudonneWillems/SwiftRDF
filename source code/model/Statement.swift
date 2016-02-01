//
//  Statement.swift
//  
//
//  Created by Don Willems on 20/11/15.
//
//

import Cocoa

/**
 A `Statement` represents an RDF triple with an optional set of named graphs to which the
 statement belongs. An RDF triple consists of three RDF model objects, a subject, representing
 the subject of the triple, a predicate, representing the relation between the subject and
 the third model object in a statement, the object. A triple represents the smallest statement of
 knowledge.
 */
public class Statement : NSObject, SPARQLValue {
    
    // MARK: Properties

    /**
     The subject of the RDF statement.
     */
    public let subject: Resource
    
    /**
     The predicate of the RDF statement.
     */
    public let predicate: URI
    
    /**
     The object of the RDF statement.
     */
    public let object: Value
    
    /**
     The identifier of the statement, which is used for reification.
     */
    public let ID: Resource?
    
    /**
     The set of named graphs to which the statement belongs.
     */
    public var namedGraphs: [Resource] = []
    
    /**
     A textual representation of the statement in the form of
     'subject - predicate - object' followed by the list of named graphs when present.
     */
    override public var description: String {
        var contextstr = ""
        if namedGraphs.count > 0 {
            contextstr  = "\(namedGraphs)"
        }
        return "\(subject) \(predicate) \(object) \(contextstr)"
    }
    
    // MARK: SPARQL properties
    
    /**
     The representation of this statement as used in a SPARQL query.
     */
    public var sparql : String {
        get{
            return "\(subject.sparql) \(predicate.sparql) \(object.sparql)"
        }
    }
    
    // MARK: Initialisers
    
    /**
     Initialises a new `Statement` with the specified subject, predicate, and object.
     No named graphs are added for this statement.
    
     - parameter subject: The subject of the statement.
     - parameter predicate: The predicate of the statement.
     - parameter object: The object of the statement.
     */
    public convenience init(subject: Resource, predicate: URI, object: Value){
        self.init(subject: subject, predicate: predicate, object: object, ID: nil)
    }
    
    /**
     Initialises a new `Statement` with the specified subject, predicate, object, and in the
     specified named graphs.
     
     - parameter subject: The subject of the statement.
     - parameter predicate: The predicate of the statement.
     - parameter object: The object of the statement.
     - parameter namedGraph: A list of named graph to which this statement belongs.
     */
    public convenience init(subject: Resource, predicate: URI, object: Value, namedGraph: Resource...){
        self.init(subject: subject,predicate : predicate, object: object, ID: nil)
        self.namedGraphs.appendContentsOf(namedGraph)
    }
    
    /**
     Initialises a new `Statement` with the specified subject, predicate, and object.
     No named graphs are added for this statement.
     
     - parameter subject: The subject of the statement.
     - parameter predicate: The predicate of the statement.
     - parameter object: The object of the statement.
     - parameter ID: The identifier of the statement used for reification.
     */
    public init(subject: Resource, predicate: URI, object: Value, ID: Resource?){
        self.subject = subject
        self.predicate = predicate
        self.object = object
        self.ID = ID
    }
    
    /**
     Initialises a new `Statement` with the specified subject, predicate, object, and in the
     specified named graphs.
     
     - parameter subject: The subject of the statement.
     - parameter predicate: The predicate of the statement.
     - parameter object: The object of the statement.
     - parameter ID: The identifier of the statement used for reification.
     - parameter namedGraph: A list of named graph to which this statement belongs.
     */
    public init(subject: Resource, predicate: URI, object: Value, ID: Resource?, namedGraph: Resource...){
        self.subject = subject
        self.predicate = predicate
        self.object = object
        self.namedGraphs.appendContentsOf(namedGraph)
        self.ID = ID
    }
    
    /**
     Adds the statement to the specified named graph.
     
     - parameter namedGraph: The named graph to which the statement is added.
     */
    public func addToNamedGraph(namedGraph : Resource) {
        if !namedGraphs.contains({$0 == namedGraph}) {
            namedGraphs.append(namedGraph)
        }
    }
    
    /**
     Returns true when this statement is part of the specified graph.
    
     - parameter namedGraph: The named graph to be tested.
     - returns: True when the statement is part of the specified named graph, false otherwise.
     */
    public func inNamedGraph(namedGraph : Resource) -> Bool {
        return namedGraphs.contains({$0 == namedGraph})
    }
}

// MARK: Operators for Statements

/**
 This operator returns `true` when the Statements are equal, i.e. when
 their subjects, predicates, and objects are equal. If the statements are equal
 then the statements represent the same knowledge. The named graphs to which the 
 statements belong are ignored.
 
 - parameter left: The left Statement in the comparison.
 - parameter right: The right Statement in the comparison.
 - returns: True when the Statements are equal, false otherwise.
 */
public func == (left: Statement, right: Statement) -> Bool {
    if left.subject != right.subject {
        return false
    }
    if left.predicate != right.predicate {
        return false
    }
    if left.object != right.object {
        return false
    }
    return true
}

/**
 This operator returns `true` when the Statements are not equal, i.e. when either
 their subjects, predicates, and objects are not equal. If the statements are not equal,
 they represent different knowledge.
 The named graphs to which the statements belong are ignored.
 
 - parameter left: The left Statement in the comparison.
 - parameter right: The right Statement in the comparison.
 - returns: True when the Statements are not equal, false otherwise.
 */
public func != (left: Statement, right: Statement) -> Bool {
    return !(left == right)
}