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
            graph.addStatement(statement)
            XCTAssertTrue(graph.count == 1)
            XCTAssertEqual(statement, graph[0])
            statement = Statement(subject: pear, predicate: RDF.type, object: OWL.Class)
            graph.addStatement(statement)
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
    
}