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
        do {
            let namespace = "http://example.org/resource/my-ontology/"
            let apple = try URI(namespace: namespace, localName: "Apple")
            let pear = try URI(namespace: namespace, localName: "Pear")
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
            var subgraph = graph.subGraph(apple, predicate: nil, object: nil)
            XCTAssertTrue(subgraph.count == 3)
            subgraph = graph.subGraph(nil, predicate: RDFS.label, object: nil)
            XCTAssertTrue(subgraph.count == 2)
        } catch {
            XCTFail()
        }
    }
    
    func testMultipleNamedGraphs(){
        do {
            let namespace = "http://example.org/resource/my-ontology/"
            let applesURI = try URI(namespace: namespace, localName: "apples");
            let apples = Graph(name: applesURI)
            let fruitsURI = try URI(namespace: namespace, localName: "fruits")
            let notApplesURI = try URI(namespace: namespace, localName: "not-apples")
            let fruits = Graph(name: fruitsURI)
            let apple = try URI(namespace: namespace, localName: "Apple")
            apples.addStatement(apple, predicate: RDF.type, object: OWL.Class)
            apples.addStatement(apple, predicate: RDFS.label, object: Literal(stringValue: "apple", language: "nl")!)
            apples.addStatement(apple, predicate: RDFS.label, object: Literal(stringValue: "apple", language: "en")!)
            let goldenDelicious = try URI(namespace: namespace, localName: "GoldenDelicious")
            apples.addStatement(goldenDelicious, predicate: RDF.type, object: OWL.Class)
            apples.addStatement(goldenDelicious, predicate: RDFS.subClassOf, object: apple)
            apples.addStatement(goldenDelicious, predicate: RDFS.label, object: Literal(stringValue: "golden delicious", dataType: XSD.string)!)
            let elstar = try URI(namespace: namespace, localName: "Elstar")
            apples.addStatement(elstar, predicate: RDF.type, object: OWL.Class)
            apples.addStatement(elstar, predicate: RDFS.subClassOf, object: apple)
            apples.addStatement(elstar, predicate: RDFS.label, object: Literal(stringValue: "elstar", dataType: XSD.string)!)
            let fruit = try URI(namespace: namespace, localName: "Fruit")
            fruits.addStatement(fruit, predicate: RDF.type, object: OWL.Class, namedGraph: notApplesURI)
            fruits.addStatement(fruit, predicate: RDFS.label, object: Literal(stringValue: "fruit", language: "nl")!, namedGraph: notApplesURI)
            fruits.addStatement(fruit, predicate: RDFS.label, object: Literal(stringValue: "fruit", language: "en")!, namedGraph: notApplesURI)
            let pear = try URI(namespace: namespace, localName: "Pear")
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
            
        } catch {
            XCTFail()
        }
    }
    
    func testMergeGraphs(){
        do {
            let namespace = "http://example.org/resource/my-ontology/"
            let applesURI = try URI(namespace: namespace, localName: "apples");
            let apples = Graph(name: applesURI)
            let pearsURI = try URI(namespace: namespace, localName: "pears");
            let pears = Graph(name: pearsURI)
            let fruitsURI = try URI(namespace: namespace, localName: "fruits")
            let fruits = Graph(name: fruitsURI)
            
            let fruit = try URI(namespace: namespace, localName: "Fruit")
            fruits.addStatement(fruit, predicate: RDF.type, object: OWL.Class)
            fruits.addStatement(fruit, predicate: RDFS.label, object: Literal(stringValue: "fruit", language: "nl")!)
            fruits.addStatement(fruit, predicate: RDFS.label, object: Literal(stringValue: "fruit", language: "en")!)
            
            let apple = try URI(namespace: namespace, localName: "Apple")
            apples.addStatement(apple, predicate: RDF.type, object: OWL.Class)
            apples.addStatement(apple, predicate: RDFS.label, object: Literal(stringValue: "apple", language: "nl")!)
            apples.addStatement(apple, predicate: RDFS.label, object: Literal(stringValue: "apple", language: "en")!)
            apples.addStatement(apple, predicate: RDFS.subClassOf, object: fruit)
            let goldenDelicious = try URI(namespace: namespace, localName: "GoldenDelicious")
            apples.addStatement(goldenDelicious, predicate: RDF.type, object: OWL.Class)
            apples.addStatement(goldenDelicious, predicate: RDFS.subClassOf, object: apple)
            apples.addStatement(goldenDelicious, predicate: RDFS.label, object: Literal(stringValue: "golden delicious", dataType: XSD.string)!)
            let elstar = try URI(namespace: namespace, localName: "Elstar")
            apples.addStatement(elstar, predicate: RDF.type, object: OWL.Class)
            apples.addStatement(elstar, predicate: RDFS.subClassOf, object: apple)
            apples.addStatement(elstar, predicate: RDFS.label, object: Literal(stringValue: "elstar", dataType: XSD.string)!)
            
            let pear = try URI(namespace: namespace, localName: "Pear")
            pears.addStatement(pear, predicate: RDF.type, object: OWL.Class)
            pears.addStatement(pear, predicate: RDFS.subClassOf, object: fruit)
            pears.addStatement(pear, predicate: RDFS.label, object: Literal(stringValue: "peer", language: "nl")!)
            pears.addStatement(pear, predicate: RDFS.label, object: Literal(stringValue: "pear", language: "en")!)
            let conference = try URI(namespace: namespace, localName: "Conference")
            pears.addStatement(conference, predicate: RDF.type, object: OWL.Class)
            pears.addStatement(conference, predicate: RDFS.subClassOf, object: pear)
            pears.addStatement(conference, predicate: RDFS.label, object: Literal(stringValue: "Conference", dataType: XSD.string)!)
            
            let merged = Graph.merge(fruits,apples,pears)
            
            XCTAssertTrue(merged.count == 20)
            
            var subgraph = merged.subGraph(nil, predicate: nil, object: nil, namedGraph: applesURI)
            XCTAssertTrue(subgraph.count == 10)
            
            subgraph = merged.subGraph(nil, predicate: nil, object: nil, namedGraph: pearsURI)
            XCTAssertTrue(subgraph.count == 7)
            
            subgraph = merged.subGraph(nil, predicate: nil, object: nil, namedGraph: fruitsURI)
            XCTAssertTrue(subgraph.count == 3)
            
        } catch {
            XCTFail()
        }
    }
    
}