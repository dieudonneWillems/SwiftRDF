//
//  GraphTests.swift
//  SwiftRDF-OSX
//
//  Created by Don Willems on 08/01/16.
//  Copyright © 2016 lapsedpacifist. All rights reserved.
//

import XCTest
@testable import SwiftRDFOSX

import Foundation

class GraphTests : XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testAddStatements() {
        let graph = Graph()
        let namespace = "http://example.org/resource/my-ontology/"
        let apple = URI(namespace: namespace, localName: "Apple")!
        let pear = URI(namespace: namespace, localName: "Pear")!
        var statement = Statement(subject: apple, predicate: RDF.type, object: OWL.Class)
        graph.add(statement)
        XCTAssertTrue(graph.count == 1)
        XCTAssertEqual(statement, graph[0])
        statement = Statement(subject: pear, predicate: RDF.type, object: OWL.Class)
        graph.add(statement)
        XCTAssertTrue(graph.count == 2)
        graph.addStatement(apple, predicate: RDFS.label, object: Literal(stringValue: "apple", language: "nl")!)
        graph.addStatement(apple, predicate: RDFS.label, object: Literal(stringValue: "apple", language: "en")!)
        XCTAssertTrue(graph.count == 4)
        
        XCTAssertTrue(graph.resources.count == 3)
        XCTAssertTrue(graph.resources.contains({ $0 == apple}))
        XCTAssertTrue(graph.resources.contains({ $0 == pear}))
        XCTAssertTrue(graph.resources.contains({ $0 == OWL.Class}))
        XCTAssertTrue(graph.properties.count == 2)
        XCTAssertTrue(graph.properties.contains({ $0 == RDFS.label}))
        XCTAssertTrue(graph.properties.contains({ $0 == RDF.type}))
        
