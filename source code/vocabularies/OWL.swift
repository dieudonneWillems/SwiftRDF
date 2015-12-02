//
//  OWL.swift
//  
//
//  Created by Don Willems on 02/12/15.
//
//

import Foundation



/**
 This vocabulary class defines static constant variables for each of the classes and properties
 defined in the [OWL vocabulary](http://www.w3.org/TR/rdf-schema/).
 */
public class OWL : Vocabulary {
    
    // MARK: RDF Namespace
    
    /// The namespace of the OWL vocabulary: `"http://www.w3.org/1999/02/22-rdf-syntax-ns#"`
    public static let NAMESPACE = "http://www.w3.org/2002/07/owl#"
    
    // MARK: OWL Classes
    
    /**
     Represents the OWL class AllDifferent, is a special built-in OWL class, for which the 
     property owl:distinctMembers is defined, which links an instance of owl:AllDifferent 
     to a list of individuals. The intended meaning of such a statement is that all individuals 
     in the list are all different from each other.
    */
    public static let AllDifferent = Vocabulary.createURI(RDF.NAMESPACE, localName: "AllDifferent")
    
    /**
     Represents the OWL class AnnotationProperty. An annotation property is used to provide meta
     data to a resource such as the name (using `rdfs:label`) or description (e.g. `rdfs":comment`).
     */
    public static let AnnotationProperty = Vocabulary.createURI(RDF.NAMESPACE, localName: "AnnotationProperty")
    
    /**
     Represents the OWL class Class, which is used to define a class.
     */
    public static let Class = Vocabulary.createURI(RDF.NAMESPACE, localName: "Class")
    
    /**
     Represents the OWL class DataRange, which is used to specify a range of data that can be assigned to a property.
     */
    public static let DataRange = Vocabulary.createURI(RDF.NAMESPACE, localName: "DataRange")
    
}