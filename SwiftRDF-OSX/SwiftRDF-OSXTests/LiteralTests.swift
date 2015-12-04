//
//  LiteralTests.swift
//  SwiftRDF-OSX
//
//  Created by Don Willems on 04/12/15.
//  Copyright © 2015 lapsedpacifist. All rights reserved.
//

import Foundation

import XCTest
@testable import SwiftRDFOSX

class LiteralTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    
    func testStringLiteral() {
        let lit1 = Literal(stringValue: "Hello World")
        XCTAssertEqual("Hello World", lit1.stringValue)
        XCTAssertEqual("\"Hello World\"", lit1.sparql)
        XCTAssertNil(lit1.dataType)
        XCTAssertNil(lit1.language)
        XCTAssertNil(lit1.longValue)
        let lit2 = Literal(stringValue: "Hello World", language: "en")
        XCTAssertEqual("Hello World", lit2.stringValue)
        XCTAssertEqual("\"Hello World\"@en", lit2.sparql)
        XCTAssertEqual("en", lit2.language)
        XCTAssertTrue(XSD.string == lit2.dataType!)
        XCTAssertNil(lit2.longValue)
    }
    
    func testDoubleLiteral() {
        let lit1 = Literal(doubleValue: 2.343223E-2)
        XCTAssertTrue(2.343223E-2 == lit1.doubleValue)
        XCTAssertEqual("2.343223E-2", lit1.sparql)
        XCTAssertTrue(XSD.double == lit1.dataType!)
        XCTAssertNil(lit1.longValue)
        let lit2 = Literal(doubleValue: 2.343223E+2)
        XCTAssertTrue(2.343223E+2 == lit2.doubleValue)
        XCTAssertEqual("2.343223E+2", lit2.sparql)
        XCTAssertTrue(XSD.double == lit2.dataType!)
        XCTAssertNil(lit2.longValue)
    }
    
    func testDoubleLiteralFromString() {
        do {
            let lit1 = try Literal(stringValue: "2.343223E-2", dataType: XSD.double)
            XCTAssertTrue(2.343223E-2 == lit1.doubleValue)
            XCTAssertEqual("2.343223E-2", lit1.sparql)
            XCTAssertTrue(XSD.double == lit1.dataType!)
            XCTAssertNil(lit1.longValue)
            let lit2 = try Literal(stringValue: "2.343223E+2", dataType: XSD.double)
            XCTAssertTrue(2.343223E+2 == lit2.doubleValue)
            XCTAssertEqual("2.343223E+2", lit2.sparql)
            XCTAssertTrue(XSD.double == lit2.dataType!)
            XCTAssertNil(lit2.longValue)
        } catch {
            XCTFail("Error when converting string to double.")
        }
    }
    
    func testIntegerLiteral() {
        let lit1 = Literal(integerValue: 23255)
        XCTAssertTrue(23255 == lit1.intValue)
        XCTAssertTrue(23255 == lit1.integerValue)
        XCTAssertTrue(23255 == lit1.unsignedIntValue)
        XCTAssertTrue(23255 == lit1.longValue)
        XCTAssertTrue(23255 == lit1.unsignedLongValue)
        XCTAssertTrue(23255 == lit1.shortValue)
        XCTAssertTrue(23255 == lit1.unsignedShortValue)
        XCTAssertEqual("23255", lit1.sparql)
        XCTAssertTrue(XSD.integer == lit1.dataType!)
        XCTAssertNil(lit1.byteValue)
        XCTAssertNil(lit1.unsignedByteValue)
        XCTAssertNil(lit1.doubleValue)
        let lit2 = Literal(integerValue: -8723)
        XCTAssertTrue(-8723 == lit2.intValue)
        XCTAssertTrue(-8723 == lit2.integerValue)
        XCTAssertTrue(-8723 == lit2.longValue)
        XCTAssertTrue(-8723 == lit2.shortValue)
        XCTAssertEqual("-8723", lit2.sparql)
        XCTAssertTrue(XSD.integer == lit2.dataType!)
        XCTAssertNil(lit2.unsignedIntValue)
        XCTAssertNil(lit2.unsignedLongValue)
        XCTAssertNil(lit2.unsignedShortValue)
        XCTAssertNil(lit1.unsignedByteValue)
        XCTAssertNil(lit2.byteValue)
        XCTAssertNil(lit2.doubleValue)
        let lit3 = Literal(integerValue: -8)
        XCTAssertTrue(-8 == lit3.intValue)
        XCTAssertTrue(-8 == lit3.integerValue)
        XCTAssertTrue(-8 == lit3.longValue)
        XCTAssertTrue(-8 == lit3.shortValue)
        XCTAssertEqual("-8", lit3.sparql)
        XCTAssertTrue(XSD.integer == lit3.dataType!)
        XCTAssertNil(lit2.unsignedIntValue)
        XCTAssertNil(lit2.unsignedLongValue)
        XCTAssertNil(lit2.unsignedShortValue)
        XCTAssertNil(lit1.unsignedByteValue)
        XCTAssertNil(lit3.doubleValue)
    }
    
    func testIntegerLiteralFromString() {
        do{
            let lit1 = try Literal(stringValue: "23255", dataType: XSD.integer)
            XCTAssertTrue(23255 == lit1.intValue)
            XCTAssertTrue(23255 == lit1.integerValue)
            XCTAssertTrue(23255 == lit1.unsignedIntValue)
            XCTAssertTrue(23255 == lit1.longValue)
            XCTAssertTrue(23255 == lit1.unsignedLongValue)
            XCTAssertTrue(23255 == lit1.shortValue)
            XCTAssertTrue(23255 == lit1.unsignedShortValue)
            XCTAssertEqual("23255", lit1.sparql)
            XCTAssertTrue(XSD.integer == lit1.dataType!)
            XCTAssertNil(lit1.byteValue)
            XCTAssertNil(lit1.unsignedByteValue)
            XCTAssertNil(lit1.doubleValue)
            let lit2 = try Literal(stringValue: "-8723", dataType: XSD.integer)
            XCTAssertTrue(-8723 == lit2.intValue)
            XCTAssertTrue(-8723 == lit2.integerValue)
            XCTAssertTrue(-8723 == lit2.longValue)
            XCTAssertTrue(-8723 == lit2.shortValue)
            XCTAssertEqual("-8723", lit2.sparql)
            XCTAssertTrue(XSD.integer == lit2.dataType!)
            XCTAssertNil(lit2.unsignedIntValue)
            XCTAssertNil(lit2.unsignedLongValue)
            XCTAssertNil(lit2.unsignedShortValue)
            XCTAssertNil(lit1.unsignedByteValue)
            XCTAssertNil(lit2.byteValue)
            XCTAssertNil(lit2.doubleValue)
            let lit3 = try Literal(stringValue: "-8", dataType: XSD.integer)
            XCTAssertTrue(-8 == lit3.intValue)
            XCTAssertTrue(-8 == lit3.integerValue)
            XCTAssertTrue(-8 == lit3.longValue)
            XCTAssertTrue(-8 == lit3.shortValue)
            XCTAssertEqual("-8", lit3.sparql)
            XCTAssertTrue(XSD.integer == lit3.dataType!)
            XCTAssertNil(lit2.unsignedIntValue)
            XCTAssertNil(lit2.unsignedLongValue)
            XCTAssertNil(lit2.unsignedShortValue)
            XCTAssertNil(lit1.unsignedByteValue)
            XCTAssertNil(lit3.doubleValue)
            do {
                let shouldfail = try Literal(stringValue: "928832772734329489869893849859823948923848239842354", dataType: XSD.integer)
                XCTFail("Value of integer should be illegal, but is: \(shouldfail)")
            } catch {
                XCTAssertTrue(true)
            }
            do {
                let shouldfail = try Literal(stringValue: "-928832772734329489869893849859823948923848239842354", dataType: XSD.integer)
                XCTFail("Value of integer should be illegal, but is: \(shouldfail)")
            } catch {
                XCTAssertTrue(true)
            }
            do {
                let shouldfail = try Literal(stringValue: "3.1415928", dataType: XSD.integer)
                XCTFail("Value of integer should be illegal, but is: \(shouldfail)")
            } catch {
                XCTAssertTrue(true)
            }
            do {
                let shouldfail = try Literal(stringValue: "3E3", dataType: XSD.integer)
                XCTFail("Value of integer should be illegal, but is: \(shouldfail)")
            } catch {
                XCTAssertTrue(true)
            }
            do {
                let shouldfail = try Literal(stringValue: "bla", dataType: XSD.integer)
                XCTFail("Value of integer should be illegal, but is: \(shouldfail)")
            } catch {
                XCTAssertTrue(true)
            }
        } catch {
            XCTFail("Error when converting string to integer.")
        }
    }
    
    func testLongLiteral() {
        let lit1 = Literal(longValue: 23255)
        XCTAssertTrue(23255 == lit1.intValue)
        XCTAssertTrue(23255 == lit1.integerValue)
        XCTAssertTrue(23255 == lit1.unsignedIntValue)
        XCTAssertTrue(23255 == lit1.longValue)
        XCTAssertTrue(23255 == lit1.unsignedLongValue)
        XCTAssertTrue(23255 == lit1.shortValue)
        XCTAssertTrue(23255 == lit1.unsignedShortValue)
        XCTAssertEqual("\"23255\"^^xsd:long", lit1.sparql)
        XCTAssertTrue(XSD.long == lit1.dataType!)
        XCTAssertNil(lit1.byteValue)
        XCTAssertNil(lit1.unsignedByteValue)
        XCTAssertNil(lit1.doubleValue)
        let lit2 = Literal(longValue: -8723)
        XCTAssertTrue(-8723 == lit2.intValue)
        XCTAssertTrue(-8723 == lit2.integerValue)
        XCTAssertTrue(-8723 == lit2.longValue)
        XCTAssertTrue(-8723 == lit2.shortValue)
        XCTAssertEqual("\"-8723\"^^xsd:long", lit2.sparql)
        XCTAssertTrue(XSD.long == lit2.dataType!)
        XCTAssertNil(lit2.unsignedIntValue)
        XCTAssertNil(lit2.unsignedLongValue)
        XCTAssertNil(lit2.unsignedShortValue)
        XCTAssertNil(lit2.unsignedByteValue)
        XCTAssertNil(lit2.byteValue)
        XCTAssertNil(lit2.doubleValue)
        let lit3 = Literal(longValue: -8)
        XCTAssertTrue(-8 == lit3.intValue)
        XCTAssertTrue(-8 == lit3.integerValue)
        XCTAssertTrue(-8 == lit3.longValue)
        XCTAssertTrue(-8 == lit3.shortValue)
        XCTAssertEqual("\"-8\"^^xsd:long", lit3.sparql)
        XCTAssertTrue(XSD.long == lit3.dataType!)
        XCTAssertNil(lit3.unsignedIntValue)
        XCTAssertNil(lit3.unsignedLongValue)
        XCTAssertNil(lit3.unsignedShortValue)
        XCTAssertNil(lit3.unsignedByteValue)
        XCTAssertNil(lit3.doubleValue)
    }
    
    func testIntLiteral() {
        let lit1 = Literal(intValue: 23255)
        XCTAssertTrue(23255 == lit1.intValue)
        XCTAssertTrue(23255 == lit1.integerValue)
        XCTAssertTrue(23255 == lit1.unsignedIntValue)
        XCTAssertTrue(23255 == lit1.longValue)
        XCTAssertTrue(23255 == lit1.unsignedLongValue)
        XCTAssertTrue(23255 == lit1.shortValue)
        XCTAssertTrue(23255 == lit1.unsignedShortValue)
        XCTAssertEqual("\"23255\"^^xsd:int", lit1.sparql)
        XCTAssertTrue(XSD.int == lit1.dataType!)
        XCTAssertNil(lit1.byteValue)
        XCTAssertNil(lit1.unsignedByteValue)
        XCTAssertNil(lit1.doubleValue)
        let lit2 = Literal(intValue: -8723)
        XCTAssertTrue(-8723 == lit2.intValue)
        XCTAssertTrue(-8723 == lit2.integerValue)
        XCTAssertTrue(-8723 == lit2.longValue)
        XCTAssertTrue(-8723 == lit2.shortValue)
        XCTAssertEqual("\"-8723\"^^xsd:int", lit2.sparql)
        XCTAssertTrue(XSD.int == lit2.dataType!)
        XCTAssertNil(lit2.unsignedIntValue)
        XCTAssertNil(lit2.unsignedLongValue)
        XCTAssertNil(lit2.unsignedShortValue)
        XCTAssertNil(lit2.unsignedByteValue)
        XCTAssertNil(lit2.byteValue)
        XCTAssertNil(lit2.doubleValue)
        let lit3 = Literal(intValue: -8)
        XCTAssertTrue(-8 == lit3.intValue)
        XCTAssertTrue(-8 == lit3.integerValue)
        XCTAssertTrue(-8 == lit3.longValue)
        XCTAssertTrue(-8 == lit3.shortValue)
        XCTAssertEqual("\"-8\"^^xsd:int", lit3.sparql)
        XCTAssertTrue(XSD.int == lit3.dataType!)
        XCTAssertNil(lit3.unsignedIntValue)
        XCTAssertNil(lit3.unsignedLongValue)
        XCTAssertNil(lit3.unsignedShortValue)
        XCTAssertNil(lit3.unsignedByteValue)
        XCTAssertNil(lit3.doubleValue)
    }
    
    func testShortLiteral() {
        let lit1 = Literal(shortValue: 23255)
        XCTAssertTrue(23255 == lit1.intValue)
        XCTAssertTrue(23255 == lit1.integerValue)
        XCTAssertTrue(23255 == lit1.unsignedIntValue)
        XCTAssertTrue(23255 == lit1.longValue)
        XCTAssertTrue(23255 == lit1.unsignedLongValue)
        XCTAssertTrue(23255 == lit1.shortValue)
        XCTAssertTrue(23255 == lit1.unsignedShortValue)
        XCTAssertEqual("\"23255\"^^xsd:short", lit1.sparql)
        XCTAssertTrue(XSD.short == lit1.dataType!)
        XCTAssertNil(lit1.byteValue)
        XCTAssertNil(lit1.unsignedByteValue)
        XCTAssertNil(lit1.doubleValue)
        let lit2 = Literal(shortValue: -8723)
        XCTAssertTrue(-8723 == lit2.intValue)
        XCTAssertTrue(-8723 == lit2.integerValue)
        XCTAssertTrue(-8723 == lit2.longValue)
        XCTAssertTrue(-8723 == lit2.shortValue)
        XCTAssertEqual("\"-8723\"^^xsd:short", lit2.sparql)
        XCTAssertTrue(XSD.short == lit2.dataType!)
        XCTAssertNil(lit2.unsignedIntValue)
        XCTAssertNil(lit2.unsignedLongValue)
        XCTAssertNil(lit2.unsignedShortValue)
        XCTAssertNil(lit2.unsignedByteValue)
        XCTAssertNil(lit2.byteValue)
        XCTAssertNil(lit2.doubleValue)
        let lit3 = Literal(shortValue: -8)
        XCTAssertTrue(-8 == lit3.intValue)
        XCTAssertTrue(-8 == lit3.integerValue)
        XCTAssertTrue(-8 == lit3.longValue)
        XCTAssertTrue(-8 == lit3.shortValue)
        XCTAssertEqual("\"-8\"^^xsd:short", lit3.sparql)
        XCTAssertTrue(XSD.short == lit3.dataType!)
        XCTAssertNil(lit3.unsignedIntValue)
        XCTAssertNil(lit3.unsignedLongValue)
        XCTAssertNil(lit3.unsignedShortValue)
        XCTAssertNil(lit3.unsignedByteValue)
        XCTAssertNil(lit3.doubleValue)
    }
    
    func testByteLiteral() {
        let lit3 = Literal(byteValue: -8)
        XCTAssertTrue(-8 == lit3.intValue)
        XCTAssertTrue(-8 == lit3.integerValue)
        XCTAssertTrue(-8 == lit3.longValue)
        XCTAssertTrue(-8 == lit3.shortValue)
        XCTAssertEqual("\"-8\"^^xsd:byte", lit3.sparql)
        XCTAssertTrue(XSD.byte == lit3.dataType!)
        XCTAssertNil(lit3.unsignedIntValue)
        XCTAssertNil(lit3.unsignedLongValue)
        XCTAssertNil(lit3.unsignedShortValue)
        XCTAssertNil(lit3.unsignedByteValue)
        XCTAssertNil(lit3.doubleValue)
    }
}
