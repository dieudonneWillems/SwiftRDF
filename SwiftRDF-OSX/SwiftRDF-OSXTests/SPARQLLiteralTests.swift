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
        XCTAssertNil(lit3.language)
        XCTAssertNil(lit3.longValue)
        let lit4 = Literal(sparqlString: "\"test string\"@en^^xsd:string")!;
        XCTAssertEqual("test string", lit4.stringValue)
        XCTAssertTrue(XSD.string == lit4.dataType!)
        XCTAssertEqual("en",lit4.language)
        XCTAssertNil(lit4.longValue)
        let lit5 = Literal(sparqlString: "\"test string\"@en^^xsd:double")!;
        XCTAssertEqual("\"test string\"@en^^xsd:double", lit5.stringValue)
        XCTAssertNil(lit5.dataType)
        XCTAssertNil(lit5.language)
        XCTAssertNil(lit5.longValue)
        let lit6 = Literal(sparqlString: "\"test string\"@en-US")!;
        XCTAssertEqual("test string", lit6.stringValue)
        XCTAssertTrue(XSD.string == lit6.dataType!)
        XCTAssertEqual("en-US",lit6.language)
        XCTAssertNil(lit6.longValue)
    }
    
    func testSPARQLBooleanLiteral() {
        let lit1 = Literal(sparqlString: "\"true\"^^xsd:boolean")!;
        XCTAssertEqual("true", lit1.stringValue)
        XCTAssertTrue(XSD.boolean == lit1.dataType!)
        XCTAssertNil(lit1.language)
        XCTAssertNil(lit1.longValue)
        XCTAssertTrue(lit1.booleanValue!)
        let lit2 = Literal(sparqlString: "\"false\"^^xsd:boolean")!;
        XCTAssertEqual("false", lit2.stringValue)
        XCTAssertTrue(XSD.boolean == lit2.dataType!)
        XCTAssertNil(lit2.language)
        XCTAssertNil(lit2.longValue)
        XCTAssertFalse(lit2.booleanValue!)
        let lit3 = Literal(sparqlString: "true")!;
        XCTAssertEqual("true", lit3.stringValue)
        XCTAssertTrue(XSD.boolean == lit3.dataType!)
        XCTAssertNil(lit3.language)
        XCTAssertNil(lit3.longValue)
        XCTAssertTrue(lit3.booleanValue!)
        let lit4 = Literal(sparqlString: "false")!;
        XCTAssertEqual("false", lit4.stringValue)
        XCTAssertTrue(XSD.boolean == lit4.dataType!)
        XCTAssertNil(lit4.language)
        XCTAssertNil(lit4.longValue)
        XCTAssertFalse(lit4.booleanValue!)
    }
    
    func testSPARQLIntegerLiteral(){
        let lit1 = Literal(sparqlString: "\"1923322\"^^xsd:integer")!;
        XCTAssertEqual("1923322", lit1.stringValue)
        XCTAssertTrue(XSD.integer == lit1.dataType!)
        XCTAssertNil(lit1.language)
        XCTAssertTrue(1923322 == lit1.integerValue!)
        let lit2 = Literal(sparqlString: "\"-1923322\"^^xsd:integer")!;
        XCTAssertEqual("-1923322", lit2.stringValue)
        XCTAssertTrue(XSD.integer == lit2.dataType!)
        XCTAssertNil(lit2.language)
        XCTAssertTrue(-1923322 == lit2.integerValue!)
        let lit3 = Literal(sparqlString: "\"+1923322\"^^xsd:integer")!;
        XCTAssertEqual("+1923322", lit3.stringValue)
        XCTAssertTrue(XSD.integer == lit3.dataType!)
        XCTAssertNil(lit3.language)
        XCTAssertTrue(1923322 == lit3.integerValue!)
        let lit4 = Literal(sparqlString: "\"dfsdffewwqef\"^^xsd:integer");
        XCTAssertNil(lit4)
        let lit5 = Literal(sparqlString: "1923322")!;
        XCTAssertEqual("1923322", lit5.stringValue)
        XCTAssertTrue(XSD.integer == lit5.dataType!)
        XCTAssertNil(lit5.language)
        XCTAssertTrue(1923322 == lit5.integerValue!)
        let lit6 = Literal(sparqlString: "+1923322")!;
        XCTAssertEqual("+1923322", lit6.stringValue)
        XCTAssertTrue(XSD.integer == lit6.dataType!)
        XCTAssertNil(lit6.language)
        XCTAssertTrue(1923322 == lit6.integerValue!)
        let lit7 = Literal(sparqlString: "-1923322")!;
        XCTAssertEqual("-1923322", lit7.stringValue)
        XCTAssertTrue(XSD.integer == lit7.dataType!)
        XCTAssertNil(lit7.language)
        XCTAssertTrue(-1923322 == lit7.integerValue!)
    }
    
    func testSPARQLNonNegativeIntegerLiteral(){
        let lit1 = Literal(sparqlString: "\"1923322\"^^xsd:nonNegativeInteger")!
        XCTAssertEqual("1923322", lit1.stringValue)
        XCTAssertTrue(XSD.nonNegativeInteger == lit1.dataType!)
        XCTAssertNil(lit1.language)
        XCTAssertTrue(1923322 == lit1.nonNegativeIntegerValue!)
        let lit2 = Literal(sparqlString: "\"-1923322\"^^xsd:nonNegativeInteger")
        XCTAssertNil(lit2)
        let lit3 = Literal(sparqlString: "\"+1923322\"^^xsd:nonNegativeInteger")!
        XCTAssertEqual("+1923322", lit3.stringValue)
        XCTAssertTrue(XSD.nonNegativeInteger == lit3.dataType!)
        XCTAssertNil(lit3.language)
        XCTAssertTrue(1923322 == lit3.nonNegativeIntegerValue!)
        let lit4 = Literal(sparqlString: "\"dfsdffewwqef\"^^xsd:nonNegativeInteger")
        XCTAssertNil(lit4)
        let lit5 = Literal(sparqlString: "\"0\"^^xsd:nonNegativeInteger")!
        XCTAssertEqual("0", lit5.stringValue)
        XCTAssertTrue(XSD.nonNegativeInteger == lit5.dataType!)
        XCTAssertNil(lit5.language)
        XCTAssertTrue(0 == lit5.nonNegativeIntegerValue!)
    }
    
    func testSPARQLPositiveIntegerLiteral(){
        let lit1 = Literal(sparqlString: "\"1923322\"^^xsd:positiveInteger")!
        XCTAssertEqual("1923322", lit1.stringValue)
        XCTAssertTrue(XSD.positiveInteger == lit1.dataType!)
        XCTAssertNil(lit1.language)
        XCTAssertTrue(1923322 == lit1.positiveIntegerValue!)
        let lit2 = Literal(sparqlString: "\"-1923322\"^^xsd:positiveInteger")
        XCTAssertNil(lit2)
        let lit3 = Literal(sparqlString: "\"+1923322\"^^xsd:positiveInteger")!
        XCTAssertEqual("+1923322", lit3.stringValue)
        XCTAssertTrue(XSD.positiveInteger == lit3.dataType!)
        XCTAssertNil(lit3.language)
        XCTAssertTrue(1923322 == lit3.positiveIntegerValue!)
        let lit4 = Literal(sparqlString: "\"dfsdffewwqef\"^^xsd:positiveInteger")
        XCTAssertNil(lit4)
        let lit5 = Literal(sparqlString: "\"0\"^^xsd:positiveInteger")
        XCTAssertNil(lit5)
    }
    
    func testSPARQLNonPositiveIntegerLiteral(){
        let lit1 = Literal(sparqlString: "\"-1923322\"^^xsd:nonPositiveInteger")!
        XCTAssertEqual("-1923322", lit1.stringValue)
        XCTAssertTrue(XSD.nonPositiveInteger == lit1.dataType!)
        XCTAssertNil(lit1.language)
        XCTAssertTrue(1923322 == lit1.nonPositiveIntegerValue!)
        let lit2 = Literal(sparqlString: "\"1923322\"^^xsd:nonPositiveInteger")
        XCTAssertNil(lit2)
        let lit4 = Literal(sparqlString: "\"dfsdffewwqef\"^^xsd:nonPositiveInteger")
        XCTAssertNil(lit4)
        let lit5 = Literal(sparqlString: "\"0\"^^xsd:nonPositiveInteger")!
        XCTAssertEqual("0", lit5.stringValue)
        XCTAssertTrue(XSD.nonPositiveInteger == lit5.dataType!)
        XCTAssertNil(lit5.language)
        XCTAssertTrue(0 == lit5.nonPositiveIntegerValue!)
    }
    
    func testSPARQLNegativeIntegerLiteral(){
        let lit1 = Literal(sparqlString: "\"-1923322\"^^xsd:negativeInteger")!
        XCTAssertEqual("-1923322", lit1.stringValue)
        XCTAssertTrue(XSD.negativeInteger == lit1.dataType!)
        XCTAssertNil(lit1.language)
        XCTAssertTrue(1923322 == lit1.negativeIntegerValue!)
        let lit2 = Literal(sparqlString: "\"1923322\"^^xsd:negativeInteger")
        XCTAssertNil(lit2)
        let lit4 = Literal(sparqlString: "\"dfsdffewwqef\"^^xsd:negativeInteger")
        XCTAssertNil(lit4)
        let lit5 = Literal(sparqlString: "\"0\"^^xsd:negativeInteger")
        XCTAssertNil(lit5)
    }
    
    func testSPARQLLongLiteral(){
        let lit1 = Literal(sparqlString: "\"192332884302\"^^xsd:long")!;
        XCTAssertEqual("192332884302", lit1.stringValue)
        XCTAssertTrue(XSD.long == lit1.dataType!)
        XCTAssertNil(lit1.language)
        XCTAssertTrue(192332884302 == lit1.longValue!)
        let lit2 = Literal(sparqlString: "\"-192332884302\"^^xsd:long")!;
        XCTAssertEqual("-192332884302", lit2.stringValue)
        XCTAssertTrue(XSD.long == lit2.dataType!)
        XCTAssertNil(lit2.language)
        XCTAssertTrue(-192332884302 == lit2.longValue!)
        let lit3 = Literal(sparqlString: "\"+192332884302\"^^xsd:long")!;
        XCTAssertEqual("+192332884302", lit3.stringValue)
        XCTAssertTrue(XSD.long == lit3.dataType!)
        XCTAssertNil(lit3.language)
        XCTAssertTrue(192332884302 == lit3.longValue!)
        let lit4 = Literal(sparqlString: "\"dfsdffewwqef\"^^xsd:long");
        XCTAssertNil(lit4)
    }
    
    func testSPARQLUnsignedLongLiteral(){
        let lit1 = Literal(sparqlString: "\"192332884302\"^^xsd:unsignedLong")!;
        XCTAssertEqual("192332884302", lit1.stringValue)
        XCTAssertTrue(XSD.unsignedLong == lit1.dataType!)
        XCTAssertNil(lit1.language)
        XCTAssertTrue(192332884302 == lit1.longValue!)
        let lit2 = Literal(sparqlString: "\"-192332884302\"^^xsd:unsignedLong");
        XCTAssertNil(lit2)
        let lit3 = Literal(sparqlString: "\"+192332884302\"^^xsd:unsignedLong")!;
        XCTAssertEqual("+192332884302", lit3.stringValue)
        XCTAssertTrue(XSD.unsignedLong == lit3.dataType!)
        XCTAssertNil(lit3.language)
        XCTAssertTrue(192332884302 == lit3.longValue!)
        let lit4 = Literal(sparqlString: "\"dfsdffewwqef\"^^xsd:unsignedLong");
        XCTAssertNil(lit4)
    }
    
    func testSPARQLIntLiteral(){
        let lit0 = Literal(sparqlString: "\"192332884302\"^^xsd:int");
        XCTAssertNil(lit0)
        let lit1 = Literal(sparqlString: "\"1923328843\"^^xsd:int")!;
        XCTAssertEqual("1923328843", lit1.stringValue)
        XCTAssertTrue(XSD.int == lit1.dataType!)
        XCTAssertNil(lit1.language)
        XCTAssertTrue(1923328843 == lit1.intValue!)
        let lit2 = Literal(sparqlString: "\"-1923328843\"^^xsd:int")!;
        XCTAssertEqual("-1923328843", lit2.stringValue)
        XCTAssertTrue(XSD.int == lit2.dataType!)
        XCTAssertNil(lit2.language)
        XCTAssertTrue(-1923328843 == lit2.intValue!)
        let lit3 = Literal(sparqlString: "\"+1923328843\"^^xsd:int")!;
        XCTAssertEqual("+1923328843", lit3.stringValue)
        XCTAssertTrue(XSD.int == lit3.dataType!)
        XCTAssertNil(lit3.language)
        XCTAssertTrue(1923328843 == lit3.intValue!)
        let lit4 = Literal(sparqlString: "\"dfsdffewwqef\"^^xsd:int");
        XCTAssertNil(lit4)
    }
    
    func testSPARQLUnsignedIntLiteral(){
        let lit0 = Literal(sparqlString: "\"192332884302\"^^xsd:unsignedInt");
        XCTAssertNil(lit0)
        let lit1 = Literal(sparqlString: "\"1923328843\"^^xsd:unsignedInt")!;
        XCTAssertEqual("1923328843", lit1.stringValue)
        XCTAssertTrue(XSD.unsignedInt == lit1.dataType!)
        XCTAssertNil(lit1.language)
        XCTAssertTrue(1923328843 == lit1.unsignedIntValue!)
        let lit2 = Literal(sparqlString: "\"-1923328843\"^^xsd:unsignedInt");
        XCTAssertNil(lit2)
        let lit3 = Literal(sparqlString: "\"+1923328843\"^^xsd:unsignedInt")!;
        XCTAssertEqual("+1923328843", lit3.stringValue)
        XCTAssertTrue(XSD.unsignedInt == lit3.dataType!)
        XCTAssertNil(lit3.language)
        XCTAssertTrue(1923328843 == lit3.unsignedIntValue!)
        let lit4 = Literal(sparqlString: "\"dfsdffewwqef\"^^xsd:unsignedInt");
        XCTAssertNil(lit4)
    }
    
    func testSPARQLShortLiteral(){
        let lit0 = Literal(sparqlString: "\"192332884302\"^^xsd:short");
        XCTAssertNil(lit0)
        let lit1 = Literal(sparqlString: "\"19233\"^^xsd:short")!;
        XCTAssertEqual("19233", lit1.stringValue)
        XCTAssertTrue(XSD.short == lit1.dataType!)
        XCTAssertNil(lit1.language)
        XCTAssertTrue(19233 == lit1.shortValue!)
        let lit2 = Literal(sparqlString: "\"-19233\"^^xsd:short")!;
        XCTAssertEqual("-19233", lit2.stringValue)
        XCTAssertTrue(XSD.short == lit2.dataType!)
        XCTAssertNil(lit2.language)
        XCTAssertTrue(-19233 == lit2.shortValue!)
        let lit3 = Literal(sparqlString: "\"+19233\"^^xsd:short")!;
        XCTAssertEqual("+19233", lit3.stringValue)
        XCTAssertTrue(XSD.short == lit3.dataType!)
        XCTAssertNil(lit3.language)
        XCTAssertTrue(19233 == lit3.shortValue!)
        let lit4 = Literal(sparqlString: "\"dfsdffewwqef\"^^xsd:short");
        XCTAssertNil(lit4)
    }
    
    func testSPARQLUnsignedShortLiteral(){
        let lit0 = Literal(sparqlString: "\"192332884302\"^^xsd:unsignedShort");
        XCTAssertNil(lit0)
        let lit1 = Literal(sparqlString: "\"19233\"^^xsd:unsignedShort")!;
        XCTAssertEqual("19233", lit1.stringValue)
        XCTAssertTrue(XSD.unsignedShort == lit1.dataType!)
        XCTAssertNil(lit1.language)
        XCTAssertTrue(19233 == lit1.unsignedShortValue!)
        let lit2 = Literal(sparqlString: "\"-19233\"^^xsd:unsignedShort");
        XCTAssertNil(lit2)
        let lit3 = Literal(sparqlString: "\"+19233\"^^xsd:unsignedShort")!;
        XCTAssertEqual("+19233", lit3.stringValue)
        XCTAssertTrue(XSD.unsignedShort == lit3.dataType!)
        XCTAssertNil(lit3.language)
        XCTAssertTrue(19233 == lit3.unsignedShortValue!)
        let lit4 = Literal(sparqlString: "\"dfsdffewwqef\"^^xsd:unsignedShort");
        XCTAssertNil(lit4)
    }
    
    func testSPARQLByteLiteral(){
        let lit0 = Literal(sparqlString: "\"192332884302\"^^xsd:byte");
        XCTAssertNil(lit0)
        let lit1 = Literal(sparqlString: "\"123\"^^xsd:byte")!;
        XCTAssertEqual("123", lit1.stringValue)
        XCTAssertTrue(XSD.byte == lit1.dataType!)
        XCTAssertNil(lit1.language)
        XCTAssertTrue(123 == lit1.byteValue!)
        let lit2 = Literal(sparqlString: "\"-123\"^^xsd:byte")!;
        XCTAssertEqual("-123", lit2.stringValue)
        XCTAssertTrue(XSD.byte == lit2.dataType!)
        XCTAssertNil(lit2.language)
        XCTAssertTrue(-123 == lit2.byteValue!)
        let lit3 = Literal(sparqlString: "\"+123\"^^xsd:byte")!;
        XCTAssertEqual("+123", lit3.stringValue)
        XCTAssertTrue(XSD.byte == lit3.dataType!)
        XCTAssertNil(lit3.language)
        XCTAssertTrue(123 == lit3.byteValue!)
        let lit4 = Literal(sparqlString: "\"dfsdffewwqef\"^^xsd:byte");
        XCTAssertNil(lit4)
    }
    
    func testSPARQLUnsignedByteLiteral(){
        let lit0 = Literal(sparqlString: "\"192332884302\"^^xsd:unsignedByte");
        XCTAssertNil(lit0)
        let lit1 = Literal(sparqlString: "\"232\"^^xsd:unsignedByte")!;
        XCTAssertEqual("232", lit1.stringValue)
        XCTAssertTrue(XSD.unsignedByte == lit1.dataType!)
        XCTAssertNil(lit1.language)
        XCTAssertTrue(232 == lit1.unsignedByteValue!)
        let lit2 = Literal(sparqlString: "\"-232\"^^xsd:unsignedByte");
        XCTAssertNil(lit2)
        let lit3 = Literal(sparqlString: "\"+232\"^^xsd:unsignedByte")!;
        XCTAssertEqual("+232", lit3.stringValue)
        XCTAssertTrue(XSD.unsignedByte == lit3.dataType!)
        XCTAssertNil(lit3.language)
        XCTAssertTrue(232 == lit3.unsignedByteValue!)
        let lit4 = Literal(sparqlString: "\"dfsdffewwqef\"^^xsd:unsignedByte");
        XCTAssertNil(lit4)
    }
    
    func testSPARQLDoubleLiteral(){
        let lit1 = Literal(sparqlString: "\"2234452\"^^xsd:double")!;
        XCTAssertEqual("2234452", lit1.stringValue)
        XCTAssertTrue(XSD.double == lit1.dataType!)
        XCTAssertNil(lit1.language)
        XCTAssertTrue(2234452 == lit1.doubleValue!)
        let lit2 = Literal(sparqlString: "\"-2234452\"^^xsd:double")!;
        XCTAssertEqual("-2234452", lit2.stringValue)
        XCTAssertTrue(XSD.double == lit2.dataType!)
        XCTAssertNil(lit2.language)
        XCTAssertTrue(-2234452 == lit2.doubleValue!)
        let lit3 = Literal(sparqlString: "\"2234.452\"^^xsd:double")!;
        XCTAssertEqual("2234.452", lit3.stringValue)
        XCTAssertTrue(XSD.double == lit3.dataType!)
        XCTAssertNil(lit3.language)
        XCTAssertTrue(2234.452 == lit3.doubleValue!)
        let lit4 = Literal(sparqlString: "\"-2234.452\"^^xsd:double")!;
        XCTAssertEqual("-2234.452", lit4.stringValue)
        XCTAssertTrue(XSD.double == lit4.dataType!)
        XCTAssertNil(lit4.language)
        XCTAssertTrue(-2234.452 == lit4.doubleValue!)
        let lit5 = Literal(sparqlString: "\"2.3244e92\"^^xsd:double")!;
        XCTAssertEqual("2.3244e92", lit5.stringValue)
        XCTAssertTrue(XSD.double == lit5.dataType!)
        XCTAssertNil(lit5.language)
        XCTAssertTrue(2.3244e92 == lit5.doubleValue!)
        let lit6 = Literal(sparqlString: "\"-22.325E-21\"^^xsd:double")!;
        XCTAssertEqual("-22.325E-21", lit6.stringValue)
        XCTAssertTrue(XSD.double == lit6.dataType!)
        XCTAssertNil(lit6.language)
        XCTAssertTrue(-22.325E-21 == lit6.doubleValue!)
        XCTAssertTrue(-2.2325E-20 == lit6.doubleValue!)
        let lit7 = Literal(sparqlString: "3.12e-5")!;
        XCTAssertEqual("3.12e-5", lit7.stringValue)
        XCTAssertTrue(XSD.double == lit7.dataType!)
        XCTAssertNil(lit7.language)
        XCTAssertTrue(3.12e-5 == lit7.doubleValue!)
        let lit8 = Literal(sparqlString: "-0.012e4")!;
        XCTAssertEqual("-0.012e4", lit8.stringValue)
        XCTAssertTrue(XSD.double == lit8.dataType!)
        XCTAssertNil(lit8.language)
        XCTAssertTrue(-0.012e4 == lit8.doubleValue!)
        XCTAssertTrue(-12e1 == lit8.doubleValue!)
        XCTAssertTrue(-120 == lit8.doubleValue!)
    }
    
    func testSPARQLFloatLiteral(){
        let lit1 = Literal(sparqlString: "\"2234452\"^^xsd:float")!;
        XCTAssertEqual("2234452", lit1.stringValue)
        XCTAssertTrue(XSD.float == lit1.dataType!)
        XCTAssertNil(lit1.language)
        XCTAssertTrue(2234452 == lit1.floatValue!)
        let lit2 = Literal(sparqlString: "\"-2234452\"^^xsd:float")!;
        XCTAssertEqual("-2234452", lit2.stringValue)
        XCTAssertTrue(XSD.float == lit2.dataType!)
        XCTAssertNil(lit2.language)
        XCTAssertTrue(-2234452 == lit2.floatValue!)
        let lit3 = Literal(sparqlString: "\"2234.452\"^^xsd:float")!;
        XCTAssertEqual("2234.452", lit3.stringValue)
        XCTAssertTrue(XSD.float == lit3.dataType!)
        XCTAssertNil(lit3.language)
        XCTAssertTrue(2234.452 == lit3.floatValue!)
        let lit4 = Literal(sparqlString: "\"-2234.452\"^^xsd:float")!;
        XCTAssertEqual("-2234.452", lit4.stringValue)
        XCTAssertTrue(XSD.float == lit4.dataType!)
        XCTAssertNil(lit4.language)
        XCTAssertTrue(-2234.452 == lit4.floatValue!)
        let lit5 = Literal(sparqlString: "\"2.3244e12\"^^xsd:float")!;
        XCTAssertEqual("2.3244e12", lit5.stringValue)
        XCTAssertTrue(XSD.float == lit5.dataType!)
        XCTAssertNil(lit5.language)
        XCTAssertTrue(2.3244e12 == lit5.floatValue!)
        let lit6 = Literal(sparqlString: "\"-22.325E-21\"^^xsd:float")!;
        XCTAssertEqual("-22.325E-21", lit6.stringValue)
        XCTAssertTrue(XSD.float == lit6.dataType!)
        XCTAssertNil(lit6.language)
        XCTAssertTrue(-22.325E-21 == lit6.floatValue!)
        XCTAssertTrue(-2.2325E-20 == lit6.floatValue!)
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


