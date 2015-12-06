//
//  NumericalLiteralTests.swift
//  SwiftRDF-OSX
//
//  Created by Don Willems on 04/12/15.
//  Copyright © 2015 lapsedpacifist. All rights reserved.
//

import Foundation

import XCTest
@testable import SwiftRDFOSX

class NumericLiteralTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
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
    
    func testDecimalLiteral() {
        let lit1 = Literal(decimalValue: Decimal(decimalInteger: 98328,decimalExponent: 0)!)
        XCTAssertTrue(98328 == lit1.intValue)
        XCTAssertTrue(98328 == lit1.integerValue)
        XCTAssertTrue(98328 == lit1.unsignedIntValue)
        XCTAssertTrue(98328 == lit1.longValue)
        XCTAssertTrue(98328 == lit1.unsignedLongValue)
        XCTAssertNil(lit1.shortValue)
        XCTAssertNil(lit1.unsignedShortValue)
        XCTAssertEqual("\"98328\"^^xsd:decimal", lit1.sparql)
        XCTAssertTrue(XSD.decimal == lit1.dataType!)
        XCTAssertNil(lit1.byteValue)
        XCTAssertNil(lit1.unsignedByteValue)
        XCTAssertTrue( 98328 == lit1.doubleValue)
        let lit2 = Literal(decimalValue: Decimal(decimalInteger: -98328,decimalExponent: 0)!)
        XCTAssertTrue(-98328 == lit2.intValue)
        XCTAssertTrue(-98328 == lit2.integerValue)
        XCTAssertTrue(-98328 == lit2.longValue)
        XCTAssertNil(lit2.shortValue)
        XCTAssertEqual("\"-98328\"^^xsd:decimal", lit2.sparql)
        XCTAssertTrue(XSD.decimal == lit2.dataType!)
        XCTAssertNil(lit2.unsignedIntValue)
        XCTAssertNil(lit2.unsignedLongValue)
        XCTAssertNil(lit2.unsignedShortValue)
        XCTAssertNil(lit2.unsignedByteValue)
        XCTAssertNil(lit2.byteValue)
        XCTAssertTrue( -98328 == lit2.doubleValue)
        let lit3 = Literal(decimalValue: Decimal(decimalInteger: -98328,decimalExponent: 2)!)
        XCTAssertNil(lit3.intValue)
        XCTAssertNil(lit3.integerValue)
        XCTAssertNil(lit3.longValue)
        XCTAssertNil(lit3.shortValue)
        XCTAssertEqual("\"-983.28\"^^xsd:decimal", lit3.sparql)
        XCTAssertTrue(XSD.decimal == lit2.dataType!)
        XCTAssertNil(lit3.unsignedIntValue)
        XCTAssertNil(lit3.unsignedLongValue)
        XCTAssertNil(lit3.unsignedShortValue)
        XCTAssertNil(lit3.unsignedByteValue)
        XCTAssertNil(lit3.byteValue)
        XCTAssertTrue( -983.28 == lit3.doubleValue)
    }
    
    func testDecimalLiteralFromString() {
        do{
            let lit1 = try Literal(stringValue: "23255", dataType: XSD.decimal)
            XCTAssertTrue(23255 == lit1.intValue)
            XCTAssertTrue(23255 == lit1.integerValue)
            XCTAssertTrue(23255 == lit1.unsignedIntValue)
            XCTAssertTrue(23255 == lit1.longValue)
            XCTAssertTrue(23255 == lit1.unsignedLongValue)
            XCTAssertTrue(23255 == lit1.shortValue)
            XCTAssertTrue(23255 == lit1.unsignedShortValue)
            XCTAssertEqual("\"23255\"^^xsd:decimal", lit1.sparql)
            XCTAssertTrue(XSD.decimal == lit1.dataType!)
            XCTAssertNil(lit1.byteValue)
            XCTAssertNil(lit1.unsignedByteValue)
            XCTAssertNil(lit1.doubleValue)
            let lit2 = try Literal(stringValue: "-8723", dataType: XSD.decimal)
            XCTAssertTrue(-8723 == lit2.intValue)
            XCTAssertTrue(-8723 == lit2.integerValue)
            XCTAssertTrue(-8723 == lit2.longValue)
            XCTAssertTrue(-8723 == lit2.shortValue)
            XCTAssertEqual("\"-8723\"^^xsd:decimal", lit2.sparql)
            XCTAssertTrue(XSD.decimal == lit2.dataType!)
            XCTAssertNil(lit2.unsignedIntValue)
            XCTAssertNil(lit2.unsignedLongValue)
            XCTAssertNil(lit2.unsignedShortValue)
            XCTAssertNil(lit2.unsignedByteValue)
            XCTAssertNil(lit2.byteValue)
            XCTAssertNil(lit2.doubleValue)
            let lit3 = try Literal(stringValue: "-8", dataType: XSD.decimal)
            XCTAssertTrue(-8 == lit3.intValue)
            XCTAssertTrue(-8 == lit3.integerValue)
            XCTAssertTrue(-8 == lit3.longValue)
            XCTAssertTrue(-8 == lit3.shortValue)
            XCTAssertEqual("\"-8\"^^xsd:decimal", lit3.sparql)
            XCTAssertTrue(XSD.decimal == lit3.dataType!)
            XCTAssertNil(lit3.unsignedIntValue)
            XCTAssertNil(lit3.unsignedLongValue)
            XCTAssertNil(lit3.unsignedShortValue)
            XCTAssertNil(lit3.unsignedByteValue)
            XCTAssertNil(lit3.doubleValue)
            do {
                let shouldfail = try Literal(stringValue: "928832772734329489869893849859823948923848239842354", dataType: XSD.decimal)
                XCTFail("Value of integer should be illegal, but is: \(shouldfail)")
            } catch {
                XCTAssertTrue(true)
            }
            do {
                let shouldfail = try Literal(stringValue: "-928832772734329489869893849859823948923848239842354", dataType: XSD.decimal)
                XCTFail("Value of integer should be illegal, but is: \(shouldfail)")
            } catch {
                XCTAssertTrue(true)
            }
            do {
                _ = try Literal(stringValue: "\(Int64(Int.max)-1)", dataType: XSD.decimal)
                XCTAssertTrue(true)
            } catch {
                XCTFail("Value of integer should be legal, but an error was thrown.")
            }
            do {
                _ = try Literal(stringValue: "\(Int64(Int.min)+1)", dataType: XSD.decimal)
                XCTAssertTrue(true)
            } catch {
                XCTFail("Value of integer should be legal, but an error was thrown.")
            }
            do {
                let shouldfail = try Literal(stringValue: "3E3", dataType: XSD.decimal)
                XCTFail("Value of integer should be illegal, but is: \(shouldfail)")
            } catch {
                XCTAssertTrue(true)
            }
            do {
                let shouldfail = try Literal(stringValue: "bla", dataType: XSD.decimal)
                XCTFail("Value of integer should be illegal, but is: \(shouldfail)")
            } catch {
                XCTAssertTrue(true)
            }
        } catch {
            XCTFail("Error when converting string to integer.")
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
        XCTAssertNil(lit2.unsignedByteValue)
        XCTAssertNil(lit2.byteValue)
        XCTAssertNil(lit2.doubleValue)
        let lit3 = Literal(integerValue: -8)
        XCTAssertTrue(-8 == lit3.intValue)
        XCTAssertTrue(-8 == lit3.integerValue)
        XCTAssertTrue(-8 == lit3.longValue)
        XCTAssertTrue(-8 == lit3.shortValue)
        XCTAssertEqual("-8", lit3.sparql)
        XCTAssertTrue(XSD.integer == lit3.dataType!)
        XCTAssertNil(lit3.unsignedIntValue)
        XCTAssertNil(lit3.unsignedLongValue)
        XCTAssertNil(lit3.unsignedShortValue)
        XCTAssertNil(lit3.unsignedByteValue)
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
            XCTAssertNil(lit2.unsignedByteValue)
            XCTAssertNil(lit2.byteValue)
            XCTAssertNil(lit2.doubleValue)
            let lit3 = try Literal(stringValue: "-8", dataType: XSD.integer)
            XCTAssertTrue(-8 == lit3.intValue)
            XCTAssertTrue(-8 == lit3.integerValue)
            XCTAssertTrue(-8 == lit3.longValue)
            XCTAssertTrue(-8 == lit3.shortValue)
            XCTAssertEqual("-8", lit3.sparql)
            XCTAssertTrue(XSD.integer == lit3.dataType!)
            XCTAssertNil(lit3.unsignedIntValue)
            XCTAssertNil(lit3.unsignedLongValue)
            XCTAssertNil(lit3.unsignedShortValue)
            XCTAssertNil(lit3.unsignedByteValue)
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
                _ = try Literal(stringValue: "\(Int64(Int.max)-1)", dataType: XSD.integer)
                XCTAssertTrue(true)
            } catch {
                XCTFail("Value of integer should be legal, but an error was thrown.")
            }
            do {
                _ = try Literal(stringValue: "\(Int64(Int.min)+1)", dataType: XSD.integer)
                XCTAssertTrue(true)
            } catch {
                XCTFail("Value of integer should be legal, but an error was thrown.")
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
    
    func testNonPositiveIntegerLiteral() {
        let lit0 = Literal(nonPositiveIntegerValue: 0)
        XCTAssertTrue(0 == lit0!.intValue)
        XCTAssertTrue(0 == lit0!.integerValue)
        XCTAssertTrue(0 == lit0!.unsignedIntValue)
        XCTAssertTrue(0 == lit0!.longValue)
        XCTAssertTrue(0 == lit0!.unsignedLongValue)
        XCTAssertTrue(0 == lit0!.shortValue)
        XCTAssertTrue(0 == lit0!.unsignedShortValue)
        XCTAssertEqual("\"0\"^^xsd:nonPositiveInteger", lit0!.sparql)
        XCTAssertTrue(XSD.nonPositiveInteger == lit0!.dataType!)
        XCTAssertTrue(0 == lit0!.byteValue)
        XCTAssertTrue(0 == lit0!.unsignedByteValue)
        XCTAssertTrue(nil == lit0!.doubleValue)
        let lit1 = Literal(nonPositiveIntegerValue: -23255)
        XCTAssertTrue(-23255 == lit1!.intValue)
        XCTAssertTrue(-23255 == lit1!.integerValue)
        XCTAssertTrue(nil == lit1!.unsignedIntValue)
        XCTAssertTrue(-23255 == lit1!.longValue)
        XCTAssertTrue(nil == lit1!.unsignedLongValue)
        XCTAssertTrue(-23255 == lit1!.shortValue)
        XCTAssertTrue(nil == lit1!.unsignedShortValue)
        XCTAssertEqual("\"-23255\"^^xsd:nonPositiveInteger", lit1!.sparql)
        XCTAssertTrue(XSD.nonPositiveInteger == lit1!.dataType!)
        XCTAssertNil(lit1!.byteValue)
        XCTAssertNil(lit1!.unsignedByteValue)
        XCTAssertNil(lit1!.doubleValue)
        let lit2 = Literal(nonPositiveIntegerValue: -8723)
        XCTAssertTrue(-8723 == lit2!.intValue)
        XCTAssertTrue(-8723 == lit2!.integerValue)
        XCTAssertTrue(-8723 == lit2!.longValue)
        XCTAssertTrue(-8723 == lit2!.shortValue)
        XCTAssertEqual("\"-8723\"^^xsd:nonPositiveInteger", lit2!.sparql)
        XCTAssertTrue(XSD.nonPositiveInteger == lit2!.dataType!)
        XCTAssertNil(lit2!.unsignedIntValue)
        XCTAssertNil(lit2!.unsignedLongValue)
        XCTAssertNil(lit2!.unsignedShortValue)
        XCTAssertNil(lit2!.unsignedByteValue)
        XCTAssertNil(lit2!.byteValue)
        XCTAssertNil(lit2!.doubleValue)
        let lit3 = Literal(nonPositiveIntegerValue: -8)
        XCTAssertTrue(-8 == lit3!.intValue)
        XCTAssertTrue(-8 == lit3!.integerValue)
        XCTAssertTrue(-8 == lit3!.longValue)
        XCTAssertTrue(-8 == lit3!.shortValue)
        XCTAssertEqual("\"-8\"^^xsd:nonPositiveInteger", lit3!.sparql)
        XCTAssertTrue(XSD.nonPositiveInteger == lit3!.dataType!)
        XCTAssertNil(lit3!.unsignedIntValue)
        XCTAssertNil(lit3!.unsignedLongValue)
        XCTAssertNil(lit3!.unsignedShortValue)
        XCTAssertNil(lit3!.unsignedByteValue)
        XCTAssertNil(lit3!.doubleValue)
        let lit4 = Literal(nonPositiveIntegerValue: 23255)
        XCTAssertNil(lit4)
    }
    
    func testNonPositiveIntegerLiteralFromString() {
        do{
            do {
                let shouldfail = try Literal(stringValue: "23255", dataType: XSD.nonPositiveInteger)
                XCTFail("Value of non-positive integer should be illegal, but is: \(shouldfail)")
            } catch {
                XCTAssertTrue(true)
            }
            let lit0 = try Literal(stringValue: "0", dataType: XSD.nonPositiveInteger)
            XCTAssertTrue(0 == lit0.intValue)
            XCTAssertTrue(0 == lit0.integerValue)
            XCTAssertTrue(0 == lit0.unsignedIntValue)
            XCTAssertTrue(0 == lit0.longValue)
            XCTAssertTrue(0 == lit0.unsignedLongValue)
            XCTAssertTrue(0 == lit0.shortValue)
            XCTAssertTrue(0 == lit0.unsignedShortValue)
            XCTAssertEqual("\"0\"^^xsd:nonPositiveInteger", lit0.sparql)
            XCTAssertTrue(XSD.nonPositiveInteger == lit0.dataType!)
            XCTAssertTrue(0 == lit0.byteValue)
            XCTAssertTrue(0 == lit0.unsignedByteValue)
            XCTAssertNil(lit0.doubleValue)
            let lit1 = try Literal(stringValue: "-23255", dataType: XSD.nonPositiveInteger)
            XCTAssertTrue(-23255 == lit1.intValue)
            XCTAssertTrue(-23255 == lit1.integerValue)
            XCTAssertTrue(nil == lit1.unsignedIntValue)
            XCTAssertTrue(-23255 == lit1.longValue)
            XCTAssertTrue(nil == lit1.unsignedLongValue)
            XCTAssertTrue(-23255 == lit1.shortValue)
            XCTAssertTrue(nil == lit1.unsignedShortValue)
            XCTAssertEqual("\"-23255\"^^xsd:nonPositiveInteger", lit1.sparql)
            XCTAssertTrue(XSD.nonPositiveInteger == lit1.dataType!)
            XCTAssertNil(lit1.byteValue)
            XCTAssertNil(lit1.unsignedByteValue)
            XCTAssertNil(lit1.doubleValue)
            let lit2 = try Literal(stringValue: "-8723", dataType: XSD.nonPositiveInteger)
            XCTAssertTrue(-8723 == lit2.intValue)
            XCTAssertTrue(-8723 == lit2.integerValue)
            XCTAssertTrue(-8723 == lit2.longValue)
            XCTAssertTrue(-8723 == lit2.shortValue)
            XCTAssertEqual("\"-8723\"^^xsd:nonPositiveInteger", lit2.sparql)
            XCTAssertTrue(XSD.nonPositiveInteger == lit2.dataType!)
            XCTAssertNil(lit2.unsignedIntValue)
            XCTAssertNil(lit2.unsignedLongValue)
            XCTAssertNil(lit2.unsignedShortValue)
            XCTAssertNil(lit2.unsignedByteValue)
            XCTAssertNil(lit2.byteValue)
            XCTAssertNil(lit2.doubleValue)
            let lit3 = try Literal(stringValue: "-8", dataType: XSD.nonPositiveInteger)
            XCTAssertTrue(-8 == lit3.intValue)
            XCTAssertTrue(-8 == lit3.integerValue)
            XCTAssertTrue(-8 == lit3.longValue)
            XCTAssertTrue(-8 == lit3.shortValue)
            XCTAssertEqual("\"-8\"^^xsd:nonPositiveInteger", lit3.sparql)
            XCTAssertTrue(XSD.nonPositiveInteger == lit3.dataType!)
            XCTAssertNil(lit3.unsignedIntValue)
            XCTAssertNil(lit3.unsignedLongValue)
            XCTAssertNil(lit3.unsignedShortValue)
            XCTAssertNil(lit3.unsignedByteValue)
            XCTAssertNil(lit3.doubleValue)
            do {
                let shouldfail = try Literal(stringValue: "928832772734329489869893849859823948923848239842354", dataType: XSD.nonPositiveInteger)
                XCTFail("Value of integer should be illegal, but is: \(shouldfail)")
            } catch {
                XCTAssertTrue(true)
            }
            do {
                let shouldfail = try Literal(stringValue: "-928832772734329489869893849859823948923848239842354", dataType: XSD.nonPositiveInteger)
                XCTFail("Value of integer should be illegal, but is: \(shouldfail)")
            } catch {
                XCTAssertTrue(true)
            }
            do {
                let shouldfail = try Literal(stringValue: "\(Int64(Int.max)-1)", dataType: XSD.nonPositiveInteger)
                XCTFail("Value of integer should be illegal, but is: \(shouldfail)")
            } catch {
                XCTAssertTrue(true)
            }
            do {
                _ = try Literal(stringValue: "\(Int64(Int.min)+1)", dataType: XSD.nonPositiveInteger)
                XCTAssertTrue(true)
            } catch {
                XCTFail("Value of integer should be legal, but an error was thrown.")
            }
            do {
                let shouldfail = try Literal(stringValue: "3.1415928", dataType: XSD.nonPositiveInteger)
                XCTFail("Value of integer should be illegal, but is: \(shouldfail)")
            } catch {
                XCTAssertTrue(true)
            }
            do {
                let shouldfail = try Literal(stringValue: "3E3", dataType: XSD.nonPositiveInteger)
                XCTFail("Value of integer should be illegal, but is: \(shouldfail)")
            } catch {
                XCTAssertTrue(true)
            }
            do {
                let shouldfail = try Literal(stringValue: "bla", dataType: XSD.nonPositiveInteger)
                XCTFail("Value of integer should be illegal, but is: \(shouldfail)")
            } catch {
                XCTAssertTrue(true)
            }
        } catch {
            XCTFail("Error when converting string to non positive integer.")
        }
    }
    
    
    func testNonNegativeIntegerLiteral() {
        let lit0 = Literal(nonNegativeIntegerValue: 0)
        XCTAssertTrue(0 == lit0.intValue)
        XCTAssertTrue(0 == lit0.integerValue)
        XCTAssertTrue(0 == lit0.unsignedIntValue)
        XCTAssertTrue(0 == lit0.longValue)
        XCTAssertTrue(0 == lit0.unsignedLongValue)
        XCTAssertTrue(0 == lit0.shortValue)
        XCTAssertTrue(0 == lit0.unsignedShortValue)
        XCTAssertEqual("\"0\"^^xsd:nonNegativeInteger", lit0.sparql)
        XCTAssertTrue(XSD.nonNegativeInteger == lit0.dataType!)
        XCTAssertTrue(0 == lit0.byteValue)
        XCTAssertTrue(0 == lit0.unsignedByteValue)
        XCTAssertTrue(nil == lit0.doubleValue)
        let lit1 = Literal(nonNegativeIntegerValue: 23255)
        XCTAssertTrue(23255 == lit1.intValue)
        XCTAssertTrue(23255 == lit1.integerValue)
        XCTAssertTrue(23255 == lit1.longValue)
        XCTAssertTrue(23255 == lit1.shortValue)
        XCTAssertTrue(23255 == lit1.unsignedIntValue)
        XCTAssertTrue(23255 == lit1.unsignedLongValue)
        XCTAssertTrue(23255 == lit1.unsignedShortValue)
        XCTAssertEqual("\"23255\"^^xsd:nonNegativeInteger", lit1.sparql)
        XCTAssertTrue(XSD.nonNegativeInteger == lit1.dataType!)
        XCTAssertNil(lit1.byteValue)
        XCTAssertNil(lit1.unsignedByteValue)
        XCTAssertNil(lit1.doubleValue)
        let lit2 = Literal(nonNegativeIntegerValue: 8723)
        XCTAssertTrue(8723 == lit2.intValue)
        XCTAssertTrue(8723 == lit2.integerValue)
        XCTAssertTrue(8723 == lit2.longValue)
        XCTAssertTrue(8723 == lit2.shortValue)
        XCTAssertTrue(8723 == lit2.unsignedIntValue)
        XCTAssertTrue(8723 == lit2.unsignedLongValue)
        XCTAssertTrue(8723 == lit2.unsignedShortValue)
        XCTAssertEqual("\"8723\"^^xsd:nonNegativeInteger", lit2.sparql)
        XCTAssertTrue(XSD.nonNegativeInteger == lit2.dataType!)
        XCTAssertNil(lit2.unsignedByteValue)
        XCTAssertNil(lit2.byteValue)
        XCTAssertNil(lit2.doubleValue)
        let lit3 = Literal(nonNegativeIntegerValue: 8)
        XCTAssertTrue(8 == lit3.intValue)
        XCTAssertTrue(8 == lit3.integerValue)
        XCTAssertTrue(8 == lit3.longValue)
        XCTAssertTrue(8 == lit3.shortValue)
        XCTAssertTrue(8 == lit3.unsignedIntValue)
        XCTAssertTrue(8 == lit3.unsignedLongValue)
        XCTAssertTrue(8 == lit3.unsignedShortValue)
        XCTAssertTrue(8 == lit3.unsignedByteValue)
        XCTAssertEqual("\"8\"^^xsd:nonNegativeInteger", lit3.sparql)
        XCTAssertTrue(XSD.nonNegativeInteger == lit3.dataType!)
        XCTAssertNil(lit3.doubleValue)
    }
    
    func testNonNegativeIntegerLiteralFromString() {
        do{
            do {
                let shouldfail = try Literal(stringValue: "-23255", dataType: XSD.nonNegativeInteger)
                XCTFail("Value of non-positive integer should be illegal, but is: \(shouldfail)")
            } catch {
                XCTAssertTrue(true)
            }
            let lit0 = try Literal(stringValue: "0", dataType: XSD.nonNegativeInteger)
            XCTAssertTrue(0 == lit0.intValue)
            XCTAssertTrue(0 == lit0.integerValue)
            XCTAssertTrue(0 == lit0.unsignedIntValue)
            XCTAssertTrue(0 == lit0.longValue)
            XCTAssertTrue(0 == lit0.unsignedLongValue)
            XCTAssertTrue(0 == lit0.shortValue)
            XCTAssertTrue(0 == lit0.unsignedShortValue)
            XCTAssertEqual("\"0\"^^xsd:nonNegativeInteger", lit0.sparql)
            XCTAssertTrue(XSD.nonNegativeInteger == lit0.dataType!)
            XCTAssertTrue(0 == lit0.byteValue)
            XCTAssertTrue(0 == lit0.unsignedByteValue)
            XCTAssertNil(lit0.doubleValue)
            let lit1 = try Literal(stringValue: "23255", dataType: XSD.nonNegativeInteger)
            XCTAssertTrue(23255 == lit1.intValue)
            XCTAssertTrue(23255 == lit1.integerValue)
            XCTAssertTrue(23255 == lit1.unsignedIntValue)
            XCTAssertTrue(23255 == lit1.longValue)
            XCTAssertTrue(23255 == lit1.unsignedLongValue)
            XCTAssertTrue(23255 == lit1.shortValue)
            XCTAssertTrue(23255 == lit1.unsignedShortValue)
            XCTAssertEqual("\"23255\"^^xsd:nonNegativeInteger", lit1.sparql)
            XCTAssertTrue(XSD.nonNegativeInteger == lit1.dataType!)
            XCTAssertNil(lit1.byteValue)
            XCTAssertNil(lit1.unsignedByteValue)
            XCTAssertNil(lit1.doubleValue)
            let lit2 = try Literal(stringValue: "8723", dataType: XSD.nonNegativeInteger)
            XCTAssertTrue(8723 == lit2.intValue)
            XCTAssertTrue(8723 == lit2.integerValue)
            XCTAssertTrue(8723 == lit2.longValue)
            XCTAssertTrue(8723 == lit2.shortValue)
            XCTAssertEqual("\"8723\"^^xsd:nonNegativeInteger", lit2.sparql)
            XCTAssertTrue(XSD.nonNegativeInteger == lit2.dataType!)
            XCTAssertTrue(8723 == lit2.unsignedIntValue)
            XCTAssertTrue(8723 == lit2.unsignedLongValue)
            XCTAssertTrue(8723 == lit2.unsignedShortValue)
            XCTAssertNil(lit2.unsignedByteValue)
            XCTAssertNil(lit2.byteValue)
            XCTAssertNil(lit2.doubleValue)
            let lit3 = try Literal(stringValue: "8", dataType: XSD.nonNegativeInteger)
            XCTAssertTrue(8 == lit3.intValue)
            XCTAssertTrue(8 == lit3.integerValue)
            XCTAssertTrue(8 == lit3.longValue)
            XCTAssertTrue(8 == lit3.shortValue)
            XCTAssertEqual("\"8\"^^xsd:nonNegativeInteger", lit3.sparql)
            XCTAssertTrue(XSD.nonNegativeInteger == lit3.dataType!)
            XCTAssertTrue(8 == lit3.unsignedIntValue)
            XCTAssertTrue(8 == lit3.unsignedLongValue)
            XCTAssertTrue(8 == lit3.unsignedShortValue)
            XCTAssertTrue(8 == lit3.unsignedByteValue)
            XCTAssertNil(lit3.doubleValue)
            do {
                let shouldfail = try Literal(stringValue: "928832772734329489869893849859823948923848239842354", dataType: XSD.nonNegativeInteger)
                XCTFail("Value of integer should be illegal, but is: \(shouldfail)")
            } catch {
                XCTAssertTrue(true)
            }
            do {
                let shouldfail = try Literal(stringValue: "-928832772734329489869893849859823948923848239842354", dataType: XSD.nonNegativeInteger)
                XCTFail("Value of integer should be illegal, but is: \(shouldfail)")
            } catch {
                XCTAssertTrue(true)
            }
            do {
                _ = try Literal(stringValue: "\(Int64(Int.max)-1)", dataType: XSD.nonNegativeInteger)
                XCTAssertTrue(true)
            } catch {
                XCTFail("Value of integer should be legal, but an error was thrown.")
            }
            do {
                let shouldfail = try Literal(stringValue: "\(Int64(Int.min)+1)", dataType: XSD.nonNegativeInteger)
                XCTFail("Value of integer should be illegal, but is: \(shouldfail)")
            } catch {
                XCTAssertTrue(true)
            }
            do {
                let shouldfail = try Literal(stringValue: "3.1415928", dataType: XSD.nonNegativeInteger)
                XCTFail("Value of integer should be illegal, but is: \(shouldfail)")
            } catch {
                XCTAssertTrue(true)
            }
            do {
                let shouldfail = try Literal(stringValue: "3E3", dataType: XSD.nonNegativeInteger)
                XCTFail("Value of integer should be illegal, but is: \(shouldfail)")
            } catch {
                XCTAssertTrue(true)
            }
            do {
                let shouldfail = try Literal(stringValue: "bla", dataType: XSD.nonNegativeInteger)
                XCTFail("Value of integer should be illegal, but is: \(shouldfail)")
            } catch {
                XCTAssertTrue(true)
            }
        } catch {
            XCTFail("Error when converting string to non positive integer.")
        }
    }
    
    func testNegativeIntegerLiteral() {
        let lit0 = Literal(negativeIntegerValue: 0)
        XCTAssertNil(lit0)
        let lit1 = Literal(negativeIntegerValue: -23255)
        XCTAssertTrue(-23255 == lit1!.intValue)
        XCTAssertTrue(-23255 == lit1!.integerValue)
        XCTAssertTrue(nil == lit1!.unsignedIntValue)
        XCTAssertTrue(-23255 == lit1!.longValue)
        XCTAssertTrue(nil == lit1!.unsignedLongValue)
        XCTAssertTrue(-23255 == lit1!.shortValue)
        XCTAssertTrue(nil == lit1!.unsignedShortValue)
        XCTAssertEqual("\"-23255\"^^xsd:negativeInteger", lit1!.sparql)
        XCTAssertTrue(XSD.negativeInteger == lit1!.dataType!)
        XCTAssertNil(lit1!.byteValue)
        XCTAssertNil(lit1!.unsignedByteValue)
        XCTAssertNil(lit1!.doubleValue)
        let lit2 = Literal(negativeIntegerValue: -8723)
        XCTAssertTrue(-8723 == lit2!.intValue)
        XCTAssertTrue(-8723 == lit2!.integerValue)
        XCTAssertTrue(-8723 == lit2!.longValue)
        XCTAssertTrue(-8723 == lit2!.shortValue)
        XCTAssertEqual("\"-8723\"^^xsd:negativeInteger", lit2!.sparql)
        XCTAssertTrue(XSD.negativeInteger == lit2!.dataType!)
        XCTAssertNil(lit2!.unsignedIntValue)
        XCTAssertNil(lit2!.unsignedLongValue)
        XCTAssertNil(lit2!.unsignedShortValue)
        XCTAssertNil(lit2!.unsignedByteValue)
        XCTAssertNil(lit2!.byteValue)
        XCTAssertNil(lit2!.doubleValue)
        let lit3 = Literal(negativeIntegerValue: -8)
        XCTAssertTrue(-8 == lit3!.intValue)
        XCTAssertTrue(-8 == lit3!.integerValue)
        XCTAssertTrue(-8 == lit3!.longValue)
        XCTAssertTrue(-8 == lit3!.shortValue)
        XCTAssertEqual("\"-8\"^^xsd:negativeInteger", lit3!.sparql)
        XCTAssertTrue(XSD.negativeInteger == lit3!.dataType!)
        XCTAssertNil(lit3!.unsignedIntValue)
        XCTAssertNil(lit3!.unsignedLongValue)
        XCTAssertNil(lit3!.unsignedShortValue)
        XCTAssertNil(lit3!.unsignedByteValue)
        XCTAssertNil(lit3!.doubleValue)
        let lit4 = Literal(negativeIntegerValue: 23255)
        XCTAssertNil(lit4)
    }
    func testNegativeIntegerLiteralFromString() {
        do{
            do {
                let shouldfail = try Literal(stringValue: "23255", dataType: XSD.negativeInteger)
                XCTFail("Value of non-positive integer should be illegal, but is: \(shouldfail)")
            } catch {
                XCTAssertTrue(true)
            }
            do {
                let shouldfail = try Literal(stringValue: "0", dataType: XSD.negativeInteger)
                XCTFail("Value of negative integer should be illegal, but is: \(shouldfail)")
            } catch {
                XCTAssertTrue(true)
            }
            let lit1 = try Literal(stringValue: "-23255", dataType: XSD.negativeInteger)
            XCTAssertTrue(-23255 == lit1.intValue)
            XCTAssertTrue(-23255 == lit1.integerValue)
            XCTAssertTrue(nil == lit1.unsignedIntValue)
            XCTAssertTrue(-23255 == lit1.longValue)
            XCTAssertTrue(nil == lit1.unsignedLongValue)
            XCTAssertTrue(-23255 == lit1.shortValue)
            XCTAssertTrue(nil == lit1.unsignedShortValue)
            XCTAssertEqual("\"-23255\"^^xsd:negativeInteger", lit1.sparql)
            XCTAssertTrue(XSD.negativeInteger == lit1.dataType!)
            XCTAssertNil(lit1.byteValue)
            XCTAssertNil(lit1.unsignedByteValue)
            XCTAssertNil(lit1.doubleValue)
            let lit2 = try Literal(stringValue: "-8723", dataType: XSD.negativeInteger)
            XCTAssertTrue(-8723 == lit2.intValue)
            XCTAssertTrue(-8723 == lit2.integerValue)
            XCTAssertTrue(-8723 == lit2.longValue)
            XCTAssertTrue(-8723 == lit2.shortValue)
            XCTAssertEqual("\"-8723\"^^xsd:negativeInteger", lit2.sparql)
            XCTAssertTrue(XSD.negativeInteger == lit2.dataType!)
            XCTAssertNil(lit2.unsignedIntValue)
            XCTAssertNil(lit2.unsignedLongValue)
            XCTAssertNil(lit2.unsignedShortValue)
            XCTAssertNil(lit2.unsignedByteValue)
            XCTAssertNil(lit2.byteValue)
            XCTAssertNil(lit2.doubleValue)
            let lit3 = try Literal(stringValue: "-8", dataType: XSD.negativeInteger)
            XCTAssertTrue(-8 == lit3.intValue)
            XCTAssertTrue(-8 == lit3.integerValue)
            XCTAssertTrue(-8 == lit3.longValue)
            XCTAssertTrue(-8 == lit3.shortValue)
            XCTAssertEqual("\"-8\"^^xsd:negativeInteger", lit3.sparql)
            XCTAssertTrue(XSD.negativeInteger == lit3.dataType!)
            XCTAssertNil(lit3.unsignedIntValue)
            XCTAssertNil(lit3.unsignedLongValue)
            XCTAssertNil(lit3.unsignedShortValue)
            XCTAssertNil(lit3.unsignedByteValue)
            XCTAssertNil(lit3.doubleValue)
            do {
                let shouldfail = try Literal(stringValue: "928832772734329489869893849859823948923848239842354", dataType: XSD.nonPositiveInteger)
                XCTFail("Value of integer should be illegal, but is: \(shouldfail)")
            } catch {
                XCTAssertTrue(true)
            }
            do {
                let shouldfail = try Literal(stringValue: "-928832772734329489869893849859823948923848239842354", dataType: XSD.nonPositiveInteger)
                XCTFail("Value of integer should be illegal, but is: \(shouldfail)")
            } catch {
                XCTAssertTrue(true)
            }
            do {
                let shouldfail = try Literal(stringValue: "\(Int64(Int.max)-1)", dataType: XSD.nonPositiveInteger)
                XCTFail("Value of integer should be illegal, but is: \(shouldfail)")
            } catch {
                XCTAssertTrue(true)
            }
            do {
                _ = try Literal(stringValue: "\(Int64(Int.min)+1)", dataType: XSD.nonPositiveInteger)
                XCTAssertTrue(true)
            } catch {
                XCTFail("Value of integer should be legal, but an error was thrown.")
            }
            do {
                let shouldfail = try Literal(stringValue: "3.1415928", dataType: XSD.nonPositiveInteger)
                XCTFail("Value of integer should be illegal, but is: \(shouldfail)")
            } catch {
                XCTAssertTrue(true)
            }
            do {
                let shouldfail = try Literal(stringValue: "3E3", dataType: XSD.nonPositiveInteger)
                XCTFail("Value of integer should be illegal, but is: \(shouldfail)")
            } catch {
                XCTAssertTrue(true)
            }
            do {
                let shouldfail = try Literal(stringValue: "bla", dataType: XSD.nonPositiveInteger)
                XCTFail("Value of integer should be illegal, but is: \(shouldfail)")
            } catch {
                XCTAssertTrue(true)
            }
        } catch {
            XCTFail("Error when converting string to non positive integer.")
        }
    }
    
    func testPositiveIntegerLiteral() {
        let lit0 = Literal(positiveIntegerValue: 0)
        XCTAssertNil(lit0)
        let lit1 = Literal(positiveIntegerValue: 23255)
        XCTAssertTrue(23255 == lit1!.intValue)
        XCTAssertTrue(23255 == lit1!.integerValue)
        XCTAssertTrue(23255 == lit1!.unsignedIntValue)
        XCTAssertTrue(23255 == lit1!.longValue)
        XCTAssertTrue(23255 == lit1!.unsignedLongValue)
        XCTAssertTrue(23255 == lit1!.shortValue)
        XCTAssertTrue(23255 == lit1!.unsignedShortValue)
        XCTAssertEqual("\"23255\"^^xsd:positiveInteger", lit1!.sparql)
        XCTAssertTrue(XSD.positiveInteger == lit1!.dataType!)
        XCTAssertNil(lit1!.byteValue)
        XCTAssertNil(lit1!.unsignedByteValue)
        XCTAssertNil(lit1!.doubleValue)
        let lit2 = Literal(positiveIntegerValue: 8723)
        XCTAssertTrue(8723 == lit2!.intValue)
        XCTAssertTrue(8723 == lit2!.integerValue)
        XCTAssertTrue(8723 == lit2!.longValue)
        XCTAssertTrue(8723 == lit2!.shortValue)
        XCTAssertEqual("\"8723\"^^xsd:positiveInteger", lit2!.sparql)
        XCTAssertTrue(XSD.positiveInteger == lit2!.dataType!)
        XCTAssertTrue(8723 == lit2!.unsignedIntValue)
        XCTAssertTrue(8723 == lit2!.unsignedLongValue)
        XCTAssertTrue(8723 == lit2!.unsignedShortValue)
        XCTAssertNil(lit2!.unsignedByteValue)
        XCTAssertNil(lit2!.byteValue)
        XCTAssertNil(lit2!.doubleValue)
        let lit3 = Literal(positiveIntegerValue: 8)
        XCTAssertTrue(8 == lit3!.intValue)
        XCTAssertTrue(8 == lit3!.integerValue)
        XCTAssertTrue(8 == lit3!.longValue)
        XCTAssertTrue(8 == lit3!.shortValue)
        XCTAssertEqual("\"8\"^^xsd:positiveInteger", lit3!.sparql)
        XCTAssertTrue(XSD.positiveInteger == lit3!.dataType!)
        XCTAssertTrue(8 == lit3!.unsignedIntValue)
        XCTAssertTrue(8 == lit3!.unsignedLongValue)
        XCTAssertTrue(8 == lit3!.unsignedShortValue)
        XCTAssertTrue(8 == lit3!.unsignedByteValue)
        XCTAssertNil(lit3!.doubleValue)
    }
    
    func testPositiveIntegerLiteralFromString() {
        do{
            do {
                let shouldfail = try Literal(stringValue: "-23255", dataType: XSD.positiveInteger)
                XCTFail("Value of non-positive integer should be illegal, but is: \(shouldfail)")
            } catch {
                XCTAssertTrue(true)
            }
            do {
                let shouldfail = try Literal(stringValue: "0", dataType: XSD.positiveInteger)
                XCTFail("Value of negative integer should be illegal, but is: \(shouldfail)")
            } catch {
                XCTAssertTrue(true)
            }
            let lit1 = try Literal(stringValue: "23255", dataType: XSD.positiveInteger)
            XCTAssertTrue(23255 == lit1.intValue)
            XCTAssertTrue(23255 == lit1.integerValue)
            XCTAssertTrue(23255 == lit1.unsignedIntValue)
            XCTAssertTrue(23255 == lit1.longValue)
            XCTAssertTrue(23255 == lit1.unsignedLongValue)
            XCTAssertTrue(23255 == lit1.shortValue)
            XCTAssertTrue(23255 == lit1.unsignedShortValue)
            XCTAssertEqual("\"23255\"^^xsd:positiveInteger", lit1.sparql)
            XCTAssertTrue(XSD.positiveInteger == lit1.dataType!)
            XCTAssertNil(lit1.byteValue)
            XCTAssertNil(lit1.unsignedByteValue)
            XCTAssertNil(lit1.doubleValue)
            let lit2 = try Literal(stringValue: "8723", dataType: XSD.positiveInteger)
            XCTAssertTrue(8723 == lit2.intValue)
            XCTAssertTrue(8723 == lit2.integerValue)
            XCTAssertTrue(8723 == lit2.longValue)
            XCTAssertTrue(8723 == lit2.shortValue)
            XCTAssertEqual("\"8723\"^^xsd:positiveInteger", lit2.sparql)
            XCTAssertTrue(XSD.positiveInteger == lit2.dataType!)
            XCTAssertTrue(8723 == lit2.unsignedIntValue)
            XCTAssertTrue(8723 == lit2.unsignedLongValue)
            XCTAssertTrue(8723 == lit2.unsignedShortValue)
            XCTAssertNil(lit2.unsignedByteValue)
            XCTAssertNil(lit2.byteValue)
            XCTAssertNil(lit2.doubleValue)
            let lit3 = try Literal(stringValue: "8", dataType: XSD.positiveInteger)
            XCTAssertTrue(8 == lit3.intValue)
            XCTAssertTrue(8 == lit3.integerValue)
            XCTAssertTrue(8 == lit3.longValue)
            XCTAssertTrue(8 == lit3.shortValue)
            XCTAssertEqual("\"8\"^^xsd:positiveInteger", lit3.sparql)
            XCTAssertTrue(XSD.positiveInteger == lit3.dataType!)
            XCTAssertTrue(8 == lit3.unsignedIntValue)
            XCTAssertTrue(8 == lit3.unsignedLongValue)
            XCTAssertTrue(8 == lit3.unsignedShortValue)
            XCTAssertTrue(8 == lit3.unsignedByteValue)
            XCTAssertNil(lit3.doubleValue)
            do {
                let shouldfail = try Literal(stringValue: "928832772734329489869893849859823948923848239842354", dataType: XSD.positiveInteger)
                XCTFail("Value of integer should be illegal, but is: \(shouldfail)")
            } catch {
                XCTAssertTrue(true)
            }
            do {
                let shouldfail = try Literal(stringValue: "-928832772734329489869893849859823948923848239842354", dataType: XSD.positiveInteger)
                XCTFail("Value of integer should be illegal, but is: \(shouldfail)")
            } catch {
                XCTAssertTrue(true)
            }
            do {
                _ = try Literal(stringValue: "\(Int64(Int.max)-1)", dataType: XSD.positiveInteger)
                XCTAssertTrue(true)
            } catch {
                XCTFail("Value of integer should be legal, but an error was thrown.")
            }
            do {
                let shouldfail = try Literal(stringValue: "\(Int64(Int.min)+1)", dataType: XSD.positiveInteger)
                XCTFail("Value of integer should be illegal, but is: \(shouldfail)")
            } catch {
                XCTAssertTrue(true)
            }
            do {
                let shouldfail = try Literal(stringValue: "3.1415928", dataType: XSD.positiveInteger)
                XCTFail("Value of integer should be illegal, but is: \(shouldfail)")
            } catch {
                XCTAssertTrue(true)
            }
            do {
                let shouldfail = try Literal(stringValue: "3E3", dataType: XSD.positiveInteger)
                XCTFail("Value of integer should be illegal, but is: \(shouldfail)")
            } catch {
                XCTAssertTrue(true)
            }
            do {
                let shouldfail = try Literal(stringValue: "bla", dataType: XSD.positiveInteger)
                XCTFail("Value of integer should be illegal, but is: \(shouldfail)")
            } catch {
                XCTAssertTrue(true)
            }
        } catch {
            XCTFail("Error when converting string to non positive integer.")
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
    
    func testLongLiteralFromString() {
        do{
            let lit1 = try Literal(stringValue: "23255", dataType: XSD.long)
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
            let lit2 = try Literal(stringValue: "-8723", dataType: XSD.long)
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
            let lit3 = try Literal(stringValue: "-8", dataType: XSD.long)
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
            do {
                let shouldfail = try Literal(stringValue: "928832772734329489869893849859823948923848239842354", dataType: XSD.long)
                XCTFail("Value of integer should be illegal, but is: \(shouldfail)")
            } catch {
                XCTAssertTrue(true)
            }
            do {
                let shouldfail = try Literal(stringValue: "-928832772734329489869893849859823948923848239842354", dataType: XSD.long)
                XCTFail("Value of integer should be illegal, but is: \(shouldfail)")
            } catch {
                XCTAssertTrue(true)
            }
            do {
                _ = try Literal(stringValue: "\(Int64(Int64.max)-1)", dataType: XSD.long)
                XCTAssertTrue(true)
            } catch {
                XCTFail("Value of integer should be legal, but an error was thrown.")
            }
            do {
                _ = try Literal(stringValue: "\(Int64(Int64.min)+1)", dataType: XSD.long)
                XCTAssertTrue(true)
            } catch {
                XCTFail("Value of integer should be legal, but an error was thrown.")
            }
            do {
                let shouldfail = try Literal(stringValue: "3.1415928", dataType: XSD.long)
                XCTFail("Value of integer should be illegal, but is: \(shouldfail)")
            } catch {
                XCTAssertTrue(true)
            }
            do {
                let shouldfail = try Literal(stringValue: "3E3", dataType: XSD.long)
                XCTFail("Value of integer should be illegal, but is: \(shouldfail)")
            } catch {
                XCTAssertTrue(true)
            }
            do {
                let shouldfail = try Literal(stringValue: "bla", dataType: XSD.long)
                XCTFail("Value of integer should be illegal, but is: \(shouldfail)")
            } catch {
                XCTAssertTrue(true)
            }
        } catch {
            XCTFail("Error when converting string to integer.")
        }
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
    
    func testIntLiteralFromString() {
        do{
            let lit1 = try Literal(stringValue: "23255", dataType: XSD.int)
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
            let lit2 = try Literal(stringValue: "-8723", dataType: XSD.int)
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
            let lit3 = try Literal(stringValue: "-8", dataType: XSD.int)
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
            do {
                let shouldfail = try Literal(stringValue: "\(Int64.max-1)", dataType: XSD.int)
                XCTFail("Value of integer should be illegal, but is: \(shouldfail.stringValue)")
            } catch {
                XCTAssertTrue(true)
            }
            do {
                let shouldfail = try Literal(stringValue: "\(Int64.min+1)", dataType: XSD.int)
                XCTFail("Value of integer should be illegal, but is: \(shouldfail.stringValue)")
            } catch {
                XCTAssertTrue(true)
            }
            do {
                let shouldfail = try Literal(stringValue: "\(Int64(Int32.max)+1)", dataType: XSD.int)
                XCTFail("Value of integer should be illegal, but is: \(shouldfail.stringValue)")
            } catch {
                XCTAssertTrue(true)
            }
            do {
                let shouldfail = try Literal(stringValue: "\(Int64(Int32.min)-1)", dataType: XSD.int)
                XCTFail("Value of integer should be illegal, but is: \(shouldfail.stringValue)")
            } catch {
                XCTAssertTrue(true)
            }
            do {
                _ = try Literal(stringValue: "\(Int64(Int32.max)-1)", dataType: XSD.int)
                XCTAssertTrue(true)
            } catch {
                XCTFail("Value of integer should be legal, but an error was thrown.")
            }
            do {
                _ = try Literal(stringValue: "\(Int64(Int32.min)+1)", dataType: XSD.int)
                XCTAssertTrue(true)
            } catch {
                XCTFail("Value of integer should be legal, but an error was thrown.")
            }
            do {
                let shouldfail = try Literal(stringValue: "3.1415928", dataType: XSD.int)
                XCTFail("Value of integer should be illegal, but is: \(shouldfail)")
            } catch {
                XCTAssertTrue(true)
            }
            do {
                let shouldfail = try Literal(stringValue: "3E3", dataType: XSD.int)
                XCTFail("Value of integer should be illegal, but is: \(shouldfail)")
            } catch {
                XCTAssertTrue(true)
            }
            do {
                let shouldfail = try Literal(stringValue: "bla", dataType: XSD.int)
                XCTFail("Value of integer should be illegal, but is: \(shouldfail)")
            } catch {
                XCTAssertTrue(true)
            }
        } catch {
            XCTFail("Error when converting string to integer.")
        }
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
    
    func testShortLiteralFromString() {
        do{
            let lit1 = try Literal(stringValue: "23255", dataType: XSD.short)
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
            let lit2 = try Literal(stringValue: "-8723", dataType: XSD.short)
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
            let lit3 = try Literal(stringValue: "-8", dataType: XSD.short)
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
            do {
                let shouldfail = try Literal(stringValue: "\(Int32.max-1)", dataType: XSD.short)
                XCTFail("Value of integer should be illegal, but is: \(shouldfail.stringValue)")
            } catch {
                XCTAssertTrue(true)
            }
            do {
                let shouldfail = try Literal(stringValue: "\(Int32.min+1)", dataType: XSD.short)
                XCTFail("Value of integer should be illegal, but is: \(shouldfail.stringValue)")
            } catch {
                XCTAssertTrue(true)
            }
            do {
                let shouldfail = try Literal(stringValue: "\(Int64(Int16.max)+1)", dataType: XSD.short)
                XCTFail("Value of integer should be illegal, but is: \(shouldfail.stringValue)")
            } catch {
                XCTAssertTrue(true)
            }
            do {
                let shouldfail = try Literal(stringValue: "\(Int64(Int16.min)-1)", dataType: XSD.short)
                XCTFail("Value of integer should be illegal, but is: \(shouldfail.stringValue)")
            } catch {
                XCTAssertTrue(true)
            }
            do {
                _ = try Literal(stringValue: "\(Int64(Int16.max)-1)", dataType: XSD.short)
                XCTAssertTrue(true)
            } catch {
                XCTFail("Value of integer should be legal, but an error was thrown.")
            }
            do {
                _ = try Literal(stringValue: "\(Int64(Int16.min)+1)", dataType: XSD.short)
                XCTAssertTrue(true)
            } catch {
                XCTFail("Value of integer should be legal, but an error was thrown.")
            }
            do {
                let shouldfail = try Literal(stringValue: "3.1415928", dataType: XSD.short)
                XCTFail("Value of integer should be illegal, but is: \(shouldfail)")
            } catch {
                XCTAssertTrue(true)
            }
            do {
                let shouldfail = try Literal(stringValue: "3E3", dataType: XSD.short)
                XCTFail("Value of integer should be illegal, but is: \(shouldfail)")
            } catch {
                XCTAssertTrue(true)
            }
            do {
                let shouldfail = try Literal(stringValue: "bla", dataType: XSD.short)
                XCTFail("Value of integer should be illegal, but is: \(shouldfail)")
            } catch {
                XCTAssertTrue(true)
            }
        } catch {
            XCTFail("Error when converting string to integer.")
        }
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
    
    func testByteLiteralFromString() {
        do{
            let lit3 = try Literal(stringValue: "-8", dataType: XSD.byte)
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
            do {
                let shouldfail = try Literal(stringValue: "\(Int16.max-1)", dataType: XSD.byte)
                XCTFail("Value of integer should be illegal, but is: \(shouldfail.stringValue)")
            } catch {
                XCTAssertTrue(true)
            }
            do {
                let shouldfail = try Literal(stringValue: "\(Int16.min+1)", dataType: XSD.byte)
                XCTFail("Value of integer should be illegal, but is: \(shouldfail.stringValue)")
            } catch {
                XCTAssertTrue(true)
            }
            do {
                let shouldfail = try Literal(stringValue: "\(Int64(Int8.max)+1)", dataType: XSD.byte)
                XCTFail("Value of integer should be illegal, but is: \(shouldfail.stringValue)")
            } catch {
                XCTAssertTrue(true)
            }
            do {
                let shouldfail = try Literal(stringValue: "\(Int64(Int8.min)-1)", dataType: XSD.byte)
                XCTFail("Value of integer should be illegal, but is: \(shouldfail.stringValue)")
            } catch {
                XCTAssertTrue(true)
            }
            do {
                _ = try Literal(stringValue: "\(Int64(Int8.max)-1)", dataType: XSD.byte)
                XCTAssertTrue(true)
            } catch {
                XCTFail("Value of integer should be legal, but an error was thrown.")
            }
            do {
                _ = try Literal(stringValue: "\(Int64(Int8.min)+1)", dataType: XSD.byte)
                XCTAssertTrue(true)
            } catch {
                XCTFail("Value of integer should be legal, but an error was thrown.")
            }
            do {
                let shouldfail = try Literal(stringValue: "3.1415928", dataType: XSD.byte)
                XCTFail("Value of integer should be illegal, but is: \(shouldfail)")
            } catch {
                XCTAssertTrue(true)
            }
            do {
                let shouldfail = try Literal(stringValue: "3E3", dataType: XSD.byte)
                XCTFail("Value of integer should be illegal, but is: \(shouldfail)")
            } catch {
                XCTAssertTrue(true)
            }
            do {
                let shouldfail = try Literal(stringValue: "bla", dataType: XSD.byte)
                XCTFail("Value of integer should be illegal, but is: \(shouldfail)")
            } catch {
                XCTAssertTrue(true)
            }
        } catch {
            XCTFail("Error when converting string to integer.")
        }
    }
    
    func testUnsignedLongLiteral() {
        let lit1 = Literal(unsignedLongValue: 23255)
        XCTAssertTrue(23255 == lit1.intValue)
        XCTAssertTrue(23255 == lit1.integerValue)
        XCTAssertTrue(23255 == lit1.unsignedIntValue)
        XCTAssertTrue(23255 == lit1.longValue)
        XCTAssertTrue(23255 == lit1.unsignedLongValue)
        XCTAssertTrue(23255 == lit1.shortValue)
        XCTAssertTrue(23255 == lit1.unsignedShortValue)
        XCTAssertEqual("\"23255\"^^xsd:unsignedLong", lit1.sparql)
        XCTAssertTrue(XSD.unsignedLong == lit1.dataType!)
        XCTAssertNil(lit1.byteValue)
        XCTAssertNil(lit1.unsignedByteValue)
        XCTAssertNil(lit1.doubleValue)
    }
    
    func testUnsignedLongLiteralFromString() {
        do{
            let lit1 = try Literal(stringValue: "23255", dataType: XSD.unsignedLong)
            XCTAssertTrue(23255 == lit1.intValue)
            XCTAssertTrue(23255 == lit1.integerValue)
            XCTAssertTrue(23255 == lit1.unsignedIntValue)
            XCTAssertTrue(23255 == lit1.longValue)
            XCTAssertTrue(23255 == lit1.unsignedLongValue)
            XCTAssertTrue(23255 == lit1.shortValue)
            XCTAssertTrue(23255 == lit1.unsignedShortValue)
            XCTAssertEqual("\"23255\"^^xsd:unsignedLong", lit1.sparql)
            XCTAssertTrue(XSD.unsignedLong == lit1.dataType!)
            XCTAssertNil(lit1.byteValue)
            XCTAssertNil(lit1.unsignedByteValue)
            XCTAssertNil(lit1.doubleValue)
            do {
                let shouldfail = try Literal(stringValue: "928832772734329489869893849859823948923848239842354", dataType: XSD.unsignedLong)
                XCTFail("Value of integer should be illegal, but is: \(shouldfail)")
            } catch {
                XCTAssertTrue(true)
            }
            do {
                let shouldfail = try Literal(stringValue: "-928832772734329489869893849859823948923848239842354", dataType: XSD.unsignedLong)
                XCTFail("Value of integer should be illegal, but is: \(shouldfail)")
            } catch {
                XCTAssertTrue(true)
            }
            do {
                _ = try Literal(stringValue: "\(UInt64(UInt64.max)-1)", dataType: XSD.unsignedLong)
                XCTAssertTrue(true)
            } catch {
                XCTFail("Value of integer should be legal, but an error was thrown.")
            }
            do {
                let shouldfail  = try Literal(stringValue: "\(Int64(Int64.min)+1)", dataType: XSD.unsignedLong)
                XCTFail("Value of unsigned integer should be illegal, but is: \(shouldfail)")
            } catch {
                XCTAssertTrue(true)
            }
            do {
                let shouldfail = try Literal(stringValue: "3.1415928", dataType: XSD.unsignedLong)
                XCTFail("Value of integer should be illegal, but is: \(shouldfail)")
            } catch {
                XCTAssertTrue(true)
            }
            do {
                let shouldfail = try Literal(stringValue: "3E3", dataType: XSD.unsignedLong)
                XCTFail("Value of integer should be illegal, but is: \(shouldfail)")
            } catch {
                XCTAssertTrue(true)
            }
            do {
                let shouldfail = try Literal(stringValue: "bla", dataType: XSD.unsignedLong)
                XCTFail("Value of integer should be illegal, but is: \(shouldfail)")
            } catch {
                XCTAssertTrue(true)
            }
        } catch {
            XCTFail("Error when converting string to integer.")
        }
    }
    
    func testUnsignedIntLiteral() {
        let lit1 = Literal(unsignedIntValue: 23255)
        XCTAssertTrue(23255 == lit1.intValue)
        XCTAssertTrue(23255 == lit1.integerValue)
        XCTAssertTrue(23255 == lit1.unsignedIntValue)
        XCTAssertTrue(23255 == lit1.longValue)
        XCTAssertTrue(23255 == lit1.unsignedLongValue)
        XCTAssertTrue(23255 == lit1.shortValue)
        XCTAssertTrue(23255 == lit1.unsignedShortValue)
        XCTAssertEqual("\"23255\"^^xsd:unsignedInt", lit1.sparql)
        XCTAssertTrue(XSD.unsignedInt == lit1.dataType!)
        XCTAssertNil(lit1.byteValue)
        XCTAssertNil(lit1.unsignedByteValue)
        XCTAssertNil(lit1.doubleValue)
    }
    
    func testUnsignedIntLiteralFromString() {
        do{
            let lit1 = try Literal(stringValue: "23255", dataType: XSD.unsignedInt)
            XCTAssertTrue(23255 == lit1.intValue)
            XCTAssertTrue(23255 == lit1.integerValue)
            XCTAssertTrue(23255 == lit1.unsignedIntValue)
            XCTAssertTrue(23255 == lit1.longValue)
            XCTAssertTrue(23255 == lit1.unsignedLongValue)
            XCTAssertTrue(23255 == lit1.shortValue)
            XCTAssertTrue(23255 == lit1.unsignedShortValue)
            XCTAssertEqual("\"23255\"^^xsd:unsignedInt", lit1.sparql)
            XCTAssertTrue(XSD.unsignedInt == lit1.dataType!)
            XCTAssertNil(lit1.byteValue)
            XCTAssertNil(lit1.unsignedByteValue)
            XCTAssertNil(lit1.doubleValue)
            do {
                let shouldfail = try Literal(stringValue: "\(UInt64(UInt32.max)+1)", dataType: XSD.unsignedInt)
                XCTFail("Value of integer should be illegal, but is: \(shouldfail.stringValue)")
            } catch {
                XCTAssertTrue(true)
            }
            do {
                let shouldfail = try Literal(stringValue: "\(Int64(Int32.min)-1)", dataType: XSD.unsignedInt)
                XCTFail("Value of integer should be illegal, but is: \(shouldfail.stringValue)")
            } catch {
                XCTAssertTrue(true)
            }
            do {
                _ = try Literal(stringValue: "\(UInt64(UInt32.max)-1)", dataType: XSD.unsignedInt)
                XCTAssertTrue(true)
            } catch {
                XCTFail("Value of integer should be legal, but an error was thrown.")
            }
            do {
                let shouldfail  = try Literal(stringValue: "\(Int64(Int32.min)+1)", dataType: XSD.unsignedInt)
                XCTFail("Value of unsigned integer should be illegal, but is: \(shouldfail)")
            } catch {
                XCTAssertTrue(true)
            }
            do {
                let shouldfail = try Literal(stringValue: "3.1415928", dataType: XSD.unsignedInt)
                XCTFail("Value of integer should be illegal, but is: \(shouldfail)")
            } catch {
                XCTAssertTrue(true)
            }
            do {
                let shouldfail = try Literal(stringValue: "3E3", dataType: XSD.unsignedInt)
                XCTFail("Value of integer should be illegal, but is: \(shouldfail)")
            } catch {
                XCTAssertTrue(true)
            }
            do {
                let shouldfail = try Literal(stringValue: "bla", dataType: XSD.unsignedInt)
                XCTFail("Value of integer should be illegal, but is: \(shouldfail)")
            } catch {
                XCTAssertTrue(true)
            }
        } catch {
            XCTFail("Error when converting string to integer.")
        }
    }
    
    func testUnsignedShortLiteral() {
        let lit1 = Literal(unsignedShortValue: 23255)
        XCTAssertTrue(23255 == lit1.intValue)
        XCTAssertTrue(23255 == lit1.integerValue)
        XCTAssertTrue(23255 == lit1.unsignedIntValue)
        XCTAssertTrue(23255 == lit1.longValue)
        XCTAssertTrue(23255 == lit1.unsignedLongValue)
        XCTAssertTrue(23255 == lit1.shortValue)
        XCTAssertTrue(23255 == lit1.unsignedShortValue)
        XCTAssertEqual("\"23255\"^^xsd:unsignedShort", lit1.sparql)
        XCTAssertTrue(XSD.unsignedShort == lit1.dataType!)
        XCTAssertNil(lit1.byteValue)
        XCTAssertNil(lit1.unsignedByteValue)
        XCTAssertNil(lit1.doubleValue)
    }
    
    func testUnsignedShortLiteralFromString() {
        do{
            let lit1 = try Literal(stringValue: "23255", dataType: XSD.unsignedShort)
            XCTAssertTrue(23255 == lit1.intValue)
            XCTAssertTrue(23255 == lit1.integerValue)
            XCTAssertTrue(23255 == lit1.unsignedIntValue)
            XCTAssertTrue(23255 == lit1.longValue)
            XCTAssertTrue(23255 == lit1.unsignedLongValue)
            XCTAssertTrue(23255 == lit1.shortValue)
            XCTAssertTrue(23255 == lit1.unsignedShortValue)
            XCTAssertEqual("\"23255\"^^xsd:unsignedShort", lit1.sparql)
            XCTAssertTrue(XSD.unsignedShort == lit1.dataType!)
            XCTAssertNil(lit1.byteValue)
            XCTAssertNil(lit1.unsignedByteValue)
            XCTAssertNil(lit1.doubleValue)
            do {
                let shouldfail = try Literal(stringValue: "\(UInt64(UInt16.max)+1)", dataType: XSD.unsignedShort)
                XCTFail("Value of integer should be illegal, but is: \(shouldfail.stringValue)")
            } catch {
                XCTAssertTrue(true)
            }
            do {
                let shouldfail = try Literal(stringValue: "\(Int64(Int16.min)-1)", dataType: XSD.unsignedShort)
                XCTFail("Value of integer should be illegal, but is: \(shouldfail.stringValue)")
            } catch {
                XCTAssertTrue(true)
            }
            do {
                _ = try Literal(stringValue: "\(UInt64(UInt16.max)-1)", dataType: XSD.unsignedShort)
                XCTAssertTrue(true)
            } catch {
                XCTFail("Value of integer should be legal, but an error was thrown.")
            }
            do {
                let shouldfail  = try Literal(stringValue: "\(Int64(Int16.min)+1)", dataType: XSD.unsignedShort)
                XCTFail("Value of unsigned integer should be illegal, but is: \(shouldfail)")
            } catch {
                XCTAssertTrue(true)
            }
            do {
                let shouldfail = try Literal(stringValue: "3.1415928", dataType: XSD.unsignedShort)
                XCTFail("Value of integer should be illegal, but is: \(shouldfail)")
            } catch {
                XCTAssertTrue(true)
            }
            do {
                let shouldfail = try Literal(stringValue: "3E3", dataType: XSD.unsignedShort)
                XCTFail("Value of integer should be illegal, but is: \(shouldfail)")
            } catch {
                XCTAssertTrue(true)
            }
            do {
                let shouldfail = try Literal(stringValue: "bla", dataType: XSD.unsignedShort)
                XCTFail("Value of integer should be illegal, but is: \(shouldfail)")
            } catch {
                XCTAssertTrue(true)
            }
        } catch {
            XCTFail("Error when converting string to integer.")
        }
    }
    
    func testUnsignedByteLiteral() {
        let lit1 = Literal(unsignedByteValue: 102)
        XCTAssertTrue(102 == lit1.intValue)
        XCTAssertTrue(102 == lit1.integerValue)
        XCTAssertTrue(102 == lit1.unsignedIntValue)
        XCTAssertTrue(102 == lit1.longValue)
        XCTAssertTrue(102 == lit1.unsignedLongValue)
        XCTAssertTrue(102 == lit1.shortValue)
        XCTAssertTrue(102 == lit1.unsignedShortValue)
        XCTAssertTrue(102 == lit1.byteValue)
        XCTAssertTrue(102 == lit1.unsignedByteValue)
        XCTAssertEqual("\"102\"^^xsd:unsignedByte", lit1.sparql)
        XCTAssertTrue(XSD.unsignedByte == lit1.dataType!)
        XCTAssertNil(lit1.doubleValue)
    }
    
    func testUnsignedByteLiteralFromString() {
        do{
            let lit1 = try Literal(stringValue: "102", dataType: XSD.unsignedByte)
            XCTAssertTrue(102 == lit1.intValue)
            XCTAssertTrue(102 == lit1.integerValue)
            XCTAssertTrue(102 == lit1.unsignedIntValue)
            XCTAssertTrue(102 == lit1.longValue)
            XCTAssertTrue(102 == lit1.unsignedLongValue)
            XCTAssertTrue(102 == lit1.shortValue)
            XCTAssertTrue(102 == lit1.unsignedShortValue)
            XCTAssertTrue(102 == lit1.byteValue)
            XCTAssertTrue(102 == lit1.unsignedByteValue)
            XCTAssertEqual("\"102\"^^xsd:unsignedByte", lit1.sparql)
            XCTAssertTrue(XSD.unsignedByte == lit1.dataType!)
            XCTAssertNil(lit1.doubleValue)
            do {
                let shouldfail = try Literal(stringValue: "\(UInt64(UInt8.max)+1)", dataType: XSD.unsignedByte)
                XCTFail("Value of integer should be illegal, but is: \(shouldfail.stringValue)")
            } catch {
                XCTAssertTrue(true)
            }
            do {
                let shouldfail = try Literal(stringValue: "\(Int64(Int8.min)-1)", dataType: XSD.unsignedByte)
                XCTFail("Value of integer should be illegal, but is: \(shouldfail.stringValue)")
            } catch {
                XCTAssertTrue(true)
            }
            do {
                _ = try Literal(stringValue: "\(UInt64(UInt8.max)-1)", dataType: XSD.unsignedByte)
                XCTAssertTrue(true)
            } catch {
                XCTFail("Value of integer should be legal, but an error was thrown.")
            }
            do {
                let shouldfail  = try Literal(stringValue: "\(Int64(Int8.min)+1)", dataType: XSD.unsignedByte)
                XCTFail("Value of unsigned integer should be illegal, but is: \(shouldfail)")
            } catch {
                XCTAssertTrue(true)
            }
            do {
                let shouldfail = try Literal(stringValue: "3.1415928", dataType: XSD.unsignedByte)
                XCTFail("Value of integer should be illegal, but is: \(shouldfail)")
            } catch {
                XCTAssertTrue(true)
            }
            do {
                let shouldfail = try Literal(stringValue: "3E3", dataType: XSD.unsignedByte)
                XCTFail("Value of integer should be illegal, but is: \(shouldfail)")
            } catch {
                XCTAssertTrue(true)
            }
            do {
                let shouldfail = try Literal(stringValue: "bla", dataType: XSD.unsignedByte)
                XCTFail("Value of integer should be illegal, but is: \(shouldfail)")
            } catch {
                XCTAssertTrue(true)
            }
        } catch {
            XCTFail("Error when converting string to integer.")
        }
    }
}
