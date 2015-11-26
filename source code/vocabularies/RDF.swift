//
//  RDF.swift
//  
//
//  Created by Don Willems on 26/11/15.
//
//

import Foundation


public class RDF : Vocabulary {
    
    // MARK: RDF Namespace
    public static let NAMESPACE = "http://www.w3.org/1999/02/22-rdf-syntax-ns#"
    
    // MARK: RDF Classes
    public static let XMLLiteral = Vocabulary.createURI(RDF.NAMESPACE, localName: "XMLLiteral")
    public static let Property = Vocabulary.createURI( RDF.NAMESPACE, localName: "Property")
    public static let Statement = Vocabulary.createURI( RDF.NAMESPACE, localName: "Statement")
    public static let Alt = Vocabulary.createURI( RDF.NAMESPACE, localName: "Alt")
    public static let Bag = Vocabulary.createURI( RDF.NAMESPACE, localName: "Bag")
    public static let Seq = Vocabulary.createURI( RDF.NAMESPACE, localName: "Seq")
    public static let List = Vocabulary.createURI( RDF.NAMESPACE, localName: "List")
    public static let NIL = Vocabulary.createURI( RDF.NAMESPACE, localName: "nil")
    
    // MARK: RDF Properties
    public static let type = Vocabulary.createURI( RDF.NAMESPACE, localName: "type")
    public static let first = Vocabulary.createURI( RDF.NAMESPACE, localName: "first")
    public static let rest = Vocabulary.createURI( RDF.NAMESPACE, localName: "rest")
    public static let value = Vocabulary.createURI( RDF.NAMESPACE, localName: "value")
    public static let subject = Vocabulary.createURI( RDF.NAMESPACE, localName: "subject")
    public static let predicate = Vocabulary.createURI( RDF.NAMESPACE, localName: "predicate")
    public static let object = Vocabulary.createURI( RDF.NAMESPACE, localName: "object")
}