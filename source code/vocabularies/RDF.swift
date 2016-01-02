//
//  RDF.swift
//  
//
//  Created by Don Willems on 26/11/15.
//
//

import Foundation


/**
 This vocabulary class defines static constant variables for each of the classes and properties
 defined in the [RDF vocabulary](http://www.w3.org/TR/rdf-schema/).
 */
public class RDF : Vocabulary {
    
    // MARK: RDF Namespace
    
    /// The namespace of the RDF vocabulary: `"http://www.w3.org/1999/02/22-rdf-syntax-ns#"`
    public static let NAMESPACE = "http://www.w3.org/1999/02/22-rdf-syntax-ns#"
    
    // MARK: RDF Classes
    
    /// Represents the class of XML literals.
    public static let XMLLiteral = Vocabulary.createURI(RDF.NAMESPACE, localName: "XMLLiteral")
    
    /// Represents the class of properties.
    public static let Property = Vocabulary.createURI( RDF.NAMESPACE, localName: "Property")
    
    /// Represents the class of RDF statements (containing a subject, predicate, and object).
    public static let Statement = Vocabulary.createURI( RDF.NAMESPACE, localName: "Statement")
    
    /// Represents a container of alternatives.
    public static let Alt = Vocabulary.createURI( RDF.NAMESPACE, localName: "Alt")
    
    /// Represents an unordered container.
    public static let Bag = Vocabulary.createURI( RDF.NAMESPACE, localName: "Bag")
    
    /// Represents an ordered container.
    public static let Seq = Vocabulary.createURI( RDF.NAMESPACE, localName: "Seq")
    
    /// Represents the class of RDF lists.
    public static let List = Vocabulary.createURI( RDF.NAMESPACE, localName: "List")
    
    /// Represents an empty list.
    public static let NIL = Vocabulary.createURI( RDF.NAMESPACE, localName: "nil")
    
    // MARK: RDF Properties
    
    /// Represents the type property that is used to assign a resource to a class.
    public static let type = Vocabulary.createURI( RDF.NAMESPACE, localName: "type")
    
    /// Represents the property that is used to specify the first item to a list.
    public static let first = Vocabulary.createURI( RDF.NAMESPACE, localName: "first")
    
    /// Represents the property that is used to assign the rest of a list after the first item, the object should be a list.
    public static let rest = Vocabulary.createURI( RDF.NAMESPACE, localName: "rest")
    
    /// Represents the idiomatic property that is used for structured values.
    public static let value = Vocabulary.createURI( RDF.NAMESPACE, localName: "value")
    
    /// Represents the property to assgin the subject of a statement.
    public static let subject = Vocabulary.createURI( RDF.NAMESPACE, localName: "subject")
    
    /// Represents the property to assgin the predicate of a statement.
    public static let predicate = Vocabulary.createURI( RDF.NAMESPACE, localName: "predicate")
    
    /// Represents the property to assgin the object of a statement.
    public static let object = Vocabulary.createURI( RDF.NAMESPACE, localName: "object")
}