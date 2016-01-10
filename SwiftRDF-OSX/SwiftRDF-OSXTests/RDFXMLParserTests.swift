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
        let parser = RDFXMLParser(data: data!)
        let graph = parser.parse()
        XCTAssertEqual(2, graph?.namespaces.count)
        XCTAssertEqual(6, graph!.count)
        
    }
}
