//
//  BlankNode.swift
//  
//
//  Created by Don Willems on 20/11/15.
//
//

import Foundation

/**
 
 A Blank Node is used in RDF to represent a specific resource in the RDF graph. A resource represented
 by a blank node is an anonymous resource. In contrast, a `URI` represents (an identifier to) a resource
 and can be used across different scopes and in different ontologies.
 
 A blank node has an identifier but that identifier is only
 valid within the scope it is defined and should, therefore, not be referenced outside that scope.
 A Blank node can only be compared (outside of its scope) by the statements pointing to the resource.
 
 */
public class BlankNode: Resource {
    
    private static var counter = 1
    
    // MARK: Properties
    
    /**
     The identifier of the blank node. This identifier is only valid within the scope of the blank
     node and should not be used outside this scope.
    */
    public private(set) var identifier : String
    
    // MARK: SPARQL properties
    
    /**
    The representation of this blank `node as used in a SPARQL query.
    */
    public override var sparql : String {
        get{
            return "_:\(self.identifier)"
        }
    }
    
    // MARK: Initialisers
    
    /**
     Initialises a new Blank Node. The identifier of this node is generated automatically during
     initialisation and is of the form `bn[UUID]` where `[UUID]` is generated.
    */
    public init() {
        self.identifier = "bn\(BlankNode.counter)"
        super.init(stringValue: identifier)
        BlankNode.counter++
    }
    
    /**
     Initialises a new Blank Node with the specified identifier. This identifier is only
     valid within the scope of the blank node and should not be referenced outside this scope.
     
     - parameter identifier: The identifier of the blank node in its scope.
    */
    public init(identifier : String) {
        self.identifier = identifier
        super.init(stringValue: identifier)
    }
    
}

/**
 Compares two blank nodes and returns true when both have the same identifier.
 Keep in mind that the identifier of a blank node is only valid within its scope. Blank
 nodes that come from different scopes should not be compared.
 
 - parameter left: The first blank node used in the comparisson.
 - parameter right: The second blank node used in the comparisson.
 
 - returns: True when the identifier of both blank nodes are equal, or false otherwise.
 
 */
public func == (left: BlankNode, right: BlankNode) -> Bool {
    return left.identifier == right.identifier
}