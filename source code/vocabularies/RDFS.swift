//
//  RDFS.swift
//  
//
//  Created by Don Willems on 30/11/15.
//
//

import Foundation


/**
 This vocabulary class defines static constant variables for each of the classes and properties
 defined in the [RDFS vocabulary](http://www.w3.org/TR/rdf-schema/).
 */
public class RDFS : Vocabulary {
    
    // MARK: RDFS Namespace
    
    /// The namespace of the RDFS vocabulary: `"http://www.w3.org/1999/02/22-rdf-syntax-ns#"`
    public static let NAMESPACE = "http://www.w3.org/2000/01/rdf-schema#"
    
    // MARK: RDFS Classes
    
    /// Represents the class of resources.
    public static let Resource = Vocabulary.createURI(RDFS.NAMESPACE, localName: "Resource")
    
    /// Represents the class of classes.
    public static let Class = Vocabulary.createURI(RDFS.NAMESPACE, localName: "Class")
    
    /** 
      Represents the class of literal values such as strings and integers.
      Property values such as textual strings are examples of RDF literals. Literals may be plain or typed.
     */
    public static let Literal = Vocabulary.createURI(RDFS.NAMESPACE, localName: "Literal")
    
    /**
      Represents the class of datatypes.
     */
    public static let Datatype = Vocabulary.createURI(RDFS.NAMESPACE, localName: "Datatype")
    
    
    // MARK: RDFS Properties
    
    /// Represents the label property of a resource. Is used to provide a human-readable name to the resource.
    public static let label = Vocabulary.createURI(RDFS.NAMESPACE, localName: "label")
    
    /// Represents the comment property of a resource. Is used to provide a human-readable description to the resource.
    public static let comment = Vocabulary.createURI(RDFS.NAMESPACE, localName: "comment")
    
    /// Represents the subClassOf property that is used to define the superclass of an `RDFS.Class`.
    public static let subClassOf = Vocabulary.createURI(RDFS.NAMESPACE, localName: "subClassOf")
    
    /// Represents the subPropertyOf property that is used to define the superproperty of an `RDF.Property`.
    public static let subPropertyOf = Vocabulary.createURI(RDFS.NAMESPACE, localName: "subPropertyOf")
    
    /** 
     Represents the domain property that is used to define which type of (class) resources can be used
     as a subject of a triple for a specific property, i.e. a domain is specified for a property.
     */
    public static let domain = Vocabulary.createURI(RDFS.NAMESPACE, localName: "domain")
    
    /**
     Represents the range property that is used to define which type of (class) resources can be used
     as an object of a triple for a specific property, i.e. a range is specified for a property.
     */
    public static let range = Vocabulary.createURI(RDFS.NAMESPACE, localName: "range")
}
