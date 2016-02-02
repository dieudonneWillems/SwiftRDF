//
//  Value.swift
//  
//
//  Created by Don Willems on 20/11/15.
//
//

import Foundation

/**
 Represents a value, which can be a resource or a literal value, in an RDF graph.
 It is the superclass of all RDF model objects.
 */
public class Value : SPARQLValue, CustomStringConvertible  {
    
    
    /**
     A textual representation of the Value. This is equal to the SPARQL string (i.e. `sparql`).
     */
    public var description: String {
        return self.sparql
    }
    
    /**
     The string representation of the value.
     */
    public private(set) var stringValue : String
    
    /**
     The SPARQL string representation of the value.
     For `Value`, this is the empty string, subclasses need to provide an alternative representation.
     */
    public var sparql : String {
        get{
            return ""
        }
    }
    
    /**
     Initialises a new `Value` object with the specified string representation. This intialiser should
     only be used by subclasses.
     
     - parameter stringValue: The string representation of the `Value`.
     */
    public init(stringValue : String) {
        self.stringValue = stringValue
    }
    
}

/**
 This operator returns `true` when both values are the same instance.
 
 - parameter left: The left value in the comparison.
 - parameter right: The right value in the comparison.
 - returns: True when the values are equal, false otherwise.
 */
public func == (left: Value, right: Value) -> Bool {
    if let leftURI = left as? URI {
        if let rightURI = right as? URI {
            return leftURI == rightURI
        }
    }
    if let leftBN = left as? BlankNode {
        if let rightBN = right as? BlankNode {
            return leftBN == rightBN
        }
    }
    if let leftLiteral = left as? Literal {
        if let rightLiteral = right as? Literal {
            return leftLiteral == rightLiteral
        }
    }
    return left === right
}


/**
 This operator returns `true` when both values are not the same instance.
 
 - parameter left: The left value in the comparison.
 - parameter right: The right value in the comparison.
 - returns: True when the values are not equal, false otherwise.
 */
public func != (left: Value, right: Value) -> Bool {
    return !(left == right)
}