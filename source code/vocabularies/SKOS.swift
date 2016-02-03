//
//  SKOS.swift
//  
//
//  Created by Don Willems on 03/02/16.
//
//

import Foundation

/**
 This vocabulary class defines static constant variables for each of the classes and properties
 defined in the [Simple Knowledge Organization System (SKOS)] vocabulary](https://www.w3.org/TR/2009/REC-skos-reference-20090818/#vocab).
 */
public class SKOS : Vocabulary {
    
    // MARK: SKOS Namespace
    
    /// The namespace of the SKOS vocabulary: `"http://www.w3.org/1999/02/22-rdf-syntax-ns#"`
    public static let NAMESPACE = "http://www.w3.org/2004/02/skos/core#"

    // MARK: SKOS Classes
    
    /**
     Represents a SKOS concept, an idea or notion, a unit of thought.
     */
    public static let Concept = Vocabulary.createURI(SKOS.NAMESPACE, localName: "Concept")
    
    /**
     Represents a SKOS concept scheme, an aggregation of one or more concepts.
     */
    public static let ConceptScheme = Vocabulary.createURI(SKOS.NAMESPACE, localName: "ConceptScheme")
    
    /**
     Represents a SKOS collection, a meaningfull collection of concepts.
     */
    public static let Collection = Vocabulary.createURI(SKOS.NAMESPACE, localName: "Collection")
    
    /**
     Represents a SKOS ordered collection, a meaningfull collection of ordered concepts.
     */
    public static let OrderedCollection = Vocabulary.createURI(SKOS.NAMESPACE, localName: "OrderedCollection")
    
    
    // MARK: SKOS Properties
    
    /**
     Relates a resource (e.g. a concept) to a concept scheme.
     */
    public static let inScheme = Vocabulary.createURI(SKOS.NAMESPACE, localName: "inScheme")
    
    /**
     Relates a concept to a concept scheme of which it is a top (root) concept.
     */
    public static let topConceptOf = Vocabulary.createURI(SKOS.NAMESPACE, localName: "topConceptOf")
    
    /**
     Relates a concept scheme to one of its top (root) concepts.
     */
    public static let hasTopConcept = Vocabulary.createURI(SKOS.NAMESPACE, localName: "hasTopConcept")
    
    /**
     Relates a concept to its preferred label in a given language.
     */
    public static let prefLabel = Vocabulary.createURI(SKOS.NAMESPACE, localName: "prefLabel")
    
    /**
     Relates a concept to an alternative label in a given language.
     */
    public static let altLabel = Vocabulary.createURI(SKOS.NAMESPACE, localName: "altLabel")
    
    /**
     Relates a concept to a lexical label that should be hidden in a visual representation.
     */
    public static let hiddenLabel = Vocabulary.createURI(SKOS.NAMESPACE, localName: "hiddenLabel")
    
    /**
     Relates a concept to a notation or classification code. A notation is different from a lexical 
     label in that a notation is not normally recognizable as a word or sequence of words in any natural language.
     */
    public static let notation = Vocabulary.createURI(SKOS.NAMESPACE, localName: "notation")
    
    /**
     Relates a concept to a general note.
     */
    public static let note = Vocabulary.createURI(SKOS.NAMESPACE, localName: "note")
    
    /**
     Relates a concept to a note about a modification to the concept.
     */
    public static let changeNote = Vocabulary.createURI(SKOS.NAMESPACE, localName: "changeNote")
    
    /**
     Relates a concept to a formal explanation of the meaning of the concept.
     */
    public static let definition = Vocabulary.createURI(SKOS.NAMESPACE, localName: "definition")
    
    /**
     Relates a concept to a note for the editor, translator, or maintainer of the vocabulary.
     */
    public static let editorialNote = Vocabulary.createURI(SKOS.NAMESPACE, localName: "editorialNote")
    
    /**
     Relates a concept to an example of the use of the concept.
     */
    public static let example = Vocabulary.createURI(SKOS.NAMESPACE, localName: "example")
    
    /**
     Relates a concept to a note about the past state/use/meaning of the concept.
     */
    public static let historyNote = Vocabulary.createURI(SKOS.NAMESPACE, localName: "historyNote")
    
    /**
     Relates a concept to a note that helps clarify the meaning and/or use of the concept.
     */
    public static let scopeNote = Vocabulary.createURI(SKOS.NAMESPACE, localName: "scopeNote")
    
    /**
     Relates a concept to another concept related by some meaning.
     */
    public static let semanticRelation = Vocabulary.createURI(SKOS.NAMESPACE, localName: "semanticRelation")
    
    /**
     A transitive superproperty of `skos:broader`, which relates a concept to another concept that is more general in meaning.
     */
    public static let broaderTransitive = Vocabulary.createURI(SKOS.NAMESPACE, localName: "broaderTransitive")
    
     /**
     Relates a concept to another concept that is more general in meaning.
     */
    public static let broader = Vocabulary.createURI(SKOS.NAMESPACE, localName: "broader")
    
    /**
     Relates a concept to another concept that is more general in meaning and is in a different concept scheme.
     */
    public static let broaderMatch = Vocabulary.createURI(SKOS.NAMESPACE, localName: "broaderMatch")
    
    /**
     A transitive superproperty of `skos:narrower`, which relates a concept to another concept that is more specific in meaning.
     */
    public static let narrowerTransitive = Vocabulary.createURI(SKOS.NAMESPACE, localName: "narrowerTransitive")
    
    /**
     Relates a concept to another concept that is more specific in meaning.
     */
    public static let narrower = Vocabulary.createURI(SKOS.NAMESPACE, localName: "narrower")
    
    /**
     Relates a concept to another concept that is more specific in meaning and is in a different concept scheme.
     */
    public static let narrowerMatch = Vocabulary.createURI(SKOS.NAMESPACE, localName: "narrowerMatch")
    
    /**
     Relates a concept to another concept that is related to the concept in an associative semantic relationship.
     */
    public static let related = Vocabulary.createURI(SKOS.NAMESPACE, localName: "related")
    
    /**
     Relates a concept to another concept that is related to the concept in an associative 
     semantic relationship and is in a different concept scheme.
     */
    public static let relatedMatch = Vocabulary.createURI(SKOS.NAMESPACE, localName: "relatedMatch")
    
    /**
     Relates a concept to another concept that has a comparable meaning and that is defined in a different concept scheme.
     */
    public static let mappingRelation = Vocabulary.createURI(SKOS.NAMESPACE, localName: "mappingRelation")
    
    /**
     Relates a concept to another concept that is sufficiently similar to be interchanged.
     */
    public static let closeMatch = Vocabulary.createURI(SKOS.NAMESPACE, localName: "closeMatch")
    
    /**
     Relates a concept to another concept that is similar with a high degree of confidence.
     */
    public static let exactMatch = Vocabulary.createURI(SKOS.NAMESPACE, localName: "exactMatch")
}