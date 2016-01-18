//
//  RDFXMLParserTests.swift
//  SwiftRDF-OSX
//
//  Created by Don Willems on 09/01/16.
//  Copyright © 2016 lapsedpacifist. All rights reserved.
//


import XCTest
@testable import SwiftRDFOSX

import Foundation

class RDFXMLParserTests : XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    /*
    func testRDFXMLParserOnGeonames() {
        
        let uri = URI(string: "http://sws.geonames.org/6058560/about.rdf")!
        let parser = RDFXMLParser(uri: uri)
        
        var graph = parser?.parse()
        printGraph(graph!)

    }*/
    
    func testExample2() {
        let rdf = "<?xml version=\"1.0\" encoding=\"utf-8\"?>\n" +
            "<rdf:RDF xmlns:rdf=\"http://www.w3.org/1999/02/22-rdf-syntax-ns#\"\n" +
            "   xmlns:dc=\"http://purl.org/dc/elements/1.1/\"" +
            "   xmlns:ex=\"http://example.org/terms/\">\n\n" +
            "   <rdf:Description rdf:about=\"http://www.w3.org/TR/rdf-syntax-grammar\">\n" +
            "       <ex:editor>\n" +
            "           <rdf:Description>\n" +
            "               <ex:homePage>\n" +
            "                   <rdf:Description rdf:about=\"http://purl.org/net/dajobe/\">\n" +
            "                   </rdf:Description>\n" +
            "               </ex:homePage>\n" +
            "           </rdf:Description>\n" +
            "       </ex:editor>\n" +
            "   </rdf:Description>\n" +
            "</rdf:RDF>";
        let data = rdf.dataUsingEncoding(NSUTF8StringEncoding)
        let name = URI(string: "http://www.w3.org/TR/rdf-syntax-grammar/example-2")
        let parser = RDFXMLParser(data: data!, baseURI: name!)
        parser.delegate = TestRDFParserDelegate()
        let graph = parser.parse()
        XCTAssertEqual(3, graph?.namespaces.count)
        printGraph(graph!)
        XCTAssertEqual(2, graph!.count)
        let rdfxml = URI(string: "http://www.w3.org/TR/rdf-syntax-grammar")
        let exeditor = URI(string: "http://example.org/terms/editor")
        let exhomepage = URI(string: "http://example.org/terms/homePage")
        var subgraph =  graph!.subGraph(rdfxml, predicate: exeditor, object: nil)
        XCTAssertEqual(1,subgraph.count)
        subgraph =  graph!.subGraph((subgraph[0].object as! Resource), predicate: exhomepage, object: nil)
        XCTAssertEqual(1,subgraph.count)
        XCTAssertEqual("http://purl.org/net/dajobe/", subgraph[0].object.stringValue)
    }
    
    func testExample3() {
        let rdf = "<?xml version=\"1.0\" encoding=\"utf-8\"?>\n" +
            "<rdf:RDF xmlns:rdf=\"http://www.w3.org/1999/02/22-rdf-syntax-ns#\"\n" +
            "   xmlns:dc=\"http://purl.org/dc/elements/1.1/\"" +
            "   xmlns:ex=\"http://example.org/terms/\">\n\n" +
            "   <rdf:Description rdf:about=\"http://www.w3.org/TR/rdf-syntax-grammar\">\n" +
            "       <ex:editor>\n" +
            "           <rdf:Description>\n" +
            "               <ex:homePage>\n" +
            "                   <rdf:Description rdf:about=\"http://purl.org/net/dajobe/\">\n" +
            "                   </rdf:Description>\n" +
            "               </ex:homePage>\n" +
            "           </rdf:Description>\n" +
            "       </ex:editor>\n" +
            "   </rdf:Description>\n" +
            "   <rdf:Description rdf:about=\"http://www.w3.org/TR/rdf-syntax-grammar\">\n" +
            "       <ex:editor>\n" +
            "           <rdf:Description>\n" +
            "               <ex:fullName>Dave Beckett</ex:fullName>\n" +
            "           </rdf:Description>\n" +
            "       </ex:editor>\n" +
            "   </rdf:Description>\n\n" +
            "   <rdf:Description rdf:about=\"http://www.w3.org/TR/rdf-syntax-grammar\">\n" +
            "       <dc:title>RDF 1.1 XML Syntax</dc:title>\n" +
            "   </rdf:Description>\n" +
            "</rdf:RDF>";
        let data = rdf.dataUsingEncoding(NSUTF8StringEncoding)
        let name = URI(string: "http://www.w3.org/TR/rdf-syntax-grammar/example-3")
        let parser = RDFXMLParser(data: data!, baseURI: name!)
       parser.delegate = TestRDFParserDelegate()
        let graph = parser.parse()
        XCTAssertEqual(3, graph?.namespaces.count)
        printGraph(graph!)
        XCTAssertEqual(5, graph!.count)
        let rdfxml = URI(string: "http://www.w3.org/TR/rdf-syntax-grammar")
        let exeditor = URI(string: "http://example.org/terms/editor")
        let exhomepage = URI(string: "http://example.org/terms/homePage")
        let exfullname = URI(string: "http://example.org/terms/fullName")
        let dctitle = URI(string: "http://purl.org/dc/elements/1.1/title")
        var subgraph =  graph!.subGraph(rdfxml, predicate: exeditor, object: nil)
        XCTAssertEqual(2,subgraph.count)
        subgraph =  graph!.subGraph(nil, predicate: exhomepage, object: nil)
        XCTAssertEqual(1,subgraph.count)
        XCTAssertEqual("http://purl.org/net/dajobe/", subgraph[0].object.stringValue)
        subgraph =  graph!.subGraph(nil, predicate: exfullname, object: nil)
        XCTAssertEqual(1,subgraph.count)
        XCTAssertEqual("Dave Beckett", subgraph[0].object.stringValue)
        subgraph =  graph!.subGraph(rdfxml, predicate: dctitle, object: nil)
        XCTAssertEqual(1,subgraph.count)
        XCTAssertEqual("RDF 1.1 XML Syntax", subgraph[0].object.stringValue)
    }
    
    func testExample4() {
        let rdf = "<?xml version=\"1.0\" encoding=\"utf-8\"?>\n" +
            "<rdf:RDF xmlns:rdf=\"http://www.w3.org/1999/02/22-rdf-syntax-ns#\"\n" +
            "   xmlns:dc=\"http://purl.org/dc/elements/1.1/\"" +
            "   xmlns:ex=\"http://example.org/terms/\">\n\n" +
            "   <rdf:Description rdf:about=\"http://www.w3.org/TR/rdf-syntax-grammar\">\n" +
            "       <ex:editor>\n" +
            "           <rdf:Description>\n" +
            "               <ex:homePage>\n" +
            "                   <rdf:Description rdf:about=\"http://purl.org/net/dajobe/\">\n" +
            "                   </rdf:Description>\n" +
            "               </ex:homePage>\n" +
            "               <ex:fullName>Dave Beckett</ex:fullName>\n" +
            "           </rdf:Description>\n" +
            "       </ex:editor>\n" +
            "       <dc:title>RDF 1.1 XML Syntax</dc:title>\n" +
            "   </rdf:Description>\n" +
            "</rdf:RDF>";
        let data = rdf.dataUsingEncoding(NSUTF8StringEncoding)
        let name = URI(string: "http://www.w3.org/TR/rdf-syntax-grammar/example-3")
        let parser = RDFXMLParser(data: data!, baseURI: name!)
        parser.delegate = TestRDFParserDelegate()
        let graph = parser.parse()
        XCTAssertEqual(3, graph?.namespaces.count)
        printGraph(graph!)
        XCTAssertEqual(4, graph!.count)
        let rdfxml = URI(string: "http://www.w3.org/TR/rdf-syntax-grammar")
        let exeditor = URI(string: "http://example.org/terms/editor")
        let exhomepage = URI(string: "http://example.org/terms/homePage")
        let exfullname = URI(string: "http://example.org/terms/fullName")
        let dctitle = URI(string: "http://purl.org/dc/elements/1.1/title")
        var subgraph =  graph!.subGraph(rdfxml, predicate: exeditor, object: nil)
        XCTAssertEqual(1,subgraph.count)
        subgraph =  graph!.subGraph(nil, predicate: exhomepage, object: nil)
        XCTAssertEqual(1,subgraph.count)
        XCTAssertEqual("http://purl.org/net/dajobe/", subgraph[0].object.stringValue)
        subgraph =  graph!.subGraph(nil, predicate: exfullname, object: nil)
        XCTAssertEqual(1,subgraph.count)
        XCTAssertEqual("Dave Beckett", subgraph[0].object.stringValue)
        subgraph =  graph!.subGraph(rdfxml, predicate: dctitle, object: nil)
        XCTAssertEqual(1,subgraph.count)
        XCTAssertEqual("RDF 1.1 XML Syntax", subgraph[0].object.stringValue)
    }
    
    func testExample5() {
        let rdf = "<?xml version=\"1.0\" encoding=\"utf-8\"?>\n" +
            "<rdf:RDF xmlns:rdf=\"http://www.w3.org/1999/02/22-rdf-syntax-ns#\"\n" +
            "   xmlns:dc=\"http://purl.org/dc/elements/1.1/\"" +
            "   xmlns:ex=\"http://example.org/terms/\">\n\n" +
            "   <rdf:Description rdf:about=\"http://www.w3.org/TR/rdf-syntax-grammar\">" +
            "       <ex:editor>\n" +
            "           <rdf:Description>\n" +
            "               <ex:homePage rdf:resource=\"http://purl.org/net/dajobe/\"/>\n" +
            "               <ex:fullName>Dave Beckett</ex:fullName>\n" +
            "           </rdf:Description>\n" +
            "       </ex:editor>\n" +
            "       <dc:title>RDF 1.1 XML Syntax</dc:title>\n" +
            "   </rdf:Description>\n" +
        "</rdf:RDF>";
        let data = rdf.dataUsingEncoding(NSUTF8StringEncoding)
        let name = URI(string: "http://www.w3.org/TR/rdf-syntax-grammar/example-5")
        let parser = RDFXMLParser(data: data!, baseURI: name!)
        parser.delegate = TestRDFParserDelegate()
        let graph = parser.parse()
        XCTAssertEqual(3, graph?.namespaces.count)
        printGraph(graph!)
        XCTAssertEqual(4, graph!.count)
        let rdfxml = URI(string: "http://www.w3.org/TR/rdf-syntax-grammar")
        let exeditor = URI(string: "http://example.org/terms/editor")
        let exhomepage = URI(string: "http://example.org/terms/homePage")
        let exfullname = URI(string: "http://example.org/terms/fullName")
        let dctitle = URI(string: "http://purl.org/dc/elements/1.1/title")
        var subgraph =  graph!.subGraph(rdfxml, predicate: exeditor, object: nil)
        XCTAssertEqual(1,subgraph.count)
        subgraph =  graph!.subGraph(nil, predicate: exhomepage, object: nil)
        XCTAssertEqual(1,subgraph.count)
        XCTAssertEqual("http://purl.org/net/dajobe/", subgraph[0].object.stringValue)
        subgraph =  graph!.subGraph(nil, predicate: exfullname, object: nil)
        XCTAssertEqual(1,subgraph.count)
        XCTAssertEqual("Dave Beckett", subgraph[0].object.stringValue)
        subgraph =  graph!.subGraph(rdfxml, predicate: dctitle, object: nil)
        XCTAssertEqual(1,subgraph.count)
        XCTAssertEqual("RDF 1.1 XML Syntax", subgraph[0].object.stringValue)
    }
    
    func testExample6() {
        let rdf = "<?xml version=\"1.0\" encoding=\"utf-8\"?>\n" +
            "<rdf:RDF xmlns:rdf=\"http://www.w3.org/1999/02/22-rdf-syntax-ns#\"\n" +
            "   xmlns:dc=\"http://purl.org/dc/elements/1.1/\"" +
            "   xmlns:ex=\"http://example.org/terms/\">\n\n" +
            "   <rdf:Description rdf:about=\"http://www.w3.org/TR/rdf-syntax-grammar\" dc:title=\"RDF 1.1 XML Syntax\">\n" +
            "       <ex:editor>\n" +
            "           <rdf:Description ex:fullName=\"Dave Beckett\">\n" +
            "               <ex:homePage rdf:resource=\"http://purl.org/net/dajobe/\"/>\n" +
            "           </rdf:Description>\n" +
            "       </ex:editor>\n" +
            "   </rdf:Description>\n" +
            "</rdf:RDF>";
        let data = rdf.dataUsingEncoding(NSUTF8StringEncoding)
        let name = URI(string: "http://www.w3.org/TR/rdf-syntax-grammar/example-6")
        let parser = RDFXMLParser(data: data!, baseURI: name!)
        parser.delegate = TestRDFParserDelegate()
        let graph = parser.parse()
        XCTAssertEqual(3, graph?.namespaces.count)
        printGraph(graph!)
        XCTAssertEqual(4, graph!.count)
        let rdfxml = URI(string: "http://www.w3.org/TR/rdf-syntax-grammar")
        let exeditor = URI(string: "http://example.org/terms/editor")
        let exhomepage = URI(string: "http://example.org/terms/homePage")
        let exfullname = URI(string: "http://example.org/terms/fullName")
        let dctitle = URI(string: "http://purl.org/dc/elements/1.1/title")
        var subgraph =  graph!.subGraph(rdfxml, predicate: exeditor, object: nil)
        XCTAssertEqual(1,subgraph.count)
        subgraph =  graph!.subGraph(nil, predicate: exhomepage, object: nil)
        XCTAssertEqual(1,subgraph.count)
        XCTAssertEqual("http://purl.org/net/dajobe/", subgraph[0].object.stringValue)
        subgraph =  graph!.subGraph(nil, predicate: exfullname, object: nil)
        XCTAssertEqual(1,subgraph.count)
        XCTAssertEqual("Dave Beckett", subgraph[0].object.stringValue)
        subgraph =  graph!.subGraph(rdfxml, predicate: dctitle, object: nil)
        XCTAssertEqual(1,subgraph.count)
        XCTAssertEqual("RDF 1.1 XML Syntax", subgraph[0].object.stringValue)
    }
    
    func testExample8() {
        let rdf = "<?xml version=\"1.0\" encoding=\"utf-8\"?>\n" +
            "<rdf:RDF xmlns:rdf=\"http://www.w3.org/1999/02/22-rdf-syntax-ns#\"\n" +
            "   xmlns:dc=\"http://purl.org/dc/elements/1.1/\">\n\n" +
            "   <rdf:Description rdf:about=\"http://www.w3.org/TR/rdf-syntax-grammar\">\n" +
            "       <dc:title>RDF 1.1 XML Syntax</dc:title>\n" +
            "       <dc:title xml:lang=\"en\">RDF 1.1 XML Syntax</dc:title>\n" +
            "       <dc:title xml:lang=\"en-US\">RDF 1.1 XML Syntax</dc:title>\n" +
            "   </rdf:Description>\n\n" +
            "   <rdf:Description rdf:about=\"http://example.org/buecher/baum\" xml:lang=\"de\">\n" +
            "       <dc:title>Der Baum</dc:title>\n" +
            "       <dc:description>Das Buch ist außergewöhnlich</dc:description>\n" +
            "       <dc:title xml:lang=\"en\">The Tree</dc:title>\n" +
            "   </rdf:Description>\n\n" +
            "</rdf:RDF>";
        let data = rdf.dataUsingEncoding(NSUTF8StringEncoding)
        let name = URI(string: "http://www.w3.org/TR/rdf-syntax-grammar/example-8")
        let parser = RDFXMLParser(data: data!, baseURI: name!)
        parser.delegate = TestRDFParserDelegate()
        let graph = parser.parse()
        XCTAssertEqual(2, graph?.namespaces.count)
        printGraph(graph!)
        XCTAssertEqual(6, graph!.count)
        let rdfxml = URI(string: "http://www.w3.org/TR/rdf-syntax-grammar")
        let dctitle = URI(string: "http://purl.org/dc/elements/1.1/title")
        let dcdescription = URI(string: "http://purl.org/dc/elements/1.1/description")
        let derbaum = URI(string: "http://example.org/buecher/baum")
        var subgraph =  graph!.subGraph(rdfxml, predicate: dctitle, object: nil)
        XCTAssertEqual(3,subgraph.count)
        subgraph =  graph!.subGraph(derbaum, predicate: dctitle, object: nil)
        XCTAssertEqual(2,subgraph.count)
        subgraph =  graph!.subGraph(derbaum, predicate: dcdescription, object: nil)
        XCTAssertEqual(1,subgraph.count)
        XCTAssertEqual("Das Buch ist außergewöhnlich", subgraph[0].object.stringValue)
    }
    
    func testExample9() {
        let rdf = "<?xml version=\"1.0\" encoding=\"utf-8\"?>\n" +
            "<rdf:RDF xmlns:rdf=\"http://www.w3.org/1999/02/22-rdf-syntax-ns#\"\n" +
            "   xmlns:ex=\"http://example.org/stuff/1.0/\">\n" +
            "   <rdf:Description rdf:about=\"http://example.org/item01\">\n" +
            "       <ex:prop rdf:parseType=\"Literal\" xmlns:a=\"http://example.org/a#\">\n" +
            "           <a:Box required=\"true\">\n" +
            "               <a:widget size=\"10\"/>\n" +
            "               <a:grommit id=\"23\"/>\n" +
            "               <a:shawn>\n" +
            "                   Test text with <b>bold</b> fragment.\n" +
            "               </a:shawn>\n" +
            "           </a:Box>\n" +
            "       </ex:prop>\n" +
            "   </rdf:Description>\n" +
            "</rdf:RDF>";
        let data = rdf.dataUsingEncoding(NSUTF8StringEncoding)
        let name = URI(string: "http://www.w3.org/TR/rdf-syntax-grammar/example-9")
        let parser = RDFXMLParser(data: data!, baseURI: name!)
        parser.delegate = TestRDFParserDelegate()
        let graph = parser.parse()
        XCTAssertEqual(2, graph?.namespaces.count)
        printGraph(graph!)
        XCTAssertEqual(1, graph!.count)
        let item01 = URI(string: "http://example.org/item01")
        let exprop = URI(string: "http://example.org/stuff/1.0/prop")
        XCTAssertTrue(item01! == graph![0].subject)
        XCTAssertTrue(exprop! == graph![0].predicate)
        let xml = "\n" +
            "           <a:Box required=\"true\" xmlns:a=\"http://example.org/a#\">\n" +
            "               <a:widget size=\"10\"/>\n" +
            "               <a:grommit id=\"23\"/>\n" +
            "               <a:shawn>\n" +
            "                   Test text with <b>bold</b> fragment.\n" +
            "               </a:shawn>\n" +
            "           </a:Box>"
        print(xml)
        print(graph![0].object.stringValue)
        XCTAssertEqual(xml, graph![0].object.stringValue)
    }
    
    
    func testExample9a() {
        let rdf = "<?xml version=\"1.0\" encoding=\"utf-8\"?>\n" +
            "<rdf:RDF xmlns:rdf=\"http://www.w3.org/1999/02/22-rdf-syntax-ns#\"\n" +
            "   xmlns:ex=\"http://example.org/stuff/1.0/\">\n" +
            "   <rdf:Description rdf:about=\"http://example.org/item01\">\n" +
            "       <ex:prop rdf:parseType=\"Literal\" xmlns:a=\"http://example.org/a#\">\n" +
            "           <a:Box required=\"true\">\n" +
            "               <a:widget size=\"10\"/>\n" +
            "               <a:grommit id=\"23\"/>\n" +
            "               <b:shawn c:width=\"5\" xmlns:b=\"http://example.org/b#\" xmlns:c=\"http://example.org/c#\">\n" +
            "                   Test text with <b>bold</b> fragment.\n" +
            "               </b:shawn>\n" +
            "           </a:Box>\n" +
            "       </ex:prop>\n" +
            "   </rdf:Description>\n" +
        "</rdf:RDF>";
        let data = rdf.dataUsingEncoding(NSUTF8StringEncoding)
        let name = URI(string: "http://www.w3.org/TR/rdf-syntax-grammar/example-9a")
        let parser = RDFXMLParser(data: data!, baseURI: name!)
        parser.delegate = TestRDFParserDelegate()
        let graph = parser.parse()
        XCTAssertEqual(2, graph?.namespaces.count)
        printGraph(graph!)
        XCTAssertEqual(1, graph!.count)
        let item01 = URI(string: "http://example.org/item01")
        let exprop = URI(string: "http://example.org/stuff/1.0/prop")
        XCTAssertTrue(item01! == graph![0].subject)
        XCTAssertTrue(exprop! == graph![0].predicate)
        let xml = "\n" +
            "           <a:Box required=\"true\" xmlns:a=\"http://example.org/a#\">\n" +
            "               <a:widget size=\"10\"/>\n" +
            "               <a:grommit id=\"23\"/>\n" +
            "               <b:shawn c:width=\"5\" xmlns:b=\"http://example.org/b#\" xmlns:c=\"http://example.org/c#\">\n" +
            "                   Test text with <b>bold</b> fragment.\n" +
            "               </b:shawn>\n" +
            "           </a:Box>"
        print(xml)
        print(graph![0].object.stringValue)
        XCTAssertEqual(xml, graph![0].object.stringValue)
    }
    
    
    
    func testExample9b() {
        let rdf = "<?xml version=\"1.0\" encoding=\"utf-8\"?>\n" +
            "<rdf:RDF xmlns:rdf=\"http://www.w3.org/1999/02/22-rdf-syntax-ns#\"\n" +
            "   xmlns:ex=\"http://example.org/stuff/1.0/\">\n" +
            "   <rdf:Description rdf:about=\"http://example.org/item01\">\n" +
            "       <ex:prop rdf:parseType=\"Literal\" xmlns:a=\"http://example.org/a#\" xmlns:b=\"http://example.org/b#\" xmlns:c=\"http://example.org/c#\">\n" +
            "           <a:Box required=\"true\">\n" +
            "               <a:widget size=\"10\"/>\n" +
            "               <a:grommit id=\"23\"/>\n" +
            "               <b:shawn c:width=\"5\">\n" +
            "                   Test text with <b>bold</b> fragment.\n" +
            "               </b:shawn>\n" +
            "           </a:Box>\n" +
            "       </ex:prop>\n" +
            "   </rdf:Description>\n" +
        "</rdf:RDF>";
        let data = rdf.dataUsingEncoding(NSUTF8StringEncoding)
        let name = URI(string: "http://www.w3.org/TR/rdf-syntax-grammar/example-9b")
        let parser = RDFXMLParser(data: data!, baseURI: name!)
        parser.delegate = TestRDFParserDelegate()
        let graph = parser.parse()
        XCTAssertEqual(2, graph?.namespaces.count)
        printGraph(graph!)
        XCTAssertEqual(1, graph!.count)
        let item01 = URI(string: "http://example.org/item01")
        let exprop = URI(string: "http://example.org/stuff/1.0/prop")
        XCTAssertTrue(item01! == graph![0].subject)
        XCTAssertTrue(exprop! == graph![0].predicate)
        let xml = "\n" +
            "           <a:Box required=\"true\" xmlns:a=\"http://example.org/a#\">\n" +
            "               <a:widget size=\"10\"/>\n" +
            "               <a:grommit id=\"23\"/>\n" +
            "               <b:shawn c:width=\"5\" xmlns:b=\"http://example.org/b#\" xmlns:c=\"http://example.org/c#\">\n" +
            "                   Test text with <b>bold</b> fragment.\n" +
            "               </b:shawn>\n" +
        "           </a:Box>"
        print(xml)
        print(graph![0].object.stringValue)
        XCTAssertEqual(xml, graph![0].object.stringValue)
    }
    
    
    
    func testExample9c() {
        let rdf = "<?xml version=\"1.0\" encoding=\"utf-8\"?>\n" +
            "<rdf:RDF xmlns:rdf=\"http://www.w3.org/1999/02/22-rdf-syntax-ns#\"\n" +
            "   xmlns:ex=\"http://example.org/stuff/1.0/\">\n" +
            "   <rdf:Description rdf:about=\"http://example.org/item01\">\n" +
            "       <ex:prop rdf:parseType=\"Literal\" xmlns:a=\"http://example.org/a#\">\n" +
            "           <a:Box required=\"true\">\n" +
            "               <a:widget size=\"10\"/>\n" +
            "               <a:grommit id=\"23\"/>\n" +
            "               <b:shawn>\n" +
            "                   Test text with <b>bold</b> fragment.\n" +
            "               </b:shawn>\n" +
            "           </a:Box>\n" +
            "       </ex:prop>\n" +
            "   </rdf:Description>\n" +
        "</rdf:RDF>";
        let data = rdf.dataUsingEncoding(NSUTF8StringEncoding)
        let name = URI(string: "http://www.w3.org/TR/rdf-syntax-grammar/example-9c")
        let parser = RDFXMLParser(data: data!, baseURI: name!)
        parser.delegate = TestRDFParserDelegate()
        let graph = parser.parse()
        XCTAssertTrue(graph == nil)
    }
    
    func testExample10() {
        let rdf = "<?xml version=\"1.0\" encoding=\"utf-8\"?>\n" +
            "<rdf:RDF xmlns:rdf=\"http://www.w3.org/1999/02/22-rdf-syntax-ns#\"\n" +
            "   xmlns:ex=\"http://example.org/stuff/1.0/\" \n" +
            "   xmlns:dc=\"http://purl.org/dc/elements/1.1/\">\n\n" +
            "   <rdf:Description rdf:about=\"http://example.org/item01\">\n" +
            "       <ex:size rdf:datatype=\"http://www.w3.org/2001/XMLSchema#int\">123</ex:size>\n" +
            "   </rdf:Description>" +
            "</rdf:RDF>";
        let data = rdf.dataUsingEncoding(NSUTF8StringEncoding)
        let name = URI(string: "http://www.w3.org/TR/rdf-syntax-grammar/example-10")
        let parser = RDFXMLParser(data: data!, baseURI: name!)
        parser.delegate = TestRDFParserDelegate()
        let graph = parser.parse()
        XCTAssertEqual(3, graph?.namespaces.count)
        printGraph(graph!)
        XCTAssertEqual(1, graph!.count)
        let item01 = URI(string: "http://example.org/item01")
        let exsize = URI(string: "http://example.org/stuff/1.0/size")
        let subgraph =  graph!.subGraph(item01, predicate: exsize, object: nil)
        XCTAssertEqual(1,subgraph.count)
        XCTAssertTrue(XSD.int == (subgraph[0].object as! Literal).dataType!)
        XCTAssertTrue(123 == (subgraph[0].object as! Literal).intValue!)
    }
    
    func testExample11() {
        let rdf = "<?xml version=\"1.0\" encoding=\"utf-8\"?>\n" +
            "<rdf:RDF xmlns:rdf=\"http://www.w3.org/1999/02/22-rdf-syntax-ns#\"\n" +
            "   xmlns:ex=\"http://example.org/stuff/1.0/\" \n" +
            "   xmlns:dc=\"http://purl.org/dc/elements/1.1/\">\n\n" +
            "   <rdf:Description rdf:about=\"http://www.w3.org/TR/rdf-syntax-grammar\"\n" +
            "       dc:title=\"RDF 1.1 XML Syntax\">\n" +
            "       <ex:editor rdf:nodeID=\"abc\"/>\n" +
            "   </rdf:Description>\n\n" +
            "   <rdf:Description rdf:nodeID=\"abc\" ex:fullName=\"Dave Beckett\">\n" +
            "       <ex:homePage rdf:resource=\"http://purl.org/net/dajobe/\"/>\n " +
            "   </rdf:Description>\n" +
            "</rdf:RDF>";
        let data = rdf.dataUsingEncoding(NSUTF8StringEncoding)
        let name = URI(string: "http://www.w3.org/TR/rdf-syntax-grammar/example-11")
        let parser = RDFXMLParser(data: data!, baseURI: name!)
        parser.delegate = TestRDFParserDelegate()
        let graph = parser.parse()
        XCTAssertEqual(3, graph?.namespaces.count)
        printGraph(graph!)
        XCTAssertEqual(4, graph!.count)
    }
    
    func testExample12() {
        let rdf = "<?xml version=\"1.0\" encoding=\"utf-8\"?>\n" +
            "<rdf:RDF xmlns:rdf=\"http://www.w3.org/1999/02/22-rdf-syntax-ns#\"\n" +
            "   xmlns:ex=\"http://example.org/stuff/1.0/\" \n" +
            "   xmlns:dc=\"http://purl.org/dc/elements/1.1/\">\n\n" +
            "   <rdf:Description rdf:about=\"http://www.w3.org/TR/rdf-syntax-grammar\"\n" +
            "       dc:title=\"RDF 1.1 XML Syntax\">\n" +
            "       <ex:editor rdf:parseType=\"Resource\">\n" +
            "           <ex:fullName>Dave Beckett</ex:fullName>\n" +
            "           <ex:homePage rdf:resource=\"http://purl.org/net/dajobe/\"/>\n" +
            "       </ex:editor>\n" +
            "   </rdf:Description>\n" +
            "</rdf:RDF>";
        let data = rdf.dataUsingEncoding(NSUTF8StringEncoding)
        let name = URI(string: "http://www.w3.org/TR/rdf-syntax-grammar/example-12")
        let parser = RDFXMLParser(data: data!, baseURI: name!)
        parser.delegate = TestRDFParserDelegate()
        let graph = parser.parse()
        XCTAssertEqual(3, graph?.namespaces.count)
        printGraph(graph!)
        XCTAssertEqual(4, graph!.count)
    }
    
    func testExample13() {
        let rdf = "<?xml version=\"1.0\" encoding=\"utf-8\"?>\n" +
            "<rdf:RDF xmlns:rdf=\"http://www.w3.org/1999/02/22-rdf-syntax-ns#\"\n" +
            "   xmlns:ex=\"http://example.org/stuff/1.0/\" \n" +
            "   xmlns:dc=\"http://purl.org/dc/elements/1.1/\">\n\n" +
            "   <rdf:Description rdf:about=\"http://www.w3.org/TR/rdf-syntax-grammar\"\n" +
            "       dc:title=\"RDF 1.1 XML Syntax\">\n" +
            "       <ex:editor ex:fullName=\"Dave Beckett\" /> \n" +
            "   </rdf:Description>\n" +
            "</rdf:RDF>";
        let data = rdf.dataUsingEncoding(NSUTF8StringEncoding)
        let name = URI(string: "http://www.w3.org/TR/rdf-syntax-grammar/example-13")
        let parser = RDFXMLParser(data: data!, baseURI: name!)
        parser.delegate = TestRDFParserDelegate()
        let graph = parser.parse()
        XCTAssertEqual(3, graph?.namespaces.count)
        printGraph(graph!)
        XCTAssertEqual(3, graph!.count)
    }
    
    func testExample15() {
        let rdf = "<?xml version=\"1.0\" encoding=\"utf-8\"?>\n" +
            "<rdf:RDF xmlns:rdf=\"http://www.w3.org/1999/02/22-rdf-syntax-ns#\"\n" +
            "   xmlns:ex=\"http://example.org/stuff/1.0/\" \n" +
            "   xmlns:dc=\"http://purl.org/dc/elements/1.1/\">\n\n" +
            "   <ex:Document rdf:about=\"http://example.org/thing\">\n" +
            "       <dc:title>A marvelous thing</dc:title>\n" +
            "   </ex:Document>\n" +
            "</rdf:RDF>";
        let data = rdf.dataUsingEncoding(NSUTF8StringEncoding)
        let name = URI(string: "http://www.w3.org/TR/rdf-syntax-grammar/example-15")
        let parser = RDFXMLParser(data: data!, baseURI: name!)
        parser.delegate = TestRDFParserDelegate()
        let graph = parser.parse()
        XCTAssertEqual(3, graph?.namespaces.count)
        printGraph(graph!)
        XCTAssertEqual(2, graph!.count)
        let subgraph =  graph!.subGraph(nil, predicate: RDF.type, object: nil)
        XCTAssertEqual(1,subgraph.count)
        XCTAssertEqual("http://example.org/thing",(subgraph[0].subject as! URI).stringValue)
        XCTAssertEqual("http://example.org/stuff/1.0/Document",(subgraph[0].object as! URI).stringValue)
    }
    
    func testExample15a() {
        let rdf = "<?xml version=\"1.0\" encoding=\"utf-8\"?>\n" +
            "<rdf:RDF xmlns:rdf=\"http://www.w3.org/1999/02/22-rdf-syntax-ns#\"\n" +
            "   xmlns:ex=\"http://example.org/stuff/1.0/\" \n" +
            "   xmlns:dc=\"http://purl.org/dc/elements/1.1/\">\n\n" +
            "   <ex:Document rdf:about=\"http://example.org/thing\">\n" +
            "       <ex:author>\n" +
            "           <ex:Person ex:fullName=\"Arthur Dent\"/> \n" +
            "       </ex:author>\n" +
            "   </ex:Document>\n" +
        "</rdf:RDF>";
        let data = rdf.dataUsingEncoding(NSUTF8StringEncoding)
        let name = URI(string: "http://www.w3.org/TR/rdf-syntax-grammar/example-15a")
        let parser = RDFXMLParser(data: data!, baseURI: name!)
        parser.delegate = TestRDFParserDelegate()
        let graph = parser.parse()
        XCTAssertEqual(3, graph?.namespaces.count)
        printGraph(graph!)
        XCTAssertEqual(4, graph!.count)
        let subgraph =  graph!.subGraph(nil, predicate: RDF.type, object: nil)
        XCTAssertEqual(2,subgraph.count)
        XCTAssertEqual("http://example.org/thing",(subgraph[0].subject as! URI).stringValue)
        XCTAssertEqual("http://example.org/stuff/1.0/Document",(subgraph[0].object as! URI).stringValue)
        XCTAssertEqual("http://example.org/stuff/1.0/Person",(subgraph[1].object as! URI).stringValue)
    }
    
    func testExample16() {
        let rdf = "<?xml version=\"1.0\" encoding=\"utf-8\"?>\n" +
            "<rdf:RDF xmlns:rdf=\"http://www.w3.org/1999/02/22-rdf-syntax-ns#\"\n" +
            "   xmlns:ex=\"http://example.org/stuff/1.0/\" \n" +
            "   xml:base=\"http://example.org/here/\">\n" +
            "   <rdf:Description rdf:ID=\"snack\">\n" +
            "       <ex:prop rdf:resource=\"fruit/apple\"/>" +
            "   </rdf:Description>\n" +
            "</rdf:RDF>";
        let data = rdf.dataUsingEncoding(NSUTF8StringEncoding)
        let name = URI(string: "http://www.w3.org/TR/rdf-syntax-grammar/example-16")
        let parser = RDFXMLParser(data: data!, baseURI: name!)
        parser.delegate = TestRDFParserDelegate()
        let graph = parser.parse()
        XCTAssertEqual(2, graph?.namespaces.count)
        printGraph(graph!)
        XCTAssertEqual(1, graph!.count)
        XCTAssertEqual("http://example.org/here/#snack",(graph![0].subject as! URI).stringValue)
        XCTAssertEqual("http://example.org/here/fruit/apple",(graph![0].object as! URI).stringValue)
    }
    
    func testExample17() {
        let rdf = "<?xml version=\"1.0\" encoding=\"utf-8\"?>\n" +
            "<rdf:RDF xmlns:rdf=\"http://www.w3.org/1999/02/22-rdf-syntax-ns#\"\n" +
            "   xmlns:ex=\"http://example.org/stuff/1.0/\" \n" +
            "   xml:base=\"http://example.org/here/\">\n" +
            "   <rdf:Seq rdf:about=\"http://example.org/favourite-fruit\">\n" +
            "       <rdf:_1 rdf:resource=\"http://example.org/banana\"/>\n" +
            "       <rdf:_2 rdf:resource=\"http://example.org/apple\"/>\n" +
            "       <rdf:_3 rdf:resource=\"http://example.org/pear\"/>\n" +
            "   </rdf:Seq>\n" +
            "</rdf:RDF>";
        let data = rdf.dataUsingEncoding(NSUTF8StringEncoding)
        let name = URI(string: "http://www.w3.org/TR/rdf-syntax-grammar/example-17")
        let parser = RDFXMLParser(data: data!, baseURI: name!)
        parser.delegate = TestRDFParserDelegate()
        let graph = parser.parse()
        XCTAssertEqual(2, graph?.namespaces.count)
        printGraph(graph!)
        XCTAssertEqual(4, graph!.count)
        XCTAssertEqual("http://example.org/favourite-fruit",(graph![0].subject as! URI).stringValue)
        XCTAssertEqual("http://example.org/favourite-fruit",(graph![1].subject as! URI).stringValue)
        XCTAssertEqual("http://example.org/favourite-fruit",(graph![2].subject as! URI).stringValue)
        XCTAssertEqual("http://example.org/favourite-fruit",(graph![3].subject as! URI).stringValue)
        XCTAssertEqual(RDF.Seq.stringValue,(graph![0].object as! URI).stringValue)
        XCTAssertEqual("http://example.org/banana",(graph![1].object as! URI).stringValue)
        XCTAssertEqual("http://example.org/apple",(graph![2].object as! URI).stringValue)
        XCTAssertEqual("http://example.org/pear",(graph![3].object as! URI).stringValue)
        XCTAssertEqual(RDF.type.stringValue,graph![0].predicate.stringValue)
        XCTAssertEqual(URI(namespace: RDF.NAMESPACE, localName: "_1")!.stringValue,graph![1].predicate.stringValue)
        XCTAssertEqual(URI(namespace: RDF.NAMESPACE, localName: "_2")!.stringValue,graph![2].predicate.stringValue)
        XCTAssertEqual(URI(namespace: RDF.NAMESPACE, localName: "_3")!.stringValue,graph![3].predicate.stringValue)
    }
    
    func testExample18() {
        let rdf = "<?xml version=\"1.0\" encoding=\"utf-8\"?>\n" +
            "<rdf:RDF xmlns:rdf=\"http://www.w3.org/1999/02/22-rdf-syntax-ns#\"\n" +
            "   xmlns:ex=\"http://example.org/stuff/1.0/\" \n" +
            "   xml:base=\"http://example.org/here/\">\n" +
            "   <rdf:Seq rdf:about=\"http://example.org/favourite-fruit\">\n" +
            "       <rdf:li rdf:resource=\"http://example.org/banana\"/>\n" +
            "       <rdf:li rdf:resource=\"http://example.org/apple\"/>\n" +
            "       <rdf:li rdf:resource=\"http://example.org/pear\"/>\n" +
            "   </rdf:Seq>\n" +
        "</rdf:RDF>";
        let data = rdf.dataUsingEncoding(NSUTF8StringEncoding)
        let name = URI(string: "http://www.w3.org/TR/rdf-syntax-grammar/example-18")
        let parser = RDFXMLParser(data: data!, baseURI: name!)
        parser.delegate = TestRDFParserDelegate()
        let graph = parser.parse()
        XCTAssertEqual(2, graph?.namespaces.count)
        printGraph(graph!)
        XCTAssertEqual(4, graph!.count)
        XCTAssertEqual("http://example.org/favourite-fruit",(graph![0].subject as! URI).stringValue)
        XCTAssertEqual("http://example.org/favourite-fruit",(graph![1].subject as! URI).stringValue)
        XCTAssertEqual("http://example.org/favourite-fruit",(graph![2].subject as! URI).stringValue)
        XCTAssertEqual("http://example.org/favourite-fruit",(graph![3].subject as! URI).stringValue)
        XCTAssertEqual(RDF.Seq.stringValue,(graph![0].object as! URI).stringValue)
        XCTAssertEqual("http://example.org/banana",(graph![1].object as! URI).stringValue)
        XCTAssertEqual("http://example.org/apple",(graph![2].object as! URI).stringValue)
        XCTAssertEqual("http://example.org/pear",(graph![3].object as! URI).stringValue)
        XCTAssertEqual(RDF.type.stringValue,graph![0].predicate.stringValue)
        XCTAssertEqual(URI(namespace: RDF.NAMESPACE, localName: "_1")!.stringValue,graph![1].predicate.stringValue)
        XCTAssertEqual(URI(namespace: RDF.NAMESPACE, localName: "_2")!.stringValue,graph![2].predicate.stringValue)
        XCTAssertEqual(URI(namespace: RDF.NAMESPACE, localName: "_3")!.stringValue,graph![3].predicate.stringValue)
    }
    
    func testExample18a() {
        let rdf = "<?xml version=\"1.0\" encoding=\"utf-8\"?>\n" +
            "<rdf:RDF xmlns:rdf=\"http://www.w3.org/1999/02/22-rdf-syntax-ns#\"\n" +
            "   xmlns:ex=\"http://example.org/stuff/1.0/\" \n" +
            "   xml:base=\"http://example.org/here/\">\n" +
            "   <rdf:Seq rdf:about=\"http://example.org/favourite-fruit\">\n" +
            "       <rdf:li rdf:resource=\"http://example.org/banana\"/>\n" +
            "       <rdf:li>\n" +
            "           <rdf:Description ex:name=\"apple\"/>\n" +
            "       </rdf:li>\n" +
            "       <rdf:li rdf:resource=\"http://example.org/pear\"/>\n" +
            "   </rdf:Seq>\n" +
        "</rdf:RDF>";
        let data = rdf.dataUsingEncoding(NSUTF8StringEncoding)
        let name = URI(string: "http://www.w3.org/TR/rdf-syntax-grammar/example-18a")
        let parser = RDFXMLParser(data: data!, baseURI: name!)
        parser.delegate = TestRDFParserDelegate()
        let graph = parser.parse()
        XCTAssertEqual(2, graph?.namespaces.count)
        printGraph(graph!)
        XCTAssertEqual(5, graph!.count)
        XCTAssertEqual("http://example.org/favourite-fruit",(graph![0].subject as! URI).stringValue)
        XCTAssertEqual("http://example.org/favourite-fruit",(graph![1].subject as! URI).stringValue)
        XCTAssertEqual("http://example.org/favourite-fruit",(graph![2].subject as! URI).stringValue)
        XCTAssertEqual("http://example.org/favourite-fruit",(graph![4].subject as! URI).stringValue)
        XCTAssertEqual(RDF.Seq.stringValue,(graph![0].object as! URI).stringValue)
        XCTAssertEqual("http://example.org/banana",(graph![1].object as! URI).stringValue)
        XCTAssertEqual("http://example.org/pear",(graph![4].object as! URI).stringValue)
        XCTAssertEqual(RDF.type.stringValue,graph![0].predicate.stringValue)
        XCTAssertEqual(URI(namespace: RDF.NAMESPACE, localName: "_1")!.stringValue,graph![1].predicate.stringValue)
        XCTAssertEqual(URI(namespace: RDF.NAMESPACE, localName: "_2")!.stringValue,graph![2].predicate.stringValue)
        XCTAssertEqual(URI(namespace: RDF.NAMESPACE, localName: "_3")!.stringValue,graph![4].predicate.stringValue)
    }
    
    func testExample19() {
        let rdf = "<?xml version=\"1.0\" encoding=\"utf-8\"?>\n" +
            "<rdf:RDF xmlns:rdf=\"http://www.w3.org/1999/02/22-rdf-syntax-ns#\"\n" +
            "   xmlns:ex=\"http://example.org/stuff/1.0/\" \n" +
            "   xml:base=\"http://example.org/here/\">\n" +
            "   <rdf:Description rdf:about=\"http://example.org/basket\">\n" +
            "       <ex:hasFruit rdf:parseType=\"Collection\">\n" +
            "           <rdf:Description rdf:about=\"http://example.org/banana\"/>\n" +
            "           <rdf:Description rdf:about=\"http://example.org/apple\"/>\n" +
            "           <rdf:Description rdf:about=\"http://example.org/pear\"/>\n" +
            "       </ex:hasFruit>\n" +
            "   </rdf:Description>\n" +
            "</rdf:RDF>";
        let data = rdf.dataUsingEncoding(NSUTF8StringEncoding)
        let name = URI(string: "http://www.w3.org/TR/rdf-syntax-grammar/example-19")
        let parser = RDFXMLParser(data: data!, baseURI: name!)
        parser.delegate = TestRDFParserDelegate()
        let graph = parser.parse()
        XCTAssertEqual(2, graph?.namespaces.count)
        printGraph(graph!)
        XCTAssertEqual(7, graph!.count)
        let subgraphFirst = graph!.subGraph(nil, predicate: RDF.first, object: nil)
        XCTAssertEqual(3, subgraphFirst.count)
        let subgraphRest = graph!.subGraph(nil, predicate: RDF.rest, object: nil)
        XCTAssertEqual(3, subgraphRest.count)
    }
    
    func testExample20() {
        let rdf = "<?xml version=\"1.0\" encoding=\"utf-8\"?>\n" +
            "<rdf:RDF xmlns:rdf=\"http://www.w3.org/1999/02/22-rdf-syntax-ns#\"\n" +
            "   xmlns:ex=\"http://example.org/stuff/1.0/\" \n" +
            "   xml:base=\"http://example.org/here/\">\n" +
            "   <rdf:Description rdf:about=\"http://example.org/\">\n" +
            "       <ex:prop rdf:ID=\"triple1\">blah</ex:prop>\n " +
            "   </rdf:Description>\n" +
            "</rdf:RDF>";
        let data = rdf.dataUsingEncoding(NSUTF8StringEncoding)
        let name = URI(string: "http://www.w3.org/TR/rdf-syntax-grammar/example-20")
        let parser = RDFXMLParser(data: data!, baseURI: name!)
        parser.delegate = TestRDFParserDelegate()
        let graph = parser.parse()
        XCTAssertEqual(2, graph?.namespaces.count)
        printGraph(graph!)
        XCTAssertEqual(5, graph!.count)
        let exprop = URI(string: "http://example.org/stuff/1.0/prop")
        let triple1 = URI(string: "http://example.org/triples/#triple1")
        XCTAssertEqual("http://example.org/",(graph![0].subject as! URI).stringValue)
        XCTAssertEqual(exprop?.stringValue,graph![0].predicate.stringValue)
        XCTAssertEqual(triple1?.stringValue,(graph![1].subject as! URI).stringValue)
        XCTAssertEqual(RDF.type.stringValue,graph![1].predicate.stringValue)
        XCTAssertEqual(RDF.Statement.stringValue,(graph![1].object as! URI).stringValue)
        XCTAssertEqual(triple1?.stringValue,(graph![2].subject as! URI).stringValue)
        XCTAssertEqual(RDF.subject.stringValue,graph![2].predicate.stringValue)
        XCTAssertEqual("http://example.org/",(graph![2].object as! URI).stringValue)
        XCTAssertEqual(triple1?.stringValue,(graph![3].subject as! URI).stringValue)
        XCTAssertEqual(RDF.predicate.stringValue,graph![3].predicate.stringValue)
        XCTAssertEqual(exprop!.stringValue,(graph![3].object as! URI).stringValue)
        XCTAssertEqual(triple1?.stringValue,(graph![4].subject as! URI).stringValue)
        XCTAssertEqual(RDF.object.stringValue,graph![4].predicate.stringValue)
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

class TestRDFParserDelegate : RDFParserDelegate {
    
    func parserDidStartDocument(_parser : RDFParser) {
        print("RDF Parser started")
    }
    
    func parserDidEndDocument(_parser : RDFParser) {
        print("RDF Parser finished")
    }
    
    func parserErrorOccurred(_parser : RDFParser, error: RDFParserError) {
        switch error {
        case .couldNotCreateRDFParser(let message) :
            print("Could not create RDF parser: \(message)")
            break
        case .couldNotRetrieveRDFFileFromURI(let message, let uri) :
            print("Could not retrieve RDF file from URI '\(uri.stringValue)': \(message)")
            break
        case .couldNotRetrieveRDFFileFromURL(let message, let url) :
            print("Could not retrieve RDF file from URL '\(url)': \(message)")
            break
        case .malformedRDFFormat(let message) :
            print("Malformed RDF: \(message)")
            break
        }
    }
    
    func namespaceAdded(_parser : RDFParser, graph : Graph, prefix : String, namespaceURI : String) {
        print("RDF Parser: namespace with prefix \(prefix) and URI \(namespaceURI) was added.")
    }
    
    func statementAdded(_parser : RDFParser, graph : Graph, statement : Statement) {
        print("RDF Parser: the statement \(statement) was added.")
    }
}
