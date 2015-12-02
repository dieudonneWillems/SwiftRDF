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
    
    // MARK: OWL Namespace
    
    /// The namespace of the OWL vocabulary: `"http://www.w3.org/1999/02/22-rdf-syntax-ns#"`
    public static let NAMESPACE = "http://www.w3.org/2002/07/owl#"
    
    // MARK: OWL Classes
    
    /**
     Represents the OWL class AllDifferent, is a special built-in OWL class, for which the 
     property owl:distinctMembers is defined, which links an instance of owl:AllDifferent 
     to a list of individuals. The intended meaning of such a statement is that all individuals 
     in the list are all different from each other.
    */
    public static let AllDifferent = Vocabulary.createURI(OWL.NAMESPACE, localName: "AllDifferent")
    
    /**
     Represents the OWL class AnnotationProperty. An annotation property is used to provide meta
     data to a resource such as the name (using `rdfs:label`) or description (e.g. `rdfs":comment`).
     */
    public static let AnnotationProperty = Vocabulary.createURI(OWL.NAMESPACE, localName: "AnnotationProperty")
    
    /**
     Represents the OWL class Class, which is used to define a class.
     */
    public static let Class = Vocabulary.createURI(OWL.NAMESPACE, localName: "Class")
    
    /**
     Represents the OWL class DataRange, which is used to specify a range of data that can be assigned to a property.
     */
    public static let DataRange = Vocabulary.createURI(OWL.NAMESPACE, localName: "DataRange")
    
    /**
     Represents the OWL class DatatypeProperty. A datatype property is used to assign literal values to resources.
     */
    public static let DatatypeProperty = Vocabulary.createURI(OWL.NAMESPACE, localName: "DatatypeProperty")
    
    /**
     Represents the OWL class DeprecatedClass, which is used to define a class that is deprecated, i.e.
     is supported for backward compatability in the current version of the ontology but may be phased out in
     future versions.
     */
    public static let DeprecatedClass = Vocabulary.createURI(OWL.NAMESPACE, localName: "DeprecatedClass")
    
    /**
     Represents the OWL class DeprecatedProperty, which is used to define a property that is deprecated, i.e.
     is supported for backward compatability in the current version of the ontology but may be phased out in
     future versions.
     */
    public static let DeprecatedProperty = Vocabulary.createURI(OWL.NAMESPACE, localName: "DeprecatedProperty")
    
    /**
     Represents the OWL class FunctionalProperty. Functional properties can have only one value for each 
     instance.
     */
    public static let FunctionalProperty = Vocabulary.createURI(OWL.NAMESPACE, localName: "FunctionalProperty")
    
    /**
     Represents the OWL class FunctionalProperty. Functional properties can have only one value for each
     instance.
     */
    public static let InverseFunctionalProperty = Vocabulary.createURI(OWL.NAMESPACE, localName: "InverseFunctionalProperty")
    
    /**
     Represents the OWL class Nothing, which represents the empty set of instances.
     */
    public static let Nothing = Vocabulary.createURI(OWL.NAMESPACE, localName: "Nothing")
    
    /**
     Represents the OWL class ObjectProperty. An object property assigns an instance (not a literal) to a resource.
     */
    public static let ObjectProperty = Vocabulary.createURI(OWL.NAMESPACE, localName: "ObjectProperty")
    
    /**
     Represents the OWL class Ontology. Instances of this class contain (meta)information about the ontology. The base URI
     is used as the URI for the ontology.
     */
    public static let Ontology = Vocabulary.createURI(OWL.NAMESPACE, localName: "Ontology")
    
    /**
     Represents the OWL class OntologyProperty. An ontology property relates two instances of `owl:Ontology` with each other.
     */
    public static let OntologyProperty = Vocabulary.createURI(OWL.NAMESPACE, localName: "OntologyProperty")
    
    /**
     Represents the OWL class Restriction. Restriction is defined as a subclass of `owl:Class` and is used to define a 
     restriction on a property.
     */
    public static let Restriction = Vocabulary.createURI(OWL.NAMESPACE, localName: "Restriction")
    
    /**
     Represents the OWL class SymmetricProperty. An symmetric property is a property for which if `x property y` holds,
     the triple 'y property x' also holds.
     */
    public static let SymmetricProperty = Vocabulary.createURI(OWL.NAMESPACE, localName: "SymmetricProperty")
    
    /**
     Represents the OWL class Thing, which represents the set of all instances.
     */
    public static let Thing = Vocabulary.createURI(OWL.NAMESPACE, localName: "Thing")
    
    /**
     Represents the OWL class TransitiveProperty. A transative property P is a property for which the following holds: 
     if a pair (x,y) is an instance of P, and the pair (y,z) is also instance of P, then we can infer the the pair (x,z) is also an instance of P.
     */
    public static let TransitiveProperty = Vocabulary.createURI(OWL.NAMESPACE, localName: "TransitiveProperty")
    
    
    
    
    // MARK: OWL Properties
    
}