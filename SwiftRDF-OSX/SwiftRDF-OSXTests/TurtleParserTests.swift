//
//  TurtleParserTests.swift
//  SwiftRDF-OSX
//
//  Created by Don Willems on 07/02/16.
//  Copyright © 2016 lapsedpacifist. All rights reserved.
//

import XCTest
@testable import SwiftRDFOSX

class TurtleParserTests: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock {
            // Put the code you want to measure the time of here.
        }
    }
    
    func testExample2() {
        let rdf = "<http://example.org/#spiderman> <http://www.perceive.net/schemas/relationship/enemyOf> <http://example.org/#green-goblin> ."
        let data = rdf.dataUsingEncoding(NSUTF8StringEncoding)
        let name = URI(string: "https://www.w3.org/TR/turtle/example-2")
        let parser = TurtleParser(data: data!, baseURI: name!)
        parser.delegate = TestRDFParserDelegate()
        let graph = parser.parse()
        XCTAssertEqual(0, graph?.namespaces.count)
        XCTAssertEqual(1, graph?.statements.count)
        if graph?.statements.count == 1 {
            XCTAssertTrue(graph![0].subject == URI(string: "http://example.org/#spiderman")!)
            XCTAssertTrue(graph![0].predicate == URI(string: "http://www.perceive.net/schemas/relationship/enemyOf")!)
            XCTAssertTrue(graph![0].object == URI(string: "http://example.org/#green-goblin")!)
        }
    }
    
    func testExample3() {
        let rdf = "<http://example.org/#spiderman> <http://www.perceive.net/schemas/relationship/enemyOf> <http://example.org/#green-goblin> ;\n" +
            "       <http://xmlns.com/foaf/0.1/name> \"Spiderman\" ."
        let data = rdf.dataUsingEncoding(NSUTF8StringEncoding)
        let name = URI(string: "https://www.w3.org/TR/turtle/example-3")
        let parser = TurtleParser(data: data!, baseURI: name!)
        parser.delegate = TestRDFParserDelegate()
        let graph = parser.parse()
        XCTAssertEqual(0, graph?.namespaces.count)
        XCTAssertEqual(2, graph?.statements.count)
        if graph?.statements.count == 2 {
            XCTAssertTrue(graph![0].subject == URI(string: "http://example.org/#spiderman")!)
            XCTAssertTrue(graph![0].predicate == URI(string: "http://www.perceive.net/schemas/relationship/enemyOf")!)
            XCTAssertTrue(graph![0].object == URI(string: "http://example.org/#green-goblin")!)
            XCTAssertTrue(graph![1].subject == URI(string: "http://example.org/#spiderman")!)
            XCTAssertTrue(graph![1].predicate == URI(string: "http://xmlns.com/foaf/0.1/name")!)
            XCTAssertTrue(graph![1].object == Literal(stringValue: "\"Spiderman\""))
        }
    }
    
    func testExample3b() {
        let rdf = "<http://example.org/#spiderman> <http://www.perceive.net/schemas/relationship/enemyOf> <http://example.org/#green-goblin> ;\n" +
        "       <http://xmlns.com/foaf/0.1/name> \"Spiderman or \\\"SPIDERMAN\\\"\"^^xsd:string ."
        let data = rdf.dataUsingEncoding(NSUTF8StringEncoding)
        let name = URI(string: "https://www.w3.org/TR/turtle/example-3")
        let parser = TurtleParser(data: data!, baseURI: name!)
        parser.delegate = TestRDFParserDelegate()
        let graph = parser.parse()
        XCTAssertEqual(0, graph?.namespaces.count)
        XCTAssertEqual(2, graph?.statements.count)
        if graph?.statements.count == 2 {
            XCTAssertTrue(graph![0].subject == URI(string: "http://example.org/#spiderman")!)
            XCTAssertTrue(graph![0].predicate == URI(string: "http://www.perceive.net/schemas/relationship/enemyOf")!)
            XCTAssertTrue(graph![0].object == URI(string: "http://example.org/#green-goblin")!)
            XCTAssertTrue(graph![1].subject == URI(string: "http://example.org/#spiderman")!)
            XCTAssertTrue(graph![1].predicate == URI(string: "http://xmlns.com/foaf/0.1/name")!)
            XCTAssertTrue(graph![1].object == Literal(sparqlString: "\"Spiderman or \\\"SPIDERMAN\\\"\"^^xsd:string")!)
        }
    }

}
