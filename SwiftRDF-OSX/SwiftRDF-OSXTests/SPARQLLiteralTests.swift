//
//  SPARQLLiteralTests.swift
//  SwiftRDF-OSX
//
//  Created by Don Willems on 07/12/15.
//  Copyright © 2015 lapsedpacifist. All rights reserved.
//

import Foundation

import XCTest
@testable import SwiftRDFOSX

class SPARQLLiteralTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testSPARQLStringLiteral() {
        let lit0 = Literal(sparqlString: "test string")!;
        XCTAssertEqual("test string", lit0.stringValue)
        XCTAssertNil(lit0.dataType)
        XCTAssertNil(lit0.language)
        XCTAssertNil(lit0.longValue)
        let lit1 = Literal(sparqlString: "\"test string\"")!;
        XCTAssertEqual("test string", lit1.stringValue)
        XCTAssertTrue(XSD.string == lit1.dataType!)
        XCTAssertNil(lit1.language)
        XCTAssertNil(lit1.longValue)
        let lit2 = Literal(sparqlString: "\"test string\"@en")!;
        XCTAssertEqual("test string", lit2.stringValue)
        XCTAssertTrue(XSD.string == lit2.dataType!)
        XCTAssertEqual("en",lit2.language)
        XCTAssertNil(lit2.longValue)
        let lit3 = Literal(sparqlString: "\"test string\"^^xsd:string")!;
        XCTAssertEqual("test string", lit3.stringValue)
        XCTAssertTrue(XSD.string == lit3.dataType!)
        XCTAssertNil(lit1.language)
        XCTAssertNil(lit3.longValue)
        let lit4 = Literal(sparqlString: "\"test string\"@en^^xsd:string")!;
        XCTAssertEqual("test string", lit4.stringValue)
        XCTAssertTrue(XSD.string == lit4.dataType!)
        XCTAssertEqual("en",lit4.language)
        XCTAssertNil(lit4.longValue)
        let lit5 = Literal(sparqlString: "\"test string\"@en^^xsd:double")!;
        XCTAssertEqual("\"test string\"@en^^xsd:double", lit5.stringValue)
        XCTAssertNil(lit5.dataType)
        XCTAssertNil(lit5.dataType)
        XCTAssertNil(lit5.longValue)
    }
    
    func testSPARQLStringLiteralWithCustomDatatype(){
        do{
            let lit0 = Literal(sparqlString: "\"test string\"^^<http://www.example.org/datatypes/custom>")!;
            XCTAssertEqual("test string", lit0.stringValue)
            let custom = try Datatype(namespace:"http://www.example.org/datatypes/", localName: "custom", derivedFromDatatype: nil, isListDataType: false)
            XCTAssertTrue(custom == lit0.dataType!)
            XCTAssertNil(lit0.language)
            XCTAssertNil(lit0.longValue)
        }catch{
            XCTFail("Failed when testing custom datatype.")
        }
    }

}


