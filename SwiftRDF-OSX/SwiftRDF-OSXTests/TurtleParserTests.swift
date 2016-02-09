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
            XCTAssertTrue(graph![1].object == Literal(sparqlString: "\"Spiderman\"^^xsd:string")!)
        }
    }
    
    func testExample3b() {
        let rdf = "<http://example.org/#spiderman> <http://www.perceive.net/schemas/relationship/enemyOf> <http://example.org/#green-goblin> ;\n" +
        "       <http://xmlns.com/foaf/0.1/name> \"Spiderman or \\\"SPIDERMAN\\\"\"^^xsd:string ."
        let data = rdf.dataUsingEncoding(NSUTF8StringEncoding)
        let name = URI(string: "https://www.w3.org/TR/turtle/example-3b")
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
    
    func testExample4() {
        let rdf = "<http://example.org/#spiderman> <http://www.perceive.net/schemas/relationship/enemyOf> <http://example.org/#green-goblin> .\n" +
            "<http://example.org/#spiderman> <http://xmlns.com/foaf/0.1/name> \"Spiderman\" ."
        let data = rdf.dataUsingEncoding(NSUTF8StringEncoding)
        let name = URI(string: "https://www.w3.org/TR/turtle/example-4")
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
            XCTAssertTrue(graph![1].object == Literal(sparqlString: "\"Spiderman\"^^xsd:string")!)
        }
    }
    
    func testExample5() {
        let rdf = "<http://example.org/#spiderman> <http://xmlns.com/foaf/0.1/name> \"Spiderman\", \"Человек-паук\"@ru ."
        let data = rdf.dataUsingEncoding(NSUTF8StringEncoding)
        let name = URI(string: "https://www.w3.org/TR/turtle/example-5")
        let parser = TurtleParser(data: data!, baseURI: name!)
        parser.delegate = TestRDFParserDelegate()
        let graph = parser.parse()
        printGraph(graph!)
        XCTAssertEqual(0, graph?.namespaces.count)
        XCTAssertEqual(2, graph?.statements.count)
        if graph?.statements.count == 2 {
            XCTAssertTrue(graph![0].subject == URI(string: "http://example.org/#spiderman")!)
            XCTAssertTrue(graph![0].predicate == URI(string: "http://xmlns.com/foaf/0.1/name")!)
            XCTAssertTrue(graph![0].object == Literal(sparqlString: "\"Spiderman\"^^xsd:string")!)
            XCTAssertTrue(graph![1].subject == URI(string: "http://example.org/#spiderman")!)
            XCTAssertTrue(graph![1].predicate == URI(string: "http://xmlns.com/foaf/0.1/name")!)
            XCTAssertTrue(graph![1].object == Literal(sparqlString: "\"Человек-паук\"@ru")!)
        }
    }
    
    func testExample6() {
        let rdf = "<http://example.org/#spiderman> <http://xmlns.com/foaf/0.1/name> \"Spiderman\" ." +
                "<http://example.org/#spiderman> <http://xmlns.com/foaf/0.1/name> \"Человек-паук\"@ru ."
        let data = rdf.dataUsingEncoding(NSUTF8StringEncoding)
        let name = URI(string: "https://www.w3.org/TR/turtle/example-6")
        let parser = TurtleParser(data: data!, baseURI: name!)
        parser.delegate = TestRDFParserDelegate()
        let graph = parser.parse()
        XCTAssertEqual(0, graph?.namespaces.count)
        XCTAssertEqual(2, graph?.statements.count)
        if graph?.statements.count == 2 {
            XCTAssertTrue(graph![0].subject == URI(string: "http://example.org/#spiderman")!)
            XCTAssertTrue(graph![0].predicate == URI(string: "http://xmlns.com/foaf/0.1/name")!)
            XCTAssertTrue(graph![0].object == Literal(sparqlString: "\"Spiderman\"^^xsd:string")!)
            XCTAssertTrue(graph![1].subject == URI(string: "http://example.org/#spiderman")!)
            XCTAssertTrue(graph![1].predicate == URI(string: "http://xmlns.com/foaf/0.1/name")!)
            XCTAssertTrue(graph![1].object == Literal(sparqlString: "\"Человек-паук\"@ru")!)
        }
    }
    
    func testExample7() {
        let rdf = "@prefix somePrefix: <http://www.perceive.net/schemas/relationship/> .\n" +
                "<http://example.org/#green-goblin> somePrefix:enemyOf <http://example.org/#spiderman> ."
        let data = rdf.dataUsingEncoding(NSUTF8StringEncoding)
        let name = URI(string: "https://www.w3.org/TR/turtle/example-7")
        let parser = TurtleParser(data: data!, baseURI: name!)
        parser.delegate = TestRDFParserDelegate()
        let graph = parser.parse()
        printGraph(graph!)
        XCTAssertEqual(1, graph?.namespaces.count)
        if graph?.namespaces.count == 1 {
            XCTAssertEqual("somePrefix",graph!.namespacePrefixes[0])
            XCTAssertEqual("http://www.perceive.net/schemas/relationship/", graph!.namespaceForPrefix("somePrefix"))
        }
        XCTAssertEqual(1, graph?.statements.count)
        if graph?.statements.count == 1 {
            XCTAssertTrue(graph![0].subject == URI(string: "http://example.org/#green-goblin")!)
            XCTAssertTrue(graph![0].predicate == URI(string: "http://www.perceive.net/schemas/relationship/enemyOf")!)
            XCTAssertTrue(graph![0].object == URI(string: "http://example.org/#spiderman")!)
        }
    }
    
    func testExample8() {
        let rdf = "PREFIX somePrefix: <http://www.perceive.net/schemas/relationship/>\n" +
        "<http://example.org/#green-goblin> somePrefix:enemyOf <http://example.org/#spiderman> ."
        let data = rdf.dataUsingEncoding(NSUTF8StringEncoding)
        let name = URI(string: "https://www.w3.org/TR/turtle/example-8")
        let parser = TurtleParser(data: data!, baseURI: name!)
        parser.delegate = TestRDFParserDelegate()
        let graph = parser.parse()
        printGraph(graph!)
        XCTAssertEqual(1, graph?.namespaces.count)
        if graph?.namespaces.count == 1 {
            XCTAssertEqual("somePrefix",graph!.namespacePrefixes[0])
            XCTAssertEqual("http://www.perceive.net/schemas/relationship/", graph!.namespaceForPrefix("somePrefix"))
        }
        XCTAssertEqual(1, graph?.statements.count)
        if graph?.statements.count == 1 {
            XCTAssertTrue(graph![0].subject == URI(string: "http://example.org/#green-goblin")!)
            XCTAssertTrue(graph![0].predicate == URI(string: "http://www.perceive.net/schemas/relationship/enemyOf")!)
            XCTAssertTrue(graph![0].object == URI(string: "http://example.org/#spiderman")!)
        }
    }
    
    func testExample9() {
        let rdf = "# A triple with all absolute IRIs\n" +
            "<http://one.example/subject1> <http://one.example/predicate1> <http://one.example/object1> .\n" +
            "@base <http://one.example/> .\n" +
            "<subject2> <predicate2> <object2> .     # relative IRIs, e.g. http://one.example/subject2\n\n" +
            "BASE <http://one.example/>\n" +
            "<subject2a> <predicate2a> <object2a> .     # relative IRIs, e.g. http://one.example/subject2a\n\n " +
            "@prefix p: <http://two.example/> .\n" +
            "p:subject3 p:predicate3 p:object3 .     # prefixed name, e.g. http://two.example/subject3\n\n" +
            "PREFIX p: <http://two.example/>\n" +
            "p:subject3a p:predicate3a p:object3a .     # prefixed name, e.g. http://two.example/subject3a\n\n" +
            "@prefix p: <path/> .                    # prefix p: now stands for http://one.example/path/\n" +
            "p:subject4 p:predicate4 p:object4 .     # prefixed name, e.g. http://one.example/path/subject4\n\n" +
            "@prefix : <http://another.example/> .    # empty prefix\n" +
            ":subject5 :predicate5 :object5 .        # prefixed name, e.g. http://another.example/subject5\n\n" +
            ":subject6 a :subject7 .                 # same as :subject6 <http://www.w3.org/1999/02/22-rdf-syntax-ns#type> :subject7 .\n\n" +
            "<http://伝言.example/?user=أكرم&amp;channel=R%26D> a :subject8 . # a multi-script subject IRI ."
        let data = rdf.dataUsingEncoding(NSUTF8StringEncoding)
        let name = URI(string: "https://www.w3.org/TR/turtle/example-9")
        let parser = TurtleParser(data: data!, baseURI: name!)
        parser.delegate = TestRDFParserDelegate()
        let graph = parser.parse()
        printGraph(graph!)
        XCTAssertEqual(3, graph?.namespaces.count)
        if graph?.namespaces.count == 3 {
            XCTAssertEqual("http://two.example/", graph!.namespaceForPrefix("p"))
            XCTAssertEqual("http://one.example/path/", graph!.namespaceForPrefix("p1"))
            XCTAssertEqual("http://another.example/", graph!.namespaceForPrefix(""))
        }
        XCTAssertEqual(9, graph?.statements.count)
        if graph?.statements.count == 9 {
            XCTAssertTrue(graph![0].subject == URI(string: "http://one.example/subject1")!)
            XCTAssertTrue(graph![0].predicate == URI(string: "http://one.example/predicate1")!)
            XCTAssertTrue(graph![0].object == URI(string: "http://one.example/object1")!)
            XCTAssertTrue(graph![1].subject == URI(string: "http://one.example/subject2")!)
            XCTAssertTrue(graph![1].predicate == URI(string: "http://one.example/predicate2")!)
            XCTAssertTrue(graph![1].object == URI(string: "http://one.example/object2")!)
            XCTAssertTrue(graph![2].subject == URI(string: "http://one.example/subject2a")!)
            XCTAssertTrue(graph![2].predicate == URI(string: "http://one.example/predicate2a")!)
            XCTAssertTrue(graph![2].object == URI(string: "http://one.example/object2a")!)
            XCTAssertTrue(graph![3].subject == URI(string: "http://two.example/subject3")!)
            XCTAssertTrue(graph![3].predicate == URI(string: "http://two.example/predicate3")!)
            XCTAssertTrue(graph![3].object == URI(string: "http://two.example/object3")!)
            XCTAssertTrue(graph![4].subject == URI(string: "http://two.example/subject3a")!)
            XCTAssertTrue(graph![4].predicate == URI(string: "http://two.example/predicate3a")!)
            XCTAssertTrue(graph![4].object == URI(string: "http://two.example/object3a")!)
            XCTAssertTrue(graph![5].subject == URI(string: "http://one.example/path/subject4")!)
            XCTAssertTrue(graph![5].predicate == URI(string: "http://one.example/path/predicate4")!)
            XCTAssertTrue(graph![5].object == URI(string: "http://one.example/path/object4")!)
            XCTAssertTrue(graph![6].subject == URI(string: "http://another.example/subject5")!)
            XCTAssertTrue(graph![6].predicate == URI(string: "http://another.example/predicate5")!)
            XCTAssertTrue(graph![6].object == URI(string: "http://another.example/object5")!)
            XCTAssertTrue(graph![7].subject == URI(string: "http://another.example/subject6")!)
            XCTAssertTrue(graph![7].predicate == RDF.type)
            XCTAssertTrue(graph![7].object == URI(string: "http://another.example/subject7")!)
            XCTAssertTrue(graph![8].subject == URI(string: "http://伝言.example/?user=أكرم&amp;channel=R%26D")!)
            XCTAssertTrue(graph![8].predicate == RDF.type)
            XCTAssertTrue(graph![8].object == URI(string: "http://another.example/subject8")!)
        }
    }
    
    func testExample10() {
        let rdf = "@prefix foaf: <http://xmlns.com/foaf/0.1/> . \n" +
                "<http://example.org/#green-goblin> foaf:name \"Green Goblin\" .\n" +
                "<http://example.org/#spiderman> foaf:name \"Spiderman\" ."
        let data = rdf.dataUsingEncoding(NSUTF8StringEncoding)
        let name = URI(string: "https://www.w3.org/TR/turtle/example-10")
        let parser = TurtleParser(data: data!, baseURI: name!)
        parser.delegate = TestRDFParserDelegate()
        let graph = parser.parse()
        XCTAssertEqual(1, graph?.namespaces.count)
        XCTAssertEqual(2, graph?.statements.count)
        if graph?.namespaces.count == 1 {
            XCTAssertEqual("http://xmlns.com/foaf/0.1/", graph!.namespaceForPrefix("foaf"))
        }
        if graph?.statements.count == 2 {
            XCTAssertTrue(graph![0].subject == URI(string: "http://example.org/#green-goblin")!)
            XCTAssertTrue(graph![0].predicate == URI(string: "http://xmlns.com/foaf/0.1/name")!)
            XCTAssertTrue(graph![0].object == Literal(sparqlString: "\"Green Goblin\"^^xsd:string")!)
            XCTAssertTrue(graph![1].subject == URI(string: "http://example.org/#spiderman")!)
            XCTAssertTrue(graph![1].predicate == URI(string: "http://xmlns.com/foaf/0.1/name")!)
            XCTAssertTrue(graph![1].object == Literal(sparqlString: "\"Spiderman\"^^xsd:string")!)
        }
    }
    
    
    
    func printGraph(graph : Graph){
        if graph.name == nil {
            print("\n\nGRAPH\n")
        }else {
            print("\n\nNAMED GRAPH \(graph.name!)\n")
        }
        let prefixes = graph.namespacePrefixes
        print("-- Namespaces --")
        for prefix in prefixes {
            print("   \(prefix): \(graph.namespaceForPrefix(prefix)!)")
        }
        print("\n-- Statements --")
        for var index = 0 ; index < graph.count ; index++ {
            let statement = graph[index]
            let subject = qualifiedNameOrStringValue(statement.subject, graph: graph)
            let predicate = qualifiedNameOrStringValue(statement.predicate, graph: graph)
            let object = qualifiedNameOrStringValue(statement.object, graph: graph)
            var namedGraphs = ""
            var i = 0
            for namedGraph in statement.namedGraphs {
                if i > 0 {
                    namedGraphs = namedGraphs + ", "
                }
                namedGraphs = namedGraphs + qualifiedNameOrStringValue(namedGraph, graph: graph)
                i++
            }
            if i > 0 {
                namedGraphs = "[\(namedGraphs)]"
            }
            print("   \(subject) \(predicate) \(object) \(namedGraphs)")
        }
        print("----------------\n")
    }
    
    func qualifiedNameOrStringValue(value : Value, graph : Graph) -> String {
        var strvalue = value.sparql
        if let uri = value as? URI {
            let qname = graph.qualifiedName(uri)
            if qname != nil {
                strvalue = qname!
            }
        }
        return strvalue
    }
}
