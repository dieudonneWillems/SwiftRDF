//
//  DecimalTests.swift
//  SwiftRDF-OSX
//
//  Created by Don Willems on 05/12/15.
//  Copyright © 2015 lapsedpacifist. All rights reserved.
//

import Foundation

import XCTest
@testable import SwiftRDFOSX

class DecimalTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    
    func testDecimal() {
        let decimal0 = Decimal(decimalInteger: 123456789012345678, decimalExponent: 0)
        XCTAssertEqual("123456789012345678", decimal0?.description)
        let decimal1 = Decimal(decimalInteger: 123456789012345678, decimalExponent: 2)
        XCTAssertEqual("1234567890123456.78", decimal1?.description)
        let decimal2 = Decimal(decimalInteger: 123456789012345678, decimalExponent: 10)
        XCTAssertEqual("12345678.9012345678", decimal2?.description)
        let decimal3 = Decimal(decimalInteger: 123456789012345678, decimalExponent: 17)
        XCTAssertEqual("1.23456789012345678", decimal3?.description)
        let decimal4 = Decimal(decimalInteger: 123456789012345678, decimalExponent: 18)
        XCTAssertEqual("0.123456789012345678", decimal4?.description)
        let decimal5 = Decimal(decimalInteger: 123456789012345678, decimalExponent: 19)
        XCTAssertNil(decimal5?.description)
        let decimal6 = Decimal(decimalInteger: 12, decimalExponent: 1)
        XCTAssertEqual("1.2", decimal6?.description)
        let decimal7 = Decimal(decimalInteger: 12, decimalExponent: 2)
        XCTAssertEqual("0.12", decimal7?.description)
        let decimal8 = Decimal(decimalInteger: 12, decimalExponent: 10)
        XCTAssertEqual("0.0000000012", decimal8?.description)
    }
    
    func testPositiveDecimal() {
        let decimal0 = Decimal(decimalInteger: +123456789012345678, decimalExponent: 0)
        XCTAssertEqual("123456789012345678", decimal0?.description)
        let decimal1 = Decimal(decimalInteger: +123456789012345678, decimalExponent: 2)
        XCTAssertEqual("1234567890123456.78", decimal1?.description)
        let decimal2 = Decimal(decimalInteger: +123456789012345678, decimalExponent: 10)
        XCTAssertEqual("12345678.9012345678", decimal2?.description)
        let decimal3 = Decimal(decimalInteger: +123456789012345678, decimalExponent: 17)
        XCTAssertEqual("1.23456789012345678", decimal3?.description)
        let decimal4 = Decimal(decimalInteger: +123456789012345678, decimalExponent: 18)
        XCTAssertEqual("0.123456789012345678", decimal4?.description)
        let decimal5 = Decimal(decimalInteger: +123456789012345678, decimalExponent: 19)
        XCTAssertNil(decimal5?.description)
        let decimal6 = Decimal(decimalInteger: +12, decimalExponent: 1)
        XCTAssertEqual("1.2", decimal6?.description)
        let decimal7 = Decimal(decimalInteger: +12, decimalExponent: 2)
        XCTAssertEqual("0.12", decimal7?.description)
        let decimal8 = Decimal(decimalInteger: +12, decimalExponent: 10)
        XCTAssertEqual("0.0000000012", decimal8?.description)
    }
    
    func testNegativeDecimal() {
        let decimal0 = Decimal(decimalInteger: -123456789012345678, decimalExponent: 0)
        XCTAssertEqual("-123456789012345678", decimal0?.description)
        let decimal1 = Decimal(decimalInteger: -123456789012345678, decimalExponent: 2)
        XCTAssertEqual("-1234567890123456.78", decimal1?.description)
        let decimal2 = Decimal(decimalInteger: -123456789012345678, decimalExponent: 10)
        XCTAssertEqual("-12345678.9012345678", decimal2?.description)
        let decimal3 = Decimal(decimalInteger: -123456789012345678, decimalExponent: 17)
        XCTAssertEqual("-1.23456789012345678", decimal3?.description)
        let decimal4 = Decimal(decimalInteger: -123456789012345678, decimalExponent: 18)
        XCTAssertEqual("-0.123456789012345678", decimal4?.description)
        let decimal5 = Decimal(decimalInteger: -123456789012345678, decimalExponent: 19)
        XCTAssertNil(decimal5?.description)
        let decimal6 = Decimal(decimalInteger: -12, decimalExponent: 1)
        XCTAssertEqual("-1.2", decimal6?.description)
        let decimal7 = Decimal(decimalInteger: -12, decimalExponent: 2)
        XCTAssertEqual("-0.12", decimal7?.description)
        let decimal8 = Decimal(decimalInteger: -12, decimalExponent: 10)
        XCTAssertEqual("-0.0000000012", decimal8?.description)
    }
    
    func testDecimalFromString() {
        let decimal0 = Decimal(stringValue: "12345678901234567890")
        XCTAssertNil(decimal0) // too many digits
        let decimal1 = Decimal(stringValue: "123456789012345678")
        XCTAssertEqual(Int64(123456789012345678), decimal1?.decimalInteger)
        XCTAssertEqual(UInt8(0), decimal1?.decimalExponent)
        let decimal2 = Decimal(stringValue: "1234567890123456.78")
        XCTAssertEqual(Int64(123456789012345678), decimal2?.decimalInteger)
        XCTAssertEqual(UInt8(2), decimal2?.decimalExponent)
        let decimal3 = Decimal(stringValue: "1234.56789012345678")
        XCTAssertEqual(Int64(123456789012345678), decimal3?.decimalInteger)
        XCTAssertEqual(UInt8(14), decimal3?.decimalExponent)
        let decimal4 = Decimal(stringValue: "1.23456789012345678")
        XCTAssertEqual(Int64(123456789012345678), decimal4?.decimalInteger)
        XCTAssertEqual(UInt8(17), decimal4?.decimalExponent)
        let decimal5 = Decimal(stringValue: "0.123456789012345678")
        XCTAssertEqual(Int64(123456789012345678), decimal5?.decimalInteger)
        XCTAssertEqual(UInt8(18), decimal5?.decimalExponent)
        let decimal6 = Decimal(stringValue: "0.00003")
        XCTAssertEqual(Int64(3), decimal6?.decimalInteger)
        XCTAssertEqual(UInt8(5), decimal6?.decimalExponent)
        let decimal7 = Decimal(stringValue: "3.45e7")
        XCTAssertNil(decimal7)
        let decimal8 = Decimal(stringValue: "3.4533.22")
        XCTAssertNil(decimal8)
        let decimal9 = Decimal(stringValue: "saddde")
        XCTAssertNil(decimal9)
    }
    
    func testPositiveDecimalFromString() {
        let decimal0 = Decimal(stringValue: "+12345678901234567890")
        XCTAssertNil(decimal0) // too many digits
        let decimal1 = Decimal(stringValue: "+123456789012345678")
        XCTAssertEqual(Int64(123456789012345678), decimal1?.decimalInteger)
        XCTAssertEqual(UInt8(0), decimal1?.decimalExponent)
        let decimal2 = Decimal(stringValue: "+1234567890123456.78")
        XCTAssertEqual(Int64(123456789012345678), decimal2?.decimalInteger)
        XCTAssertEqual(UInt8(2), decimal2?.decimalExponent)
        let decimal3 = Decimal(stringValue: "+1234.56789012345678")
        XCTAssertEqual(Int64(123456789012345678), decimal3?.decimalInteger)
        XCTAssertEqual(UInt8(14), decimal3?.decimalExponent)
        let decimal4 = Decimal(stringValue: "+1.23456789012345678")
        XCTAssertEqual(Int64(123456789012345678), decimal4?.decimalInteger)
        XCTAssertEqual(UInt8(17), decimal4?.decimalExponent)
        let decimal5 = Decimal(stringValue: "+0.123456789012345678")
        XCTAssertEqual(Int64(123456789012345678), decimal5?.decimalInteger)
        XCTAssertEqual(UInt8(18), decimal5?.decimalExponent)
        let decimal6 = Decimal(stringValue: "+0.00003")
        XCTAssertEqual(Int64(3), decimal6?.decimalInteger)
        XCTAssertEqual(UInt8(5), decimal6?.decimalExponent)
        let decimal7 = Decimal(stringValue: "+3.45e7")
        XCTAssertNil(decimal7)
        let decimal8 = Decimal(stringValue: "+3.4533.22")
        XCTAssertNil(decimal8)
        let decimal9 = Decimal(stringValue: "+saddde")
        XCTAssertNil(decimal9)
    }
    
    func testDecimalFromStringWithSpaces() {
        let decimal0 = Decimal(stringValue: " 12345678901234567890 ")
        XCTAssertNil(decimal0) // too many digits
        let decimal1 = Decimal(stringValue: "123456789012345678 ")
        XCTAssertEqual(Int64(123456789012345678), decimal1?.decimalInteger)
        XCTAssertEqual(UInt8(0), decimal1?.decimalExponent)
        let decimal2 = Decimal(stringValue: " 1234567890123456.78")
        XCTAssertEqual(Int64(123456789012345678), decimal2?.decimalInteger)
        XCTAssertEqual(UInt8(2), decimal2?.decimalExponent)
        let decimal3 = Decimal(stringValue: " 1234.56789012345678")
        XCTAssertEqual(Int64(123456789012345678), decimal3?.decimalInteger)
        XCTAssertEqual(UInt8(14), decimal3?.decimalExponent)
        let decimal4 = Decimal(stringValue: "1.23456789012345678 ")
        XCTAssertEqual(Int64(123456789012345678), decimal4?.decimalInteger)
        XCTAssertEqual(UInt8(17), decimal4?.decimalExponent)
        let decimal5 = Decimal(stringValue: " 0.123456789012345678")
        XCTAssertEqual(Int64(123456789012345678), decimal5?.decimalInteger)
        XCTAssertEqual(UInt8(18), decimal5?.decimalExponent)
        let decimal6 = Decimal(stringValue: "0.00003 ")
        XCTAssertEqual(Int64(3), decimal6?.decimalInteger)
        XCTAssertEqual(UInt8(5), decimal6?.decimalExponent)
        let decimal7 = Decimal(stringValue: "3.45e7 ")
        XCTAssertNil(decimal7)
        let decimal8 = Decimal(stringValue: " 3.4533.22")
        XCTAssertNil(decimal8)
        let decimal9 = Decimal(stringValue: " saddde ")
        XCTAssertNil(decimal9)
    }
    
    func testPositiveDecimalFromStringWithSpaces() {
        let decimal0 = Decimal(stringValue: " +12345678901234567890")
        XCTAssertNil(decimal0) // too many digits
        let decimal1 = Decimal(stringValue: "+123456789012345678 ")
        XCTAssertEqual(Int64(123456789012345678), decimal1?.decimalInteger)
        XCTAssertEqual(UInt8(0), decimal1?.decimalExponent)
        let decimal2 = Decimal(stringValue: " +1234567890123456.78")
        XCTAssertEqual(Int64(123456789012345678), decimal2?.decimalInteger)
        XCTAssertEqual(UInt8(2), decimal2?.decimalExponent)
        let decimal3 = Decimal(stringValue: "+1234.56789012345678 ")
        XCTAssertEqual(Int64(123456789012345678), decimal3?.decimalInteger)
        XCTAssertEqual(UInt8(14), decimal3?.decimalExponent)
        let decimal4 = Decimal(stringValue: " +1.23456789012345678 ")
        XCTAssertEqual(Int64(123456789012345678), decimal4?.decimalInteger)
        XCTAssertEqual(UInt8(17), decimal4?.decimalExponent)
        let decimal5 = Decimal(stringValue: " +0.123456789012345678 ")
        XCTAssertEqual(Int64(123456789012345678), decimal5?.decimalInteger)
        XCTAssertEqual(UInt8(18), decimal5?.decimalExponent)
        let decimal6 = Decimal(stringValue: "+0.00003 ")
        XCTAssertEqual(Int64(3), decimal6?.decimalInteger)
        XCTAssertEqual(UInt8(5), decimal6?.decimalExponent)
        let decimal7 = Decimal(stringValue: " +3.45e7")
        XCTAssertNil(decimal7)
        let decimal8 = Decimal(stringValue: " +3.4533.22")
        XCTAssertNil(decimal8)
        let decimal9 = Decimal(stringValue: "+saddde ")
        XCTAssertNil(decimal9)
    }
    
    func testNegativeDecimalFromStringWithSpaces() {
        let decimal0 = Decimal(stringValue: " -12345678901234567890")
        XCTAssertNil(decimal0) // too many digits
        let decimal1 = Decimal(stringValue: "-123456789012345678 ")
        XCTAssertEqual(Int64(-123456789012345678), decimal1?.decimalInteger)
        XCTAssertEqual(UInt8(0), decimal1?.decimalExponent)
        let decimal2 = Decimal(stringValue: " -1234567890123456.78 ")
        XCTAssertEqual(Int64(-123456789012345678), decimal2?.decimalInteger)
        XCTAssertEqual(UInt8(2), decimal2?.decimalExponent)
        let decimal3 = Decimal(stringValue: "-1234.56789012345678 ")
        XCTAssertEqual(Int64(-123456789012345678), decimal3?.decimalInteger)
        XCTAssertEqual(UInt8(14), decimal3?.decimalExponent)
        let decimal4 = Decimal(stringValue: " -1.23456789012345678")
        XCTAssertEqual(Int64(-123456789012345678), decimal4?.decimalInteger)
        XCTAssertEqual(UInt8(17), decimal4?.decimalExponent)
        let decimal5 = Decimal(stringValue: " -0.123456789012345678")
        XCTAssertEqual(Int64(-123456789012345678), decimal5?.decimalInteger)
        XCTAssertEqual(UInt8(18), decimal5?.decimalExponent)
        let decimal6 = Decimal(stringValue: " -0.00003 ")
        XCTAssertEqual(Int64(-3), decimal6?.decimalInteger)
        XCTAssertEqual(UInt8(5), decimal6?.decimalExponent)
        let decimal7 = Decimal(stringValue: " -3.45e7")
        XCTAssertNil(decimal7)
        let decimal8 = Decimal(stringValue: "-3.4533.22")
        XCTAssertNil(decimal8)
        let decimal9 = Decimal(stringValue: "-saddde ")
        XCTAssertNil(decimal9)
    }
    
    func testDecimalFromInteger() {
        let decimal1 = Decimal(integerValue: 1232)
        XCTAssertEqual(Int64(1232), decimal1.decimalInteger)
        XCTAssertEqual(UInt8(0), decimal1.decimalExponent)
        let decimal2 = Decimal(longValue:123456789012345678)
        XCTAssertEqual(Int64(123456789012345678), decimal2.decimalInteger)
        XCTAssertEqual(UInt8(0), decimal2.decimalExponent)
        let decimal3 = Decimal(intValue: 123456789)
        XCTAssertEqual(Int64(123456789), decimal3.decimalInteger)
        XCTAssertEqual(UInt8(0), decimal3.decimalExponent)
        let decimal4 = Decimal(shortValue: 12345)
        XCTAssertEqual(Int64(12345), decimal4.decimalInteger)
        XCTAssertEqual(UInt8(0), decimal4.decimalExponent)
        let decimal5 = Decimal(byteValue: 123)
        XCTAssertEqual(Int64(123), decimal5.decimalInteger)
        XCTAssertEqual(UInt8(0), decimal5.decimalExponent)
    }
    
    func testNegativeDecimalFromInteger() {
        let decimal1 = Decimal(integerValue: -1232)
        XCTAssertEqual(Int64(-1232), decimal1.decimalInteger)
        XCTAssertEqual(UInt8(0), decimal1.decimalExponent)
        let decimal2 = Decimal(longValue:-123456789012345678)
        XCTAssertEqual(Int64(-123456789012345678), decimal2.decimalInteger)
        XCTAssertEqual(UInt8(0), decimal2.decimalExponent)
        let decimal3 = Decimal(intValue: -123456789)
        XCTAssertEqual(Int64(-123456789), decimal3.decimalInteger)
        XCTAssertEqual(UInt8(0), decimal3.decimalExponent)
        let decimal4 = Decimal(shortValue: -12345)
        XCTAssertEqual(Int64(-12345), decimal4.decimalInteger)
        XCTAssertEqual(UInt8(0), decimal4.decimalExponent)
        let decimal5 = Decimal(byteValue: -123)
        XCTAssertEqual(Int64(-123), decimal5.decimalInteger)
        XCTAssertEqual(UInt8(0), decimal5.decimalExponent)
    }
    
    func testDecimalFromDouble() {
        let decimal1 = Decimal(doubleValue: 12.34)
        XCTAssertEqual(Int64(1234), decimal1!.decimalInteger)
        XCTAssertEqual(UInt8(2), decimal1!.decimalExponent)
        let decimal2 = Decimal(doubleValue: 12.3456789012345678)
        XCTAssertEqual(Int64(123456789012346), decimal2!.decimalInteger)
        XCTAssertEqual(UInt8(13), decimal2!.decimalExponent)
    }
    
    func testNegativeDecimalFromDouble() {
        let decimal1 = Decimal(doubleValue: -12.34)
        XCTAssertEqual(Int64(-1234), decimal1!.decimalInteger)
        XCTAssertEqual(UInt8(2), decimal1!.decimalExponent)
        let decimal2 = Decimal(doubleValue: -12.3456789012345678)
        XCTAssertEqual(Int64(-123456789012346), decimal2!.decimalInteger)
        XCTAssertEqual(UInt8(13), decimal2!.decimalExponent)
    }
    
    func testDecimalFromFloat() {
        let decimal1 = Decimal(floatValue: 12.34)
        XCTAssertEqual(Int64(1234), decimal1!.decimalInteger)
        XCTAssertEqual(UInt8(2), decimal1!.decimalExponent)
        let decimal2 = Decimal(floatValue: 12.3457)
        XCTAssertEqual(Int64(123457), decimal2!.decimalInteger)
        XCTAssertEqual(UInt8(4), decimal2!.decimalExponent)
    }
    
    func testNegativeDecimalFromFloat() {
        let decimal1 = Decimal(floatValue: -12.34)
        XCTAssertEqual(Int64(-1234), decimal1!.decimalInteger)
        XCTAssertEqual(UInt8(2), decimal1!.decimalExponent)
        let decimal2 = Decimal(floatValue: -12.3456789012345678)
        XCTAssertEqual(Int64(-123457), decimal2!.decimalInteger)
        XCTAssertEqual(UInt8(4), decimal2!.decimalExponent)
    }
}
