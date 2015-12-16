//
//  MiscellaneousTypesLiteralTests.swift
//  SwiftRDF-OSX
//
//  Created by Don Willems on 17/12/15.
//  Copyright © 2015 lapsedpacifist. All rights reserved.
//

import Foundation

import XCTest
@testable import SwiftRDFOSX

class MiscellaneousTypesLiteralTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testHexBinaryDataLiterals() {
        let string = "greenland"
        let plainData = (string as NSString).dataUsingEncoding(NSUTF8StringEncoding)!
        var lit = Literal(hexadecimalBinaryValue: plainData)
        XCTAssertEqual("677265656e6c616e64", lit.stringValue)
        XCTAssertEqual("\"677265656e6c616e64\"^^xsd:hexBinary", lit.sparql)
        XCTAssertTrue(XSD.hexBinary == lit.dataType!)
        XCTAssertNil(lit.longValue)
        
        lit = Literal(stringValue: "677265656e6c616e64",dataType: XSD.hexBinary)!
        XCTAssertEqual("677265656e6c616e64", lit.stringValue)
        XCTAssertEqual("\"677265656e6c616e64\"^^xsd:hexBinary", lit.sparql)
        XCTAssertTrue(XSD.hexBinary == lit.dataType!)
        
        lit = Literal(sparqlString: "\"677265656e6c616e64\"^^xsd:hexBinary")!
        XCTAssertEqual("677265656e6c616e64", lit.stringValue)
        XCTAssertEqual("\"677265656e6c616e64\"^^xsd:hexBinary", lit.sparql)
        XCTAssertTrue(XSD.hexBinary == lit.dataType!)
    }
    
    func testBase64BinaryDataLiterals() {
        let string = "greenland"
        let plainData = (string as NSString).dataUsingEncoding(NSUTF8StringEncoding)!
        var lit = Literal(base64BinaryValue: plainData)
        XCTAssertEqual("Z3JlZW5sYW5k", lit.stringValue)
        XCTAssertEqual("\"Z3JlZW5sYW5k\"^^xsd:base64Binary", lit.sparql)
        XCTAssertTrue(XSD.base64Binary == lit.dataType!)
        XCTAssertNil(lit.longValue)
        
        lit = Literal(stringValue: "Z3JlZW5sYW5k",dataType: XSD.base64Binary)!
        XCTAssertEqual("Z3JlZW5sYW5k", lit.stringValue)
        XCTAssertEqual("\"Z3JlZW5sYW5k\"^^xsd:base64Binary", lit.sparql)
        XCTAssertTrue(XSD.base64Binary == lit.dataType!)
        
        lit = Literal(sparqlString: "\"Z3JlZW5sYW5k\"^^xsd:base64Binary")!
        XCTAssertEqual("Z3JlZW5sYW5k", lit.stringValue)
        XCTAssertEqual("\"Z3JlZW5sYW5k\"^^xsd:base64Binary", lit.sparql)
        XCTAssertTrue(XSD.base64Binary == lit.dataType!)
    }
    
    func testAnyURILiterals() {
        do{
            let uristr = "http://donme:posdoe@example.org/path/to/resource#fragment?query=something"
            let uri = try URI(string: uristr)
            var lit = Literal(anyURIValue: uri)
            XCTAssertEqual("http://donme:posdoe@example.org/path/to/resource#fragment?query=something", lit.stringValue)
            XCTAssertEqual("\"http://donme:posdoe@example.org/path/to/resource#fragment?query=something\"^^xsd:anyURI", lit.sparql)
            XCTAssertTrue(XSD.anyURI == lit.dataType!)
            XCTAssertNil(lit.longValue)
            
            lit = Literal(stringValue: uristr, dataType: XSD.anyURI)!
            XCTAssertTrue(uri == lit.anyURIValue!)
            
            lit = Literal(sparqlString: "\"http://donme:posdoe@example.org/path/to/resource#fragment?query=something\"^^xsd:anyURI")!
            XCTAssertTrue(uri == lit.anyURIValue!)
        }catch {
            XCTFail("Error thrown when creating URI.")
        }
    }
}