        var subgraph = graph.subGraph(apple, predicate: nil, object: nil)
        XCTAssertTrue(subgraph.count == 3)
        subgraph = graph.subGraph(nil, predicate: RDFS.label, object: nil)
        XCTAssertTrue(subgraph.count == 2)
    }
    
    func testMultipleNamedGraphs(){
        let namespace = "http://example.org/resource/my-ontology/"
        let applesURI = URI(namespace: namespace, localName: "apples")!
        let apples = Graph(name: applesURI)
        let fruitsURI = URI(namespace: namespace, localName: "fruits")!
        let notApplesURI = URI(namespace: namespace, localName: "not-apples")!
        let fruits = Graph(name: fruitsURI)
        let apple = URI(namespace: namespace, localName: "Apple")!
        apples.addStatement(apple, predicate: RDF.type, object: OWL.Class)
        apples.addStatement(apple, predicate: RDFS.label, object: Literal(stringValue: "apple", language: "nl")!)
        apples.addStatement(apple, predicate: RDFS.label, object: Literal(stringValue: "apple", language: "en")!)
        let goldenDelicious = URI(namespace: namespace, localName: "GoldenDelicious")!
        apples.addStatement(goldenDelicious, predicate: RDF.type, object: OWL.Class)
        apples.addStatement(goldenDelicious, predicate: RDFS.subClassOf, object: apple)
        apples.addStatement(goldenDelicious, predicate: RDFS.label, object: Literal(stringValue: "golden delicious", dataType: XSD.string)!)
        let elstar = URI(namespace: namespace, localName: "Elstar")!
        apples.addStatement(elstar, predicate: RDF.type, object: OWL.Class)
        apples.addStatement(elstar, predicate: RDFS.subClassOf, object: apple)
        apples.addStatement(elstar, predicate: RDFS.label, object: Literal(stringValue: "elstar", dataType: XSD.string)!)
        let fruit = URI(namespace: namespace, localName: "Fruit")!
        fruits.addStatement(fruit, predicate: RDF.type, object: OWL.Class, namedGraph: notApplesURI)
        fruits.addStatement(fruit, predicate: RDFS.label, object: Literal(stringValue: "fruit", language: "nl")!, namedGraph: notApplesURI)
        fruits.addStatement(fruit, predicate: RDFS.label, object: Literal(stringValue: "fruit", language: "en")!, namedGraph: notApplesURI)
        let pear = URI(namespace: namespace, localName: "Pear")!
        fruits.addStatement(pear, predicate: RDF.type, object: OWL.Class, namedGraph: notApplesURI)
        fruits.addStatement(pear, predicate: RDFS.subClassOf, object: fruit, namedGraph: notApplesURI)
        fruits.addStatement(pear, predicate: RDFS.label, object: Literal(stringValue: "peer", language: "nl")!, namedGraph: notApplesURI)
        fruits.addStatement(pear, predicate: RDFS.label, object: Literal(stringValue: "pear", language: "en")!, namedGraph: notApplesURI)
        apples.addStatement(apple, predicate: RDFS.subClassOf, object: fruit)
        
        fruits.add(apples)
        XCTAssertTrue(fruits.count == 17)
        
        var subgraph = fruits.subGraph(nil, predicate: RDFS.subClassOf, object: fruit)
        XCTAssertTrue(subgraph.count == 2)
        
        subgraph = fruits.subGraph(nil, predicate: nil, object: nil, namedGraph: applesURI)
        XCTAssertTrue(subgraph.count == 10)
        
        subgraph = fruits.subGraph(nil, predicate: nil, object: nil, namedGraph: fruitsURI)
        XCTAssertTrue(subgraph.count == 17)
        
        subgraph = fruits.subGraph(nil, predicate: nil, object: nil, namedGraph: notApplesURI)
        XCTAssertTrue(subgraph.count == 7)
        
        subgraph = fruits.subGraph(nil, predicate: nil, object: nil, namedGraph: applesURI,notApplesURI)
        XCTAssertTrue(subgraph.count == 17)
        
    }
    
    func testMergeGraphs(){
        let namespace = "http://example.org/resource/my-ontology/"
        let applesURI = URI(namespace: namespace, localName: "apples")!
        let apples = Graph(name: applesURI)
        let pearsURI = URI(namespace: namespace, localName: "pears")!
        let pears = Graph(name: pearsURI)
        let fruitsURI = URI(namespace: namespace, localName: "fruits")!
        let fruits = Graph(name: fruitsURI)
        
        let fruit = URI(namespace: namespace, localName: "Fruit")!
        fruits.addStatement(fruit, predicate: RDF.type, object: OWL.Class)
        fruits.addStatement(fruit, predicate: RDFS.label, object: Literal(stringValue: "fruit", language: "nl")!)
        fruits.addStatement(fruit, predicate: RDFS.label, object: Literal(stringValue: "fruit", language: "en")!)
        
        let apple = URI(namespace: namespace, localName: "Apple")!
        apples.addStatement(apple, predicate: RDF.type, object: OWL.Class)
        apples.addStatement(apple, predicate: RDFS.label, object: Literal(stringValue: "apple", language: "nl")!)
        apples.addStatement(apple, predicate: RDFS.label, object: Literal(stringValue: "apple", language: "en")!)
        apples.addStatement(apple, predicate: RDFS.subClassOf, object: fruit)
        let goldenDelicious = URI(namespace: namespace, localName: "GoldenDelicious")!
        apples.addStatement(goldenDelicious, predicate: RDF.type, object: OWL.Class)
        apples.addStatement(goldenDelicious, predicate: RDFS.subClassOf, object: apple)
        apples.addStatement(goldenDelicious, predicate: RDFS.label, object: Literal(stringValue: "golden delicious", dataType: XSD.string)!)
        let elstar = URI(namespace: namespace, localName: "Elstar")!
        apples.addStatement(elstar, predicate: RDF.type, object: OWL.Class)
        apples.addStatement(elstar, predicate: RDFS.subClassOf, object: apple)
        apples.addStatement(elstar, predicate: RDFS.label, object: Literal(stringValue: "elstar", dataType: XSD.string)!)
        
        let pear = URI(namespace: namespace, localName: "Pear")!
        pears.addStatement(pear, predicate: RDF.type, object: OWL.Class)
        pears.addStatement(pear, predicate: RDFS.subClassOf, object: fruit)
        pears.addStatement(pear, predicate: RDFS.label, object: Literal(stringValue: "peer", language: "nl")!)
        pears.addStatement(pear, predicate: RDFS.label, object: Literal(stringValue: "pear", language: "en")!)
        let conference = URI(namespace: namespace, localName: "Conference")!
        pears.addStatement(conference, predicate: RDF.type, object: OWL.Class)
        pears.addStatement(conference, predicate: RDFS.subClassOf, object: pear)
        pears.addStatement(conference, predicate: RDFS.label, object: Literal(stringValue: "Conference", dataType: XSD.string)!)
        
        let merged = Graph.merge(fruits,apples,pears)
        
        XCTAssertTrue(merged.resources.count == 7)
        XCTAssertTrue(merged.resources.contains({ $0 == fruit}))
        XCTAssertTrue(merged.resources.contains({ $0 == apple}))
        XCTAssertTrue(merged.resources.contains({ $0 == goldenDelicious}))
        XCTAssertTrue(merged.resources.contains({ $0 == elstar}))
        XCTAssertTrue(merged.resources.contains({ $0 == pear}))
        XCTAssertTrue(merged.resources.contains({ $0 == conference}))
        XCTAssertTrue(merged.resources.contains({ $0 == OWL.Class}))
        XCTAssertTrue(merged.properties.count == 3)
        XCTAssertTrue(merged.properties.contains({ $0 == RDFS.label}))
        XCTAssertTrue(merged.properties.contains({ $0 == RDFS.subClassOf}))
        XCTAssertTrue(merged.properties.contains({ $0 == RDF.type}))
        
        XCTAssertTrue(merged.count == 20)
        
        var subgraph = merged.subGraph(nil, predicate: nil, object: nil, namedGraph: applesURI)
        XCTAssertTrue(subgraph.count == 10)
        
        subgraph = merged.subGraph(nil, predicate: nil, object: nil, namedGraph: pearsURI)
        XCTAssertTrue(subgraph.count == 7)
        
        subgraph = merged.subGraph(nil, predicate: nil, object: nil, namedGraph: fruitsURI)
        XCTAssertTrue(subgraph.count == 3)
        
    }
    
    func testNamespaces() {
        let fruitsNS = "http://example.org/resource/fruits/"
        let vegetablesNS = "http://example.org/resource/vegetables/"
        let fruitsURI = URI(string: fruitsNS)!
        let fruits = Graph(name: fruitsURI)
        let vegetablesURI = URI(string: vegetablesNS)!
        let vegetables = Graph(name: vegetablesURI)
        
        fruits.addNamespace("fruits", namespaceURI: fruitsNS)
        
        vegetables.addNamespace("veg", namespaceURI: vegetablesNS)
        vegetables.addNamespace("frt", namespaceURI: fruitsNS)
        
        let appleURI = URI(namespace: fruitsNS, localName: "apple")!
        fruits.addStatement(appleURI, predicate: RDF.type, object: OWL.Class)
        
        let cabbageURI = URI(namespace: vegetablesNS, localName: "cabbage")!
        vegetables.addStatement(cabbageURI, predicate: RDF.type, object: OWL.Class)
        
        XCTAssertTrue(fruits.namespacePrefixes.count == 1)
        XCTAssertTrue(vegetables.namespacePrefixes.count == 2)
        
        XCTAssertEqual("fruits:apple", fruits.qualifiedName(appleURI))
        XCTAssertNil(fruits.qualifiedName(cabbageURI))
        XCTAssertEqual("veg:cabbage", vegetables.qualifiedName(cabbageURI))
        
        vegetables.add(fruits)
        XCTAssertTrue(vegetables.namespacePrefixes.count == 3)
        XCTAssertTrue(vegetables.allQualifiedNames(appleURI).contains("frt:apple"))
        XCTAssertTrue(vegetables.allQualifiedNames(appleURI).contains("fruits:apple"))
        XCTAssertEqual("veg:cabbage", vegetables.qualifiedName(cabbageURI))
        XCTAssertTrue(appleURI == vegetables.createURIFromQualifiedName("frt:apple")!)
        XCTAssertTrue(appleURI == vegetables.createURIFromQualifiedName("fruits:apple")!)
        XCTAssertTrue(cabbageURI == vegetables.createURIFromQualifiedName("veg:cabbage")!)
        XCTAssertNil(vegetables.createURIFromQualifiedName("vegetables:cabbage"))
        XCTAssertNotNil(vegetables.createURIFromQualifiedName("veg:pea"))
        
        let peaURI = URI(namespace: vegetablesNS, localName: "pea")!
        XCTAssertTrue(peaURI == vegetables.createURIFromQualifiedName("veg:pea")!)
        
        let subgraph = vegetables.subGraph(nil, predicate: nil, object: nil, namedGraph: fruitsURI)
        XCTAssertTrue(subgraph.namespacePrefixes.count == 3)
        XCTAssertTrue(peaURI == subgraph.createURIFromQualifiedName("veg:pea")!)
    }
    
}