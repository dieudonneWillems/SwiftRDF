//
//  TurtleFormatterTest.swift
//  SwiftRDF-OSX
//
//  Created by Don Willems on 23/02/16.
//  Copyright © 2016 lapsedpacifist. All rights reserved.
//

import Foundation

import XCTest
@testable import SwiftRDFOSX

class TurtleFormatterTests: XCTestCase {
    
    func testSet1() {
        let graph = Graph()
        graph.addNamespace("rdf", namespaceURI: RDF.NAMESPACE)
        graph.addNamespace("rdfs", namespaceURI: RDFS.NAMESPACE)
        graph.addNamespace("owl", namespaceURI: OWL.NAMESPACE)
        graph.addNamespace("fruit", namespaceURI: "http://www.example.org/resource/fruits/")
        let namedgraph = URI(string: "http://www.example.org/set1")!
        let apple = URI(string: "http://www.example.org/resource/fruits/apple")!
        let applePie = URI(string: "http://www.example.org/resource/pies/applePie")!
        let hasIngredient = URI(string: "http://www.example.org/resource/recipe/hasIngredient")!
        graph.addStatement(apple, predicate: RDF.type, object: OWL.Class, namedGraph: namedgraph)
        graph.addStatement(apple, predicate: RDFS.label, object: Literal(sparqlString: "\"apple\"@en")!, namedGraph: namedgraph)
        graph.addStatement(apple, predicate: RDFS.label, object: Literal(sparqlString: "\"appel\"@nl")!, namedGraph: namedgraph)
        graph.addStatement(applePie, predicate: RDF.type, object: OWL.Class, namedGraph: namedgraph)
        graph.addStatement(applePie, predicate: RDFS.label, object: Literal(sparqlString: "\"applepie\"@en")!, namedGraph: namedgraph)
        graph.addStatement(applePie, predicate: RDFS.label, object: Literal(sparqlString: "\"appeltaart\"@nl")!, namedGraph: namedgraph)
        graph.addStatement(applePie, predicate: hasIngredient, object: apple, namedGraph: namedgraph)
        let formatter = TurtleFormatter()
        let string = formatter.string(graph)
        print("\n\(string)\n")
    }
}
