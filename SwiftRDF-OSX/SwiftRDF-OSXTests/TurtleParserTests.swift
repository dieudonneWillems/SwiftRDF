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
        let parser = TurtleParser(data: data!, baseURI: name!,encoding: NSUTF8StringEncoding)
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
        let parser = TurtleParser(data: data!, baseURI: name!,encoding: NSUTF8StringEncoding)
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
            XCTAssertTrue(graph![1].object == Literal(sparqlString: "\"Spiderman\"")!)
        }
    }
    
    func testExample3b() {
        let rdf = "<http://example.org/#spiderman> <http://www.perceive.net/schemas/relationship/enemyOf> <http://example.org/#green-goblin> ;\n" +
        "       <http://xmlns.com/foaf/0.1/name> \"Spiderman or \\\"SPIDERMAN\\\"\"^^xsd:string ."
        let data = rdf.dataUsingEncoding(NSUTF8StringEncoding)
        let name = URI(string: "https://www.w3.org/TR/turtle/example-3b")
        let parser = TurtleParser(data: data!, baseURI: name!,encoding: NSUTF8StringEncoding)
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
        let parser = TurtleParser(data: data!, baseURI: name!,encoding: NSUTF8StringEncoding)
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
            XCTAssertTrue(graph![1].object == Literal(sparqlString: "\"Spiderman\"")!)
        }
    }
    
    func testExample5() {
        let rdf = "<http://example.org/#spiderman> <http://xmlns.com/foaf/0.1/name> \"Spiderman\", \"Человек-паук\"@ru ."
        let data = rdf.dataUsingEncoding(NSUTF8StringEncoding)
        let name = URI(string: "https://www.w3.org/TR/turtle/example-5")
        let parser = TurtleParser(data: data!, baseURI: name!,encoding: NSUTF8StringEncoding)
        parser.delegate = TestRDFParserDelegate()
        let graph = parser.parse()
        printGraph(graph!)
        XCTAssertEqual(0, graph?.namespaces.count)
        XCTAssertEqual(2, graph?.statements.count)
        if graph?.statements.count == 2 {
            XCTAssertTrue(graph![0].subject == URI(string: "http://example.org/#spiderman")!)
            XCTAssertTrue(graph![0].predicate == URI(string: "http://xmlns.com/foaf/0.1/name")!)
            XCTAssertTrue(graph![0].object == Literal(sparqlString: "\"Spiderman\"")!)
            XCTAssertTrue(graph![1].subject == URI(string: "http://example.org/#spiderman")!)
            XCTAssertTrue(graph![1].predicate == URI(string: "http://xmlns.com/foaf/0.1/name")!)
            XCTAssertTrue(graph![1].object == Literal(sparqlString: "\"Человек-паук\"@ru")!)
        }
    }
    
    func testExample6() {
        let rdf = "<http://example.org/#spiderman> <http://xmlns.com/foaf/0.1/name> \"Spiderman\" .\n" +
                "<http://example.org/#spiderman> <http://xmlns.com/foaf/0.1/name> \"Человек-паук\"@ru ."
        let data = rdf.dataUsingEncoding(NSUTF8StringEncoding)
        let name = URI(string: "https://www.w3.org/TR/turtle/example-6")
        let parser = TurtleParser(data: data!, baseURI: name!,encoding: NSUTF8StringEncoding)
        parser.delegate = TestRDFParserDelegate()
        let graph = parser.parse()
        XCTAssertEqual(0, graph?.namespaces.count)
        XCTAssertEqual(2, graph?.statements.count)
        if graph?.statements.count == 2 {
            XCTAssertTrue(graph![0].subject == URI(string: "http://example.org/#spiderman")!)
            XCTAssertTrue(graph![0].predicate == URI(string: "http://xmlns.com/foaf/0.1/name")!)
            XCTAssertTrue(graph![0].object == Literal(sparqlString: "\"Spiderman\"")!)
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
        let parser = TurtleParser(data: data!, baseURI: name!,encoding: NSUTF8StringEncoding)
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
        let parser = TurtleParser(data: data!, baseURI: name!,encoding: NSUTF8StringEncoding)
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
        let parser = TurtleParser(data: data!, baseURI: name!,encoding: NSUTF8StringEncoding)
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
        let parser = TurtleParser(data: data!, baseURI: name!,encoding: NSUTF8StringEncoding)
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
            XCTAssertTrue(graph![0].object == Literal(sparqlString: "\"Green Goblin\"")!)
            XCTAssertTrue(graph![1].subject == URI(string: "http://example.org/#spiderman")!)
            XCTAssertTrue(graph![1].predicate == URI(string: "http://xmlns.com/foaf/0.1/name")!)
            XCTAssertTrue(graph![1].object == Literal(sparqlString: "\"Spiderman\"")!)
        }
    }
    
    func testExample11() {
        let rdf = "@prefix rdfs: <http://www.w3.org/2000/01/rdf-schema#> .\n" +
                "@prefix show: <http://example.org/vocab/show/> . \n" +
                "@prefix xsd: <http://www.w3.org/2001/XMLSchema#> . \n\n" +
                "show:218 rdfs:label \"That Seventies Show\"^^xsd:string .            # literal with XML Schema string datatype\n" +
                "show:218 rdfs:label \"That Seventies Show\"^^<http://www.w3.org/2001/XMLSchema#string> . # same as above\n" +
                "show:218 rdfs:label \"That Seventies Show\" .                                            # same again\n" +
                "show:218 show:localName \"That Seventies Show\"@en .                 # literal with a language tag\n" +
                "show:218 show:localName 'Cette Série des Années Soixante-dix'@fr . # literal delimited by single quote\n" +
                "show:218 show:localName \"Cette Série des Années Septante\"@fr-be .  # literal with a region subtag\n" +
                "show:218 show:blurb '''This is a multi-line\n" +
                "literal with many quotes (\"\"\"\"\")\n" +
                "and up to two sequential apostrophes ('').''' ."
        let data = rdf.dataUsingEncoding(NSUTF8StringEncoding)
        let name = URI(string: "https://www.w3.org/TR/turtle/example-10")
        let parser = TurtleParser(data: data!, baseURI: name!,encoding: NSUTF8StringEncoding)
        parser.delegate = TestRDFParserDelegate()
        let graph = parser.parse()
        printGraph(graph!)
        XCTAssertEqual(3, graph?.namespaces.count)
        XCTAssertEqual(7, graph?.statements.count)
        if graph?.namespaces.count == 1 {
            XCTAssertEqual("http://www.w3.org/2000/01/rdf-schema#", graph!.namespaceForPrefix("rdfs"))
            XCTAssertEqual("http://example.org/vocab/show/", graph!.namespaceForPrefix("show"))
            XCTAssertEqual("http://www.w3.org/2001/XMLSchema#", graph!.namespaceForPrefix("xsd"))
        }
        if graph?.statements.count == 7 {
            XCTAssertTrue(graph![0].subject == URI(string: "http://example.org/vocab/show/218")!)
            XCTAssertTrue(graph![0].predicate == RDFS.label)
            XCTAssertTrue(graph![0].object == Literal(sparqlString: "\"That Seventies Show\"^^xsd:string")!)
            XCTAssertTrue(graph![1].subject == URI(string: "http://example.org/vocab/show/218")!)
            XCTAssertTrue(graph![1].predicate == RDFS.label)
            XCTAssertTrue(graph![1].object == Literal(sparqlString: "\"That Seventies Show\"^^xsd:string")!)
            XCTAssertTrue(graph![2].subject == URI(string: "http://example.org/vocab/show/218")!)
            XCTAssertTrue(graph![2].predicate == RDFS.label)
            XCTAssertTrue(graph![2].object == Literal(sparqlString: "\"That Seventies Show\"")!)
            XCTAssertTrue(graph![3].subject == URI(string: "http://example.org/vocab/show/218")!)
            XCTAssertTrue(graph![3].predicate == URI(string: "http://example.org/vocab/show/localName")!)
            XCTAssertTrue(graph![3].object == Literal(sparqlString: "\"That Seventies Show\"@en")!)
            XCTAssertTrue(graph![4].subject == URI(string: "http://example.org/vocab/show/218")!)
            XCTAssertTrue(graph![4].predicate == URI(string: "http://example.org/vocab/show/localName")!)
            XCTAssertTrue(graph![4].object == Literal(sparqlString: "\"Cette Série des Années Soixante-dix\"@fr")!)
            XCTAssertTrue(graph![5].subject == URI(string: "http://example.org/vocab/show/218")!)
            XCTAssertTrue(graph![5].predicate == URI(string: "http://example.org/vocab/show/localName")!)
            XCTAssertTrue(graph![5].object == Literal(sparqlString: "\"Cette Série des Années Septante\"@fr-be")!)
            XCTAssertTrue(graph![6].subject == URI(string: "http://example.org/vocab/show/218")!)
            XCTAssertTrue(graph![6].predicate == URI(string: "http://example.org/vocab/show/blurb")!)
            XCTAssertTrue(graph![6].object == Literal(sparqlString: "'''This is a multi-line\nliteral with many quotes (\"\"\"\"\")\nand up to two sequential apostrophes ('').'''")!)
        }
    }
    
    func testExample12() {
        let rdf = "@prefix : <http://example.org/elements> .\n" +
            "<http://en.wikipedia.org/wiki/Helium>\n" +
            "   :atomicNumber 2 ;               # xsd:integer \n" +
            "   :atomicMass 4.002602 ;          # xsd:decimal \n" +
            "   :specificGravity 1.663E-4 .     # xsd:double  ."
        let data = rdf.dataUsingEncoding(NSUTF8StringEncoding)
        let name = URI(string: "https://www.w3.org/TR/turtle/example-12")
        let parser = TurtleParser(data: data!, baseURI: name!,encoding: NSUTF8StringEncoding)
        parser.delegate = TestRDFParserDelegate()
        let graph = parser.parse()
        XCTAssertEqual(1, graph?.namespaces.count)
        XCTAssertEqual(3, graph?.statements.count)
        printGraph(graph!)
        if graph?.namespaces.count == 1 {
            XCTAssertEqual("http://example.org/elements", graph!.namespaceForPrefix(""))
        }
        if graph?.statements.count == 2 {
            XCTAssertTrue(graph![0].subject == URI(string: "http://en.wikipedia.org/wiki/Helium")!)
            XCTAssertTrue(graph![0].predicate == URI(string: "http://example.org/elements#atomicNumber")!)
            XCTAssertTrue(graph![0].object == Literal(sparqlString: "2")!)
            XCTAssertTrue(graph![1].subject == URI(string: "http://en.wikipedia.org/wiki/Helium")!)
            XCTAssertTrue(graph![1].predicate == URI(string: "http://example.org/elements#atomicMass")!)
            XCTAssertTrue(graph![1].object == Literal(sparqlString: "4.002602")!)
            XCTAssertTrue(graph![2].subject == URI(string: "http://en.wikipedia.org/wiki/Helium")!)
            XCTAssertTrue(graph![2].predicate == URI(string: "http://example.org/elements#specificGravity")!)
            XCTAssertTrue(graph![2].object == Literal(sparqlString: "1.663E-4")!)
        }
    }
    
    func testExample13() {
        let rdf = "@prefix : <http://example.org/stats> . \n" +
            "<http://somecountry.example/census2007>\n " +
            "   :isLandlocked false .           # xsd:boolean"
        let data = rdf.dataUsingEncoding(NSUTF8StringEncoding)
        let name = URI(string: "https://www.w3.org/TR/turtle/example-13")
        let parser = TurtleParser(data: data!, baseURI: name!,encoding: NSUTF8StringEncoding)
        parser.delegate = TestRDFParserDelegate()
        let graph = parser.parse()
        XCTAssertEqual(1, graph?.namespaces.count)
        XCTAssertEqual(1, graph?.statements.count)
        printGraph(graph!)
        if graph?.namespaces.count == 1 {
            XCTAssertEqual("http://example.org/stats", graph!.namespaceForPrefix(""))
        }
        if graph?.statements.count == 1 {
            XCTAssertTrue(graph![0].subject == URI(string: "http://somecountry.example/census2007")!)
            XCTAssertTrue(graph![0].predicate == URI(string: "http://example.org/stats#isLandlocked")!)
            XCTAssertTrue(graph![0].object == Literal(sparqlString: "false")!)
        }
    }
    
    func testExample14() {
        let rdf = "@prefix foaf: <http://xmlns.com/foaf/0.1/> . \n" +
            "_:alice foaf:knows _:bob . \n" +
            "_:bob foaf:knows _:alice ."
        let data = rdf.dataUsingEncoding(NSUTF8StringEncoding)
        let name = URI(string: "https://www.w3.org/TR/turtle/example-14")
        let parser = TurtleParser(data: data!, baseURI: name!,encoding: NSUTF8StringEncoding)
        parser.delegate = TestRDFParserDelegate()
        let graph = parser.parse()
        XCTAssertEqual(1, graph?.namespaces.count)
        XCTAssertEqual(2, graph?.statements.count)
        printGraph(graph!)
        if graph?.namespaces.count == 1 {
            XCTAssertEqual("http://xmlns.com/foaf/0.1/", graph!.namespaceForPrefix("foaf"))
        }
        if graph?.statements.count == 2 {
            XCTAssertTrue(graph![0].subject == BlankNode(identifier: "alice"))
            XCTAssertTrue(graph![0].predicate == URI(string: "http://xmlns.com/foaf/0.1/knows")!)
            XCTAssertTrue(graph![0].object == BlankNode(identifier: "bob"))
            XCTAssertTrue(graph![1].subject == BlankNode(identifier: "bob"))
            XCTAssertTrue(graph![1].predicate == URI(string: "http://xmlns.com/foaf/0.1/knows")!)
            XCTAssertTrue(graph![1].object == BlankNode(identifier: "alice"))
        }
    }
    
    func testExample15() {
        let rdf = "@prefix foaf: <http://xmlns.com/foaf/0.1/> . \n" +
            "[] foaf:knows [ foaf:name \"Bob\" ] ."
        let data = rdf.dataUsingEncoding(NSUTF8StringEncoding)
        let name = URI(string: "https://www.w3.org/TR/turtle/example-15")
        let parser = TurtleParser(data: data!, baseURI: name!,encoding: NSUTF8StringEncoding)
        parser.delegate = TestRDFParserDelegate()
        let graph = parser.parse()
        XCTAssertEqual(1, graph?.namespaces.count)
        XCTAssertEqual(2, graph?.statements.count)
        printGraph(graph!)
        if graph?.namespaces.count == 1 {
            XCTAssertEqual("http://xmlns.com/foaf/0.1/", graph!.namespaceForPrefix("foaf"))
        }
        if graph?.statements.count == 2 {
            XCTAssertTrue(graph![0].predicate == URI(string: "http://xmlns.com/foaf/0.1/knows")!)
            XCTAssertTrue(graph![0].object == graph![1].subject)
            XCTAssertTrue(graph![1].predicate == URI(string: "http://xmlns.com/foaf/0.1/name")!)
            XCTAssertTrue(graph![1].object == Literal(sparqlString: "\"Bob\"")!)
        }
    }
    
    func testExample16() {
        let rdf = "@prefix foaf: <http://xmlns.com/foaf/0.1/> .\n" +
            "[ foaf:name \"Alice\" ] foaf:knows [ \n" +
            "  foaf:name \"Bob\" ; \n" +
            "  foaf:knows [ \n " +
            "  foaf:name \"Eve\" ] ; \n " +
            "  foaf:mbox <mailto:bob@example.com> ] ."
        let data = rdf.dataUsingEncoding(NSUTF8StringEncoding)
        let name = URI(string: "https://www.w3.org/TR/turtle/example-16")
        let parser = TurtleParser(data: data!, baseURI: name!,encoding: NSUTF8StringEncoding)
        parser.delegate = TestRDFParserDelegate()
        let graph = parser.parse()
        XCTAssertEqual(1, graph?.namespaces.count)
        XCTAssertEqual(6, graph?.statements.count)
        printGraph(graph!)
        if graph?.namespaces.count == 1 {
            XCTAssertEqual("http://xmlns.com/foaf/0.1/", graph!.namespaceForPrefix("foaf"))
        }
        if graph?.statements.count == 6 {
            XCTAssertTrue(graph![0].predicate == URI(string: "http://xmlns.com/foaf/0.1/name")!)
            XCTAssertTrue(graph![0].object == Literal(sparqlString: "\"Alice\"")!)
            XCTAssertTrue(graph![1].predicate == URI(string: "http://xmlns.com/foaf/0.1/knows")!)
            XCTAssertTrue(graph![1].object == graph![2].subject)
            XCTAssertTrue(graph![2].predicate == URI(string: "http://xmlns.com/foaf/0.1/name")!)
            XCTAssertTrue(graph![2].object == Literal(sparqlString: "\"Bob\"")!)
            XCTAssertTrue(graph![3].predicate == URI(string: "http://xmlns.com/foaf/0.1/knows")!)
            XCTAssertTrue(graph![3].object == graph![4].subject)
            XCTAssertTrue(graph![4].predicate == URI(string: "http://xmlns.com/foaf/0.1/name")!)
            XCTAssertTrue(graph![4].object == Literal(sparqlString: "\"Eve\"")!)
            XCTAssertTrue(graph![2].subject == graph![5].subject)
            XCTAssertTrue(graph![5].predicate == URI(string: "http://xmlns.com/foaf/0.1/mbox")!)
            XCTAssertTrue(graph![5].object == URI(string:"mailto:bob@example.com")!)
        }
    }
    
    func testExample18() {
        let rdf = "@prefix : <http://example.org/foo> . \n" +
            "# the object of this triple is the RDF collection blank node\n" +
            ":subject :predicate ( :a :b :c ) .\n\n" +
            "# an empty collection value - rdf:nil\n" +
            ":subject :predicate2 () ."
        let data = rdf.dataUsingEncoding(NSUTF8StringEncoding)
        let name = URI(string: "https://www.w3.org/TR/turtle/example-18")
        let parser = TurtleParser(data: data!, baseURI: name!,encoding: NSUTF8StringEncoding)
        parser.delegate = TestRDFParserDelegate()
        let graph = parser.parse()
        XCTAssertEqual(1, graph?.namespaces.count)
        XCTAssertEqual(8, graph?.statements.count)
        printGraph(graph!)
        if graph?.namespaces.count == 1 {
            XCTAssertEqual("http://example.org/foo", graph!.namespaceForPrefix(""))
        }
        if graph?.statements.count == 8 {
            XCTAssertTrue(graph![0].subject == URI(string: "http://example.org/foo#subject")!)
            XCTAssertTrue(graph![0].predicate == URI(string: "http://example.org/foo#predicate")!)
            XCTAssertTrue(graph![0].object == graph![1].subject)
            XCTAssertTrue(graph![1].predicate == RDF.first)
            XCTAssertTrue(graph![1].object == URI(string: "http://example.org/foo#a")!)
            XCTAssertTrue(graph![2].subject == graph![1].subject)
            XCTAssertTrue(graph![2].predicate == RDF.rest)
            XCTAssertTrue(graph![2].object == graph![3].subject)
            XCTAssertTrue(graph![3].predicate == RDF.first)
            XCTAssertTrue(graph![3].object == URI(string: "http://example.org/foo#b")!)
            XCTAssertTrue(graph![4].subject == graph![3].subject)
            XCTAssertTrue(graph![4].predicate == RDF.rest)
            XCTAssertTrue(graph![4].object == graph![5].subject)
            XCTAssertTrue(graph![5].predicate == RDF.first)
            XCTAssertTrue(graph![5].object == URI(string: "http://example.org/foo#c")!)
            XCTAssertTrue(graph![6].subject == graph![5].subject)
            XCTAssertTrue(graph![6].predicate == RDF.rest)
            XCTAssertTrue(graph![6].object == RDF.NIL)
            XCTAssertTrue(graph![7].subject == URI(string: "http://example.org/foo#subject")!)
            XCTAssertTrue(graph![7].predicate == URI(string: "http://example.org/foo#predicate2")!)
            XCTAssertTrue(graph![7].object == RDF.NIL)
        }
    }
    
    func testExample19() {
        let rdf = "@prefix rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#> . \n" +
            "@prefix dc: <http://purl.org/dc/elements/1.1/> .\n" +
            "@prefix ex: <http://example.org/stuff/1.0/> .\n\n" +
            "<http://www.w3.org/TR/rdf-syntax-grammar> \n" +
            "   dc:title \"RDF/XML Syntax Specification (Revised)\" ;\n" +
            "   ex:editor [\n" +
            "       ex:fullname \"Dave Beckett\";\n" +
            "       ex:homePage <http://purl.org/net/dajobe/>\n" +
            "] ."
        let data = rdf.dataUsingEncoding(NSUTF8StringEncoding)
        let name = URI(string: "https://www.w3.org/TR/turtle/example-19")
        let parser = TurtleParser(data: data!, baseURI: name!,encoding: NSUTF8StringEncoding)
        parser.delegate = TestRDFParserDelegate()
        let graph = parser.parse()
        XCTAssertEqual(3, graph?.namespaces.count)
        XCTAssertEqual(4, graph?.statements.count)
        printGraph(graph!)
        if graph?.statements.count == 4 {
            XCTAssertTrue(graph![0].subject == URI(string: "http://www.w3.org/TR/rdf-syntax-grammar")!)
            XCTAssertTrue(graph![0].predicate == URI(string: "http://purl.org/dc/elements/1.1/title")!)
            XCTAssertTrue(graph![0].object == Literal(sparqlString: "\"RDF/XML Syntax Specification (Revised)\"")!)
            XCTAssertTrue(graph![1].subject == URI(string: "http://www.w3.org/TR/rdf-syntax-grammar")!)
            XCTAssertTrue(graph![1].predicate == URI(string: "http://example.org/stuff/1.0/editor")!)
            XCTAssertTrue(graph![2].subject == graph![1].object)
            XCTAssertTrue(graph![2].predicate == URI(string: "http://example.org/stuff/1.0/fullname")!)
            XCTAssertTrue(graph![2].object == Literal(sparqlString: "\"Dave Beckett\"")!)
            XCTAssertTrue(graph![3].subject == graph![1].object)
            XCTAssertTrue(graph![3].predicate == URI(string: "http://example.org/stuff/1.0/homePage")!)
            XCTAssertTrue(graph![3].object == URI(string: "http://purl.org/net/dajobe/")!)
        }
    }
    
    func testExample20() {
        let rdf = "PREFIX : <http://example.org/stuff/1.0/>\n" +
            ":a :b ( \"apple\" \"banana\" ) ."
        let data = rdf.dataUsingEncoding(NSUTF8StringEncoding)
        let name = URI(string: "https://www.w3.org/TR/turtle/example-20")
        let parser = TurtleParser(data: data!, baseURI: name!,encoding: NSUTF8StringEncoding)
        parser.delegate = TestRDFParserDelegate()
        let graph = parser.parse()
        XCTAssertEqual(1, graph?.namespaces.count)
        XCTAssertEqual(5, graph?.statements.count)
        printGraph(graph!)
        if graph?.namespaces.count == 1 {
            XCTAssertEqual("http://example.org/stuff/1.0/", graph!.namespaceForPrefix(""))
        }
        if graph?.statements.count == 5 {
            XCTAssertTrue(graph![0].subject == URI(string: "http://example.org/stuff/1.0/a")!)
            XCTAssertTrue(graph![0].predicate == URI(string: "http://example.org/stuff/1.0/b")!)
            XCTAssertTrue(graph![0].object == graph![1].subject)
            XCTAssertTrue(graph![1].predicate == RDF.first)
            XCTAssertTrue(graph![1].object == Literal(sparqlString: "\"apple\"")!)
            XCTAssertTrue(graph![2].subject == graph![1].subject)
            XCTAssertTrue(graph![2].predicate == RDF.rest)
            XCTAssertTrue(graph![2].object == graph![3].subject)
            XCTAssertTrue(graph![3].predicate == RDF.first)
            XCTAssertTrue(graph![3].object == Literal(sparqlString: "\"banana\"")!)
            XCTAssertTrue(graph![4].subject == graph![3].subject)
            XCTAssertTrue(graph![4].predicate == RDF.rest)
            XCTAssertTrue(graph![4].object == RDF.NIL)
        }
    }
    
    func testExample21() {
        let rdf = "@prefix : <http://example.org/stuff/1.0/> .\n" +
            "@prefix rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#> .\n" +
            ":a :b\n" +
            "   [ rdf:first \"apple\";\n" +
            "       rdf:rest [ rdf:first \"banana\";\n" +
            "       rdf:rest rdf:nil ]\n" +
            "   ] ."
        let data = rdf.dataUsingEncoding(NSUTF8StringEncoding)
        let name = URI(string: "https://www.w3.org/TR/turtle/example-21")
        let parser = TurtleParser(data: data!, baseURI: name!,encoding: NSUTF8StringEncoding)
        parser.delegate = TestRDFParserDelegate()
        let graph = parser.parse()
        XCTAssertEqual(2, graph?.namespaces.count)
        XCTAssertEqual(5, graph?.statements.count)
        printGraph(graph!)
        if graph?.namespaces.count == 1 {
            XCTAssertEqual("http://example.org/stuff/1.0/", graph!.namespaceForPrefix(""))
        }
        if graph?.statements.count == 5 {
            XCTAssertTrue(graph![0].subject == URI(string: "http://example.org/stuff/1.0/a")!)
            XCTAssertTrue(graph![0].predicate == URI(string: "http://example.org/stuff/1.0/b")!)
            XCTAssertTrue(graph![0].object == graph![1].subject)
            XCTAssertTrue(graph![1].predicate == RDF.first)
            XCTAssertTrue(graph![1].object == Literal(sparqlString: "\"apple\"")!)
            XCTAssertTrue(graph![2].subject == graph![1].subject)
            XCTAssertTrue(graph![2].predicate == RDF.rest)
            XCTAssertTrue(graph![2].object == graph![3].subject)
            XCTAssertTrue(graph![3].predicate == RDF.first)
            XCTAssertTrue(graph![3].object == Literal(sparqlString: "\"banana\"")!)
            XCTAssertTrue(graph![4].subject == graph![3].subject)
            XCTAssertTrue(graph![4].predicate == RDF.rest)
            XCTAssertTrue(graph![4].object == RDF.NIL)
        }
    }
    
    func testExample22() {
        let rdf = "@prefix : <http://example.org/stuff/1.0/> .\n" +
            ":a :b \"The first line\\nThe second line\\n  more\" .\n" +
            ":a :b \"\"\"The first line\n" +
            "The second line\n" +
            "more\"\"\" ."
        let data = rdf.dataUsingEncoding(NSUTF8StringEncoding)
        let name = URI(string: "https://www.w3.org/TR/turtle/example-22")
        let parser = TurtleParser(data: data!, baseURI: name!,encoding: NSUTF8StringEncoding)
        parser.delegate = TestRDFParserDelegate()
        let graph = parser.parse()
        XCTAssertEqual(1, graph?.namespaces.count)
        XCTAssertEqual(2, graph?.statements.count)
        printGraph(graph!)
        if graph?.namespaces.count == 1 {
            XCTAssertEqual("http://example.org/stuff/1.0/", graph!.namespaceForPrefix(""))
        }
        if graph?.statements.count == 2 {
            XCTAssertTrue(graph![0].subject == URI(string: "http://example.org/stuff/1.0/a")!)
            XCTAssertTrue(graph![0].predicate == URI(string: "http://example.org/stuff/1.0/b")!)
            XCTAssertTrue(graph![0].object == Literal(sparqlString: "\"The first line\\nThe second line\\n  more\"")!)
            XCTAssertEqual((graph![0].object as! Literal).stringValue, "The first line\nThe second line\n  more")
            XCTAssertTrue(graph![1].subject == URI(string: "http://example.org/stuff/1.0/a")!)
            XCTAssertTrue(graph![1].predicate == URI(string: "http://example.org/stuff/1.0/b")!)
            XCTAssertTrue(graph![1].object == Literal(sparqlString: "\"\"\"The first line\nThe second line\nmore\"\"\"")!)
            XCTAssertEqual((graph![1].object as! Literal).stringValue, "The first line\nThe second line\nmore")
        }
    }
    
    func testExample23() {
        let rdf = "@prefix : <http://example.org/stuff/1.0/> .\n" +
            "(1 2.0 3E1) :p \"w\" ."
        let data = rdf.dataUsingEncoding(NSUTF8StringEncoding)
        let name = URI(string: "https://www.w3.org/TR/turtle/example-23")
        let parser = TurtleParser(data: data!, baseURI: name!,encoding: NSUTF8StringEncoding)
        parser.delegate = TestRDFParserDelegate()
        let graph = parser.parse()
        XCTAssertEqual(1, graph?.namespaces.count)
        XCTAssertEqual(7, graph?.statements.count)
        printGraph(graph!)
        if graph?.namespaces.count == 1 {
            XCTAssertEqual("http://example.org/stuff/1.0/", graph!.namespaceForPrefix(""))
        }
        if graph?.statements.count == 7 {
            XCTAssertTrue(graph![0].subject == graph![1].subject)
            XCTAssertTrue(graph![0].subject == graph![6].subject)
            XCTAssertTrue(graph![2].subject == graph![1].object)
            XCTAssertTrue(graph![2].subject == graph![3].subject)
            XCTAssertTrue(graph![4].subject == graph![5].subject)
            XCTAssertTrue(graph![4].subject == graph![3].object)
            XCTAssertTrue(graph![0].predicate == RDF.first)
            XCTAssertTrue(graph![1].predicate == RDF.rest)
            XCTAssertTrue(graph![2].predicate == RDF.first)
            XCTAssertTrue(graph![3].predicate == RDF.rest)
            XCTAssertTrue(graph![4].predicate == RDF.first)
            XCTAssertTrue(graph![5].predicate == RDF.rest)
            XCTAssertTrue(graph![6].predicate == URI(string: "http://example.org/stuff/1.0/p")!)
            XCTAssertTrue(graph![0].object == Literal(sparqlString: "1")!)
            XCTAssertTrue(graph![2].object == Literal(sparqlString: "2.0")!)
            XCTAssertTrue(graph![4].object == Literal(sparqlString: "3E1")!)
            XCTAssertTrue(graph![5].object == RDF.NIL)
            XCTAssertTrue(graph![6].object == Literal(sparqlString: "\"w\"")!)
        }
    }
    
    func testExample24() {
        let rdf = "@prefix : <http://example.org/stuff/1.0/> .\n" +
            "@prefix rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#> .\n" +
            "_:b0  rdf:first  1; \n" +
            "rdf:rest   _:b1 .\n" +
            "_:b1  rdf:first  2.0 ;\n" +
            "rdf:rest   _:b2 .\n" +
            "_:b2  rdf:first  3E1 ;\n" +
            "rdf:rest   rdf:nil .\n" +
            "_:b0  :p         \"w\" . "
        let data = rdf.dataUsingEncoding(NSUTF8StringEncoding)
        let name = URI(string: "https://www.w3.org/TR/turtle/example-24")
        let parser = TurtleParser(data: data!, baseURI: name!,encoding: NSUTF8StringEncoding)
        parser.delegate = TestRDFParserDelegate()
        let graph = parser.parse()
        XCTAssertEqual(2, graph?.namespaces.count)
        XCTAssertEqual(7, graph?.statements.count)
        printGraph(graph!)
        if graph?.statements.count == 7 {
            XCTAssertTrue(graph![0].subject == graph![1].subject)
            XCTAssertTrue(graph![0].subject == graph![6].subject)
            XCTAssertTrue(graph![2].subject == graph![1].object)
            XCTAssertTrue(graph![2].subject == graph![3].subject)
            XCTAssertTrue(graph![4].subject == graph![5].subject)
            XCTAssertTrue(graph![4].subject == graph![3].object)
            XCTAssertTrue(graph![0].predicate == RDF.first)
            XCTAssertTrue(graph![1].predicate == RDF.rest)
            XCTAssertTrue(graph![2].predicate == RDF.first)
            XCTAssertTrue(graph![3].predicate == RDF.rest)
            XCTAssertTrue(graph![4].predicate == RDF.first)
            XCTAssertTrue(graph![5].predicate == RDF.rest)
            XCTAssertTrue(graph![6].predicate == URI(string: "http://example.org/stuff/1.0/p")!)
            XCTAssertTrue(graph![0].object == Literal(sparqlString: "1")!)
            XCTAssertTrue(graph![2].object == Literal(sparqlString: "2.0")!)
            XCTAssertTrue(graph![4].object == Literal(sparqlString: "3E1")!)
            XCTAssertTrue(graph![5].object == RDF.NIL)
            XCTAssertTrue(graph![6].object == Literal(sparqlString: "\"w\"")!)
        }
    }
    
    func testExample25() {
        let rdf = "@prefix : <http://example.org/stuff/1.0/> .\n" +
        "(1 [:p :q] ( 2 ) ) :p2 :q2 ."
        let data = rdf.dataUsingEncoding(NSUTF8StringEncoding)
        let name = URI(string: "https://www.w3.org/TR/turtle/example-25")
        let parser = TurtleParser(data: data!, baseURI: name!,encoding: NSUTF8StringEncoding)
        parser.delegate = TestRDFParserDelegate()
        let graph = parser.parse()
        XCTAssertEqual(1, graph?.namespaces.count)
        XCTAssertEqual(10, graph?.statements.count)
        printGraph(graph!)
        if graph?.namespaces.count == 1 {
            XCTAssertEqual("http://example.org/stuff/1.0/", graph!.namespaceForPrefix(""))
        }
        if graph?.statements.count == 10 {
            XCTAssertTrue(graph![0].subject == graph![1].subject)
            XCTAssertTrue(graph![0].subject == graph![9].subject)
            XCTAssertTrue(graph![2].subject == graph![1].object)
            XCTAssertTrue(graph![3].subject == graph![2].object)
            XCTAssertTrue(graph![4].subject == graph![1].object)
            XCTAssertTrue(graph![5].subject == graph![4].object)
            XCTAssertTrue(graph![6].subject == graph![5].object)
            XCTAssertTrue(graph![7].subject == graph![5].object)
            XCTAssertTrue(graph![8].subject == graph![4].object)
            
            XCTAssertTrue(graph![0].predicate == RDF.first)
            XCTAssertTrue(graph![1].predicate == RDF.rest)
            XCTAssertTrue(graph![2].predicate == RDF.first)
            XCTAssertTrue(graph![3].predicate == URI(string: "http://example.org/stuff/1.0/p")!)
            XCTAssertTrue(graph![4].predicate == RDF.rest)
            XCTAssertTrue(graph![5].predicate == RDF.first)
            XCTAssertTrue(graph![6].predicate == RDF.first)
            XCTAssertTrue(graph![7].predicate == RDF.rest)
            XCTAssertTrue(graph![8].predicate == RDF.rest)
            XCTAssertTrue(graph![9].predicate == URI(string: "http://example.org/stuff/1.0/p2")!)
            
            XCTAssertTrue(graph![0].object == Literal(sparqlString: "1")!)
            XCTAssertTrue(graph![3].object == URI(string: "http://example.org/stuff/1.0/q")!)
            XCTAssertTrue(graph![6].object == Literal(sparqlString: "2")!)
            XCTAssertTrue(graph![7].object == RDF.NIL)
            XCTAssertTrue(graph![8].object == RDF.NIL)
            XCTAssertTrue(graph![9].object == URI(string: "http://example.org/stuff/1.0/q2")!)
        }
    }
    
    func testExample26() {
        let rdf = "@prefix : <http://example.org/stuff/1.0/> .\n" +
        "@prefix rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#> .\n" +
        "_:b0  rdf:first  1 ;\n" +
        "   rdf:rest   _:b1 .\n" +
        "_:b1  rdf:first  _:b2 .\n" +
        "_:b2  :p         :q .\n" +
        "_:b1  rdf:rest   _:b3 .\n" +
        "_:b3  rdf:first  _:b4 .\n" +
        "_:b4  rdf:first  2 ;\n" +
        "   rdf:rest   rdf:nil .\n" +
        "_:b3  rdf:rest   rdf:nil .\n" +
        "_:b0  :p2  :q2."
        let data = rdf.dataUsingEncoding(NSUTF8StringEncoding)
        let name = URI(string: "https://www.w3.org/TR/turtle/example-26")
        let parser = TurtleParser(data: data!, baseURI: name!,encoding: NSUTF8StringEncoding)
        parser.delegate = TestRDFParserDelegate()
        let graph = parser.parse()
        XCTAssertEqual(2, graph?.namespaces.count)
        XCTAssertEqual(10, graph?.statements.count)
        printGraph(graph!)
        if graph?.namespaces.count == 1 {
            XCTAssertEqual("http://example.org/stuff/1.0/", graph!.namespaceForPrefix(""))
        }
        if graph?.statements.count == 10 {
            XCTAssertTrue(graph![0].subject == graph![1].subject)
            XCTAssertTrue(graph![0].subject == graph![9].subject)
            XCTAssertTrue(graph![2].subject == graph![1].object)
            XCTAssertTrue(graph![3].subject == graph![2].object)
            XCTAssertTrue(graph![4].subject == graph![1].object)
            XCTAssertTrue(graph![5].subject == graph![4].object)
            XCTAssertTrue(graph![6].subject == graph![5].object)
            XCTAssertTrue(graph![7].subject == graph![5].object)
            XCTAssertTrue(graph![8].subject == graph![4].object)
            
            XCTAssertTrue(graph![0].predicate == RDF.first)
            XCTAssertTrue(graph![1].predicate == RDF.rest)
            XCTAssertTrue(graph![2].predicate == RDF.first)
            XCTAssertTrue(graph![3].predicate == URI(string: "http://example.org/stuff/1.0/p")!)
            XCTAssertTrue(graph![4].predicate == RDF.rest)
            XCTAssertTrue(graph![5].predicate == RDF.first)
            XCTAssertTrue(graph![6].predicate == RDF.first)
            XCTAssertTrue(graph![7].predicate == RDF.rest)
            XCTAssertTrue(graph![8].predicate == RDF.rest)
            XCTAssertTrue(graph![9].predicate == URI(string: "http://example.org/stuff/1.0/p2")!)
            
            XCTAssertTrue(graph![0].object == Literal(sparqlString: "1")!)
            XCTAssertTrue(graph![3].object == URI(string: "http://example.org/stuff/1.0/q")!)
            XCTAssertTrue(graph![6].object == Literal(sparqlString: "2")!)
            XCTAssertTrue(graph![7].object == RDF.NIL)
            XCTAssertTrue(graph![8].object == RDF.NIL)
            XCTAssertTrue(graph![9].object == URI(string: "http://example.org/stuff/1.0/q2")!)
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
