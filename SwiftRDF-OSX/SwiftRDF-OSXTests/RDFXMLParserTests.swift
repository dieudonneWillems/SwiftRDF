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
    
    func testRDFXMLParserOnGeonames() {
        /*
        do{
            let uri = URI(string: "http://sws.geonames.org/6058560/about.rdf")!
            let parser = RDFXMLParser(uri: uri)
            
            var graph = parser?.parse()
        }catch {
            
        }
        */
    }
    
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
        let parser = RDFXMLParser(data: data!, graphName: name)
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
        "</rdf:RDF>";
        let data = rdf.dataUsingEncoding(NSUTF8StringEncoding)
        let name = URI(string: "http://www.w3.org/TR/rdf-syntax-grammar/example-3")
        let parser = RDFXMLParser(data: data!, graphName: name)
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
        let parser = RDFXMLParser(data: data!, graphName: name)
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
