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
    
    /**
     Represents the OWL property allValuesFrom, which is used to link a `OWL.Restriction` to a a class description
     or a datarange.  A restriction containing an `owl:allValuesFrom` constraint is used to describe a class of all
     instances for which all values of the property under consideration are either members of the class extension
     of the class description or are data values within the specified data range
    */
    public static let allValuesFrom = Vocabulary.createURI(OWL.NAMESPACE, localName: "allValuesFrom")
    
    /**
     Represents the OWL property backwardCompatibleWith, which specifies previous versions of the ontology that
     are backward compatible with the current version.
     */
    public static let backwardCompatibleWith = Vocabulary.createURI(OWL.NAMESPACE, localName: "backwardCompatibleWith")
    
    /**
     Represents the OWL property cardinality, which specifies the number of distinct values a property needs to have
     for a resource.
     */
    public static let cardinality = Vocabulary.createURI(OWL.NAMESPACE, localName: "cardinality")
    
    /**
     Represents the OWL property complementOf that describes a class that is the complement of another class. 
     The complement class contains exactly those instances that do not belong to the object class. It is equivalent to
     logical negation.
     */
    public static let complementOf = Vocabulary.createURI(OWL.NAMESPACE, localName: "complementOf")
    
    /**
     Represents the OWL property differentFrom, which is used to specify that an instance is not the same 
     as another instance.
     */
    public static let differentFrom = Vocabulary.createURI(OWL.NAMESPACE, localName: "differentFrom")
    
    /**
     Represents the OWL property disjointWith. Each `owl:disjointWith` statement asserts that the class
     extensions of the two class descriptions involved have no instances in common.
     */
    public static let disjointWith = Vocabulary.createURI(OWL.NAMESPACE, localName: "disjointWith")
    
    /**
     Represents the OWL property distinctMembers. Should always be used wih `owl:AllDifferent` (`OWL.AllDifferent`)
     to define distinct individuals in a list.
     */
    public static let distinctMembers = Vocabulary.createURI(OWL.NAMESPACE, localName: "distinctMembers")
    
    /**
     Represents the OWL property equivalentClass, used to define an equivalent class for a class. Both classes should
     contain the same set of instances. These classes are however not necessarily the same concept.
     */
    public static let equivalentClass = Vocabulary.createURI(OWL.NAMESPACE, localName: "equivalentClass")
    
    /**
     Represents the OWL property equivalentProperty, used to define an equivalent property for a property. 
     Both properties should contain the same set of values. These properties are however not necessarily the same concept.
     */
    public static let equivalentProperty = Vocabulary.createURI(OWL.NAMESPACE, localName: "equivalentProperty")
    
    /**
     Represents the OWL property hasValue, which is used in `owl:Restriction` to restrict the values of a property
     to a specific value.
     */
    public static let hasValue = Vocabulary.createURI(OWL.NAMESPACE, localName: "hasValue")
    
    /**
     Represents the OWL property imports, which is used to import the concepts/meaning of one ontology into 
     the present ontology.
     */
    public static let imports = Vocabulary.createURI(OWL.NAMESPACE, localName: "imports")
    
    /**
     Represents the OWL property incompatibleWith, which specifies that an ontology is incompatible 
     (and thus not backward compatible with) the present ontology.
     */
    public static let incompatibleWith = Vocabulary.createURI(OWL.NAMESPACE, localName: "incompatibleWith")
    
    /**
     Represents the OWL property intersectionOf, which describes a class for which the class extension 
     contains precisely those instances that are members of the class extension of all class descriptions in the list.
     */
    public static let intersectionOf = Vocabulary.createURI(OWL.NAMESPACE, localName: "intersectionOf")
    
    /**
     Represents the OWL property inverseOf, which is used to define the inverse property of the current property.
     */
    public static let inverseOf = Vocabulary.createURI(OWL.NAMESPACE, localName: "inverseOf")
    
    /**
     Represents the OWL property maxCardinality, which specifies the maximum number of distinct values a 
     property needs to have for a resource.
     */
    public static let maxCardinality = Vocabulary.createURI(OWL.NAMESPACE, localName: "maxCardinality")
    
    /**
     Represents the OWL property minCardinality, which specifies the minimum number of distinct values a
     property needs to have for a resource.
     */
    public static let minCardinality = Vocabulary.createURI(OWL.NAMESPACE, localName: "minCardinality")
    
    /**
     Represents the OWL property oneOf, which is used to exhaustively list all instances of a class.
     */
    public static let oneOf = Vocabulary.createURI(OWL.NAMESPACE, localName: "oneOf")
    
    /**
     Represents the OWL property onProperty, which is used to restrict an `owl:Restriction` to a specific
     property. Only on property can be defined per restriction.
     */
    public static let onProperty = Vocabulary.createURI(OWL.NAMESPACE, localName: "onProperty")
    
    /**
     Represents the OWL property priorVersion, which specifies the prior version of the ontology.
     */
    public static let priorVersion = Vocabulary.createURI(OWL.NAMESPACE, localName: "priorVersion")
    
    /**
     Represents the OWL property sameAs, used to specify that two instances (or classes, or properties) are the same.
     Both instances are the same concept.
     */
    public static let sameAs = Vocabulary.createURI(OWL.NAMESPACE, localName: "sameAs")
    
    /**
     Represents the OWL property someValuesFrom, which is used to link a `OWL.Restriction` to a a class description
     or a datarange.  A restriction containing an `owl:someValuesFrom` constraint describes a class of all instances
     for which at least one value of the property concerned is an instance of the class description or a data value
     in the data range.
     */
    public static let someValuesFrom = Vocabulary.createURI(OWL.NAMESPACE, localName: "someValuesFrom")
    
    /**
     Represents the OWL property unionOf, which describes a class for which the class extension
     contains all those instances that are members of one of the class descriptions in the list.
     */
    public static let unionOf = Vocabulary.createURI(OWL.NAMESPACE, localName: "unionOf")
    
    /**
     Represents the OWL property versionInfo, which gives information about the version of the current ontology,
     such as the version number or SVN/GIT keywords.    
     */
    public static let versionInfo = Vocabulary.createURI(OWL.NAMESPACE, localName: "versionInfo")
    
}