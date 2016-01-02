//
//  TimeLiteralTests.swift
//  SwiftRDF-OSX
//
//  Created by Don Willems on 07/12/15.
//  Copyright © 2015 lapsedpacifist. All rights reserved.
//

import Foundation

import XCTest
@testable import SwiftRDFOSX

class TimeLiteralTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    
    func testDurationLiteral() {
        let dur1 = Duration(positive: true, years: 12, months: 23, days: 14, hours: 0, minutes: 0, seconds: 0)
        let lit1 = Literal(durationValue: dur1!)
        XCTAssertEqual("P12Y23M14D", lit1.stringValue)
        XCTAssertEqual("\"P12Y23M14D\"^^xsd:duration", lit1.sparql)
        XCTAssertTrue(lit1.dataType! == XSD.duration)
        XCTAssertNil(lit1.language)
        XCTAssertNil(lit1.longValue)
        let dur2 = Duration(positive: false, years: 12, months: 23, days: 14, hours: 15, minutes: 2, seconds: 0.93)
        let lit2 = Literal(durationValue: dur2!)
        XCTAssertEqual("-P12Y23M14DT15H2M0.93S", lit2.stringValue)
        XCTAssertEqual("\"-P12Y23M14DT15H2M0.93S\"^^xsd:duration", lit2.sparql)
        XCTAssertTrue(lit2.dataType! == XSD.duration)
        XCTAssertNil(lit2.language)
        XCTAssertNil(lit2.longValue)
    }
    
    func testDurationLiteralFromString() {
        let lit1 = Literal(stringValue: "P12Y23M14D", dataType: XSD.duration)!
        XCTAssertEqual("P12Y23M14D", lit1.stringValue)
        XCTAssertEqual("\"P12Y23M14D\"^^xsd:duration", lit1.sparql)
        XCTAssertTrue(lit1.dataType! == XSD.duration)
        XCTAssertNil(lit1.language)
        XCTAssertNil(lit1.longValue)
        let lit2 = Literal(stringValue: "-P12Y23M14DT15H2M0.93S", dataType: XSD.duration)!
        XCTAssertEqual("-P12Y23M14DT15H2M0.93S", lit2.stringValue)
        XCTAssertEqual("\"-P12Y23M14DT15H2M0.93S\"^^xsd:duration", lit2.sparql)
        XCTAssertTrue(lit2.dataType! == XSD.duration)
        XCTAssertNil(lit2.language)
        XCTAssertNil(lit2.longValue)
        
    }
    
    func testDateTimeLiteral(){
        var date = GregorianDate(year: 2015, month: 12, day: 16, hour: 12, minute: 10, second: 32.32, timezone: NSTimeZone(forSecondsFromGMT: 7200))
        var lit = Literal(gregorianDate: date)
        XCTAssertEqual("2015-12-16T12:10:32.32+02:00", lit.stringValue)
        XCTAssertEqual("\"2015-12-16T12:10:32.32+02:00\"^^xsd:dateTime", lit.sparql)
        XCTAssertTrue(lit.dataType! == XSD.dateTime)
        XCTAssertNil(lit.language)
        XCTAssertNil(lit.longValue)
        lit = Literal(dateTimeValue: date)!
        XCTAssertEqual("2015-12-16T12:10:32.32+02:00", lit.stringValue)
        XCTAssertEqual("\"2015-12-16T12:10:32.32+02:00\"^^xsd:dateTime", lit.sparql)
        XCTAssertFalse(lit.dateValue!.isRecurring)
        
        date = GregorianDate(year: -2015, month: 12, day: 16, hour: 12, minute: 10, second: 32.32, timezone: NSTimeZone(forSecondsFromGMT: 7200))
        lit = Literal(gregorianDate: date)
        XCTAssertEqual("-2015-12-16T12:10:32.32+02:00", lit.stringValue)
        XCTAssertEqual("\"-2015-12-16T12:10:32.32+02:00\"^^xsd:dateTime", lit.sparql)
        lit = Literal(dateTimeValue: date)!
        XCTAssertEqual("-2015-12-16T12:10:32.32+02:00", lit.stringValue)
        XCTAssertEqual("\"-2015-12-16T12:10:32.32+02:00\"^^xsd:dateTime", lit.sparql)
        XCTAssertTrue(lit.dataType! == XSD.dateTime)
        XCTAssertNil(lit.language)
        XCTAssertNil(lit.longValue)
        XCTAssertFalse(lit.dateValue!.isRecurring)
    }
    
    func testDateTimeLiteralFromString(){
        var string = "2015-12-16T12:10:32.32+02:00"
        var lit = Literal(stringValue: string, dataType: XSD.dateTime)!
        XCTAssertEqual(string, lit.stringValue)
        XCTAssertEqual("\"\(string)\"^^xsd:dateTime", lit.sparql)
        XCTAssertTrue(lit.dataType! == XSD.dateTime)
        XCTAssertNil(lit.language)
        XCTAssertNil(lit.longValue)
        XCTAssertEqual(string, lit.dateValue?.dateTime)
        XCTAssertFalse(lit.dateValue!.isRecurring)
        
        string = "-2015-12-16T12:10:32.32+02:00"
        lit = Literal(stringValue: string, dataType: XSD.dateTime)!
        XCTAssertEqual(string, lit.stringValue)
        XCTAssertEqual("\"\(string)\"^^xsd:dateTime", lit.sparql)
        XCTAssertTrue(lit.dataType! == XSD.dateTime)
        XCTAssertNil(lit.language)
        XCTAssertNil(lit.longValue)
        XCTAssertEqual(string, lit.dateValue?.dateTime)
        XCTAssertFalse(lit.dateValue!.isRecurring)
        
        string = "-2015-12-16T12:10:32.32"
        lit = Literal(stringValue: string, dataType: XSD.dateTime)!
        XCTAssertEqual(string, lit.stringValue)
        XCTAssertEqual("\"\(string)\"^^xsd:dateTime", lit.sparql)
        XCTAssertTrue(lit.dataType! == XSD.dateTime)
        XCTAssertNil(lit.language)
        XCTAssertNil(lit.longValue)
        XCTAssertEqual(string, lit.dateValue?.dateTime)
        XCTAssertFalse(lit.dateValue!.isRecurring)
    }
    
    func testDateLiteral(){
        var date = GregorianDate(year: 2015, month: 12, day: 16, timezone: NSTimeZone(forSecondsFromGMT: 7200))
        var lit = Literal(gregorianDate: date)
        XCTAssertEqual("2015-12-16+02:00", lit.stringValue)
        XCTAssertEqual("\"2015-12-16+02:00\"^^xsd:date", lit.sparql)
        XCTAssertTrue(lit.dataType! == XSD.date)
        XCTAssertNil(lit.language)
        XCTAssertNil(lit.longValue)
        lit = Literal(dateValue: date)!
        XCTAssertEqual("2015-12-16+02:00", lit.stringValue)
        XCTAssertFalse(lit.dateValue!.isRecurring)
        XCTAssertEqual("\"2015-12-16+02:00\"^^xsd:date", lit.sparql)
        
        date = GregorianDate(year: -2015, month: 12, day: 16, timezone: NSTimeZone(forSecondsFromGMT: 7200))
        lit = Literal(gregorianDate: date)
        XCTAssertEqual("-2015-12-16+02:00", lit.stringValue)
        XCTAssertEqual("\"-2015-12-16+02:00\"^^xsd:date", lit.sparql)
        lit = Literal(dateValue: date)!
        XCTAssertEqual("-2015-12-16+02:00", lit.stringValue)
        XCTAssertEqual("\"-2015-12-16+02:00\"^^xsd:date", lit.sparql)
        XCTAssertTrue(lit.dataType! == XSD.date)
        XCTAssertNil(lit.language)
        XCTAssertNil(lit.longValue)
        XCTAssertFalse(lit.dateValue!.isRecurring)
    }
    
    func testDateLiteralFromString(){
        var string = "2015-12-16+02:00"
        var lit = Literal(stringValue: string, dataType: XSD.date)!
        XCTAssertEqual(string, lit.stringValue)
        XCTAssertEqual("\"\(string)\"^^xsd:date", lit.sparql)
        XCTAssertTrue(lit.dataType! == XSD.date)
        XCTAssertNil(lit.language)
        XCTAssertNil(lit.longValue)
        XCTAssertEqual(string, lit.dateValue?.date)
        XCTAssertFalse(lit.dateValue!.isRecurring)
        
        string = "-2015-12-16+02:00"
        lit = Literal(stringValue: string, dataType: XSD.date)!
        XCTAssertEqual(string, lit.stringValue)
        XCTAssertEqual("\"\(string)\"^^xsd:date", lit.sparql)
        XCTAssertTrue(lit.dataType! == XSD.date)
        XCTAssertNil(lit.language)
        XCTAssertNil(lit.longValue)
        XCTAssertEqual(string, lit.dateValue?.date)
        XCTAssertFalse(lit.dateValue!.isRecurring)
        
        string = "-2015-12-16"
        lit = Literal(stringValue: string, dataType: XSD.date)!
        XCTAssertEqual(string, lit.stringValue)
        XCTAssertEqual("\"\(string)\"^^xsd:date", lit.sparql)
        XCTAssertTrue(lit.dataType! == XSD.date)
        XCTAssertNil(lit.language)
        XCTAssertNil(lit.longValue)
        XCTAssertEqual(string, lit.dateValue?.date)
        XCTAssertFalse(lit.dateValue!.isRecurring)
    }
    
    func testgYearMonthLiteral(){
        var date = GregorianDate(year: 2015, month: 12, timezone: NSTimeZone(forSecondsFromGMT: 7200))
        var lit = Literal(gregorianDate: date)
        XCTAssertEqual("2015-12+02:00", lit.stringValue)
        XCTAssertEqual("\"2015-12+02:00\"^^xsd:gYearMonth", lit.sparql)
        XCTAssertTrue(lit.dataType! == XSD.gYearMonth)
        XCTAssertNil(lit.language)
        XCTAssertNil(lit.longValue)
        lit = Literal(gYearMonthValue: date)!
        XCTAssertEqual("2015-12+02:00", lit.stringValue)
        XCTAssertEqual("\"2015-12+02:00\"^^xsd:gYearMonth", lit.sparql)
        XCTAssertFalse(lit.dateValue!.isRecurring)
        
        date = GregorianDate(year: -2015, month: 12, timezone: NSTimeZone(forSecondsFromGMT: 7200))
        lit = Literal(gregorianDate: date)
        XCTAssertEqual("-2015-12+02:00", lit.stringValue)
        XCTAssertEqual("\"-2015-12+02:00\"^^xsd:gYearMonth", lit.sparql)
        lit = Literal(gYearMonthValue: date)!
        XCTAssertEqual("-2015-12+02:00", lit.stringValue)
        XCTAssertEqual("\"-2015-12+02:00\"^^xsd:gYearMonth", lit.sparql)
        XCTAssertTrue(lit.dataType! == XSD.gYearMonth)
        XCTAssertNil(lit.language)
        XCTAssertNil(lit.longValue)
        XCTAssertFalse(lit.dateValue!.isRecurring)
    }
    
    func testgYearMonthLiteralFromString(){
        var string = "2015-12+02:00"
        var lit = Literal(stringValue: string, dataType: XSD.gYearMonth)!
        XCTAssertEqual(string, lit.stringValue)
        XCTAssertEqual("\"\(string)\"^^xsd:gYearMonth", lit.sparql)
        XCTAssertTrue(lit.dataType! == XSD.gYearMonth)
        XCTAssertNil(lit.language)
        XCTAssertNil(lit.longValue)
        XCTAssertEqual(string, lit.dateValue?.gYearMonth)
        XCTAssertFalse(lit.dateValue!.isRecurring)
        
        string = "-2015-12+02:00"
        lit = Literal(stringValue: string, dataType: XSD.gYearMonth)!
        XCTAssertEqual(string, lit.stringValue)
        XCTAssertEqual("\"\(string)\"^^xsd:gYearMonth", lit.sparql)
        XCTAssertTrue(lit.dataType! == XSD.gYearMonth)
        XCTAssertNil(lit.language)
        XCTAssertNil(lit.longValue)
        XCTAssertEqual(string, lit.dateValue?.gYearMonth)
        XCTAssertFalse(lit.dateValue!.isRecurring)
        
        string = "-2015-12"
        lit = Literal(stringValue: string, dataType: XSD.gYearMonth)!
        XCTAssertEqual(string, lit.stringValue)
        XCTAssertEqual("\"\(string)\"^^xsd:gYearMonth", lit.sparql)
        XCTAssertTrue(lit.dataType! == XSD.gYearMonth)
        XCTAssertNil(lit.language)
        XCTAssertNil(lit.longValue)
        XCTAssertEqual(string, lit.dateValue?.gYearMonth)
        XCTAssertFalse(lit.dateValue!.isRecurring)
    }
    
    func testgYearLiteral(){
        var date = GregorianDate(year: 2015, timezone: NSTimeZone(forSecondsFromGMT: 7200))
        var lit = Literal(gregorianDate: date)
        XCTAssertEqual("2015+02:00", lit.stringValue)
        XCTAssertEqual("\"2015+02:00\"^^xsd:gYear", lit.sparql)
        XCTAssertTrue(lit.dataType! == XSD.gYear)
        XCTAssertNil(lit.language)
        XCTAssertNil(lit.longValue)
        lit = Literal(gYearValue: date)!
        XCTAssertEqual("2015+02:00", lit.stringValue)
        XCTAssertEqual("\"2015+02:00\"^^xsd:gYear", lit.sparql)
        XCTAssertFalse(lit.dateValue!.isRecurring)
        
        date = GregorianDate(year: -2015, timezone: NSTimeZone(forSecondsFromGMT: 7200))
        lit = Literal(gregorianDate: date)
        XCTAssertEqual("-2015+02:00", lit.stringValue)
        XCTAssertEqual("\"-2015+02:00\"^^xsd:gYear", lit.sparql)
        lit = Literal(gYearValue: date)!
        XCTAssertEqual("-2015+02:00", lit.stringValue)
        XCTAssertEqual("\"-2015+02:00\"^^xsd:gYear", lit.sparql)
        XCTAssertTrue(lit.dataType! == XSD.gYear)
        XCTAssertNil(lit.language)
        XCTAssertNil(lit.longValue)
        XCTAssertFalse(lit.dateValue!.isRecurring)
    }
    
    func testgYearLiteralFromString(){
        var string = "2015+02:00"
        var lit = Literal(stringValue: string, dataType: XSD.gYear)!
        XCTAssertEqual(string, lit.stringValue)
        XCTAssertEqual("\"\(string)\"^^xsd:gYear", lit.sparql)
        XCTAssertTrue(lit.dataType! == XSD.gYear)
        XCTAssertNil(lit.language)
        XCTAssertNil(lit.longValue)
        XCTAssertEqual(string, lit.dateValue?.gYear)
        XCTAssertFalse(lit.dateValue!.isRecurring)
        
        string = "-2015+02:00"
        lit = Literal(stringValue: string, dataType: XSD.gYear)!
        XCTAssertEqual(string, lit.stringValue)
        XCTAssertEqual("\"\(string)\"^^xsd:gYear", lit.sparql)
        XCTAssertTrue(lit.dataType! == XSD.gYear)
        XCTAssertNil(lit.language)
        XCTAssertNil(lit.longValue)
        XCTAssertEqual(string, lit.dateValue?.gYear)
        XCTAssertFalse(lit.dateValue!.isRecurring)
        
        string = "-2015"
        lit = Literal(stringValue: string, dataType: XSD.gYear)!
        XCTAssertEqual(string, lit.stringValue)
        XCTAssertEqual("\"\(string)\"^^xsd:gYear", lit.sparql)
        XCTAssertTrue(lit.dataType! == XSD.gYear)
        XCTAssertNil(lit.language)
        XCTAssertNil(lit.longValue)
        XCTAssertEqual(string, lit.dateValue?.gYear)
        XCTAssertFalse(lit.dateValue!.isRecurring)
    }
    
    func testTimeLiteral(){
        let date = GregorianDate(hour: 12, minute: 10, second: 32.32, timezone: NSTimeZone(forSecondsFromGMT: 7200))
        var lit = Literal(gregorianDate: date)
        XCTAssertEqual("12:10:32.32+02:00", lit.stringValue)
        XCTAssertEqual("\"12:10:32.32+02:00\"^^xsd:time", lit.sparql)
        XCTAssertTrue(lit.dataType! == XSD.time)
        XCTAssertNil(lit.language)
        XCTAssertNil(lit.longValue)
        XCTAssertTrue(lit.dateValue!.isRecurring)
        lit = Literal(timeValue: date)!
        XCTAssertEqual("12:10:32.32+02:00", lit.stringValue)
        XCTAssertEqual("\"12:10:32.32+02:00\"^^xsd:time", lit.sparql)
        XCTAssertTrue(lit.dateValue!.isRecurring)
    }
    
    func testTimeLiteralFromString(){
        var string = "12:10:32.32+02:00"
        var lit = Literal(stringValue: string, dataType: XSD.time)!
        XCTAssertTrue(lit.dateValue!.isRecurring)
        XCTAssertEqual(string, lit.stringValue)
        XCTAssertEqual("\"\(string)\"^^xsd:time", lit.sparql)
        XCTAssertTrue(lit.dataType! == XSD.time)
        XCTAssertNil(lit.language)
        XCTAssertNil(lit.longValue)
        XCTAssertEqual(string, lit.dateValue?.time)
        
        string = "06:10:32.32"
        lit = Literal(stringValue: string, dataType: XSD.time)!
        XCTAssertTrue(lit.dateValue!.isRecurring)
        XCTAssertEqual(string, lit.stringValue)
        XCTAssertEqual("\"\(string)\"^^xsd:time", lit.sparql)
        XCTAssertTrue(lit.dataType! == XSD.time)
        XCTAssertNil(lit.language)
        XCTAssertNil(lit.longValue)
        XCTAssertEqual(string, lit.dateValue?.time)
    }
    
    func testgMonthDayLiteral(){
        let date = GregorianDate(month: 4, day: 5, timezone: NSTimeZone(forSecondsFromGMT: -7200))
        var lit = Literal(gregorianDate: date)
        XCTAssertEqual("--04-05-02:00", lit.stringValue)
        XCTAssertEqual("\"--04-05-02:00\"^^xsd:gMonthDay", lit.sparql)
        XCTAssertTrue(lit.dataType! == XSD.gMonthDay)
        XCTAssertNil(lit.language)
        XCTAssertNil(lit.longValue)
        XCTAssertTrue(lit.dateValue!.isRecurring)
        lit = Literal(gMonthDayValue: date)!
        XCTAssertEqual("--04-05-02:00", lit.stringValue)
        XCTAssertEqual("\"--04-05-02:00\"^^xsd:gMonthDay", lit.sparql)
        XCTAssertTrue(lit.dateValue!.isRecurring)
    }
    
    func testgMonthDayLiteralFromString(){
        var string = "--04-05-02:00"
        var lit = Literal(stringValue: string, dataType: XSD.gMonthDay)!
        XCTAssertTrue(lit.dateValue!.isRecurring)
        XCTAssertEqual(string, lit.stringValue)
        XCTAssertEqual("\"\(string)\"^^xsd:gMonthDay", lit.sparql)
        XCTAssertTrue(lit.dataType! == XSD.gMonthDay)
        XCTAssertNil(lit.language)
        XCTAssertNil(lit.longValue)
        XCTAssertEqual(string, lit.dateValue?.gMonthDay)
        
        string = "--04-05"
        lit = Literal(stringValue: string, dataType: XSD.gMonthDay)!
        XCTAssertTrue(lit.dateValue!.isRecurring)
        XCTAssertEqual(string, lit.stringValue)
        XCTAssertEqual("\"\(string)\"^^xsd:gMonthDay", lit.sparql)
        XCTAssertTrue(lit.dataType! == XSD.gMonthDay)
        XCTAssertNil(lit.language)
        XCTAssertNil(lit.longValue)
        XCTAssertEqual(string, lit.dateValue?.gMonthDay)
    }
    
    func testgMonthLiteral(){
        let date = GregorianDate(month: 4, timezone: NSTimeZone(forSecondsFromGMT: -7200))
        var lit = Literal(gregorianDate: date)
        XCTAssertEqual("--04-02:00", lit.stringValue)
        XCTAssertEqual("\"--04-02:00\"^^xsd:gMonth", lit.sparql)
        XCTAssertTrue(lit.dataType! == XSD.gMonth)
        XCTAssertNil(lit.language)
        XCTAssertNil(lit.longValue)
        XCTAssertTrue(lit.dateValue!.isRecurring)
        lit = Literal(gMonthValue: date)!
        XCTAssertEqual("--04-02:00", lit.stringValue)
        XCTAssertEqual("\"--04-02:00\"^^xsd:gMonth", lit.sparql)
        XCTAssertTrue(lit.dateValue!.isRecurring)
    }
    
    func testgMonthLiteralFromString(){
        var string = "--04-02:00"
        var lit = Literal(stringValue: string, dataType: XSD.gMonth)!
        XCTAssertTrue(lit.dateValue!.isRecurring)
        XCTAssertEqual(string, lit.stringValue)
        XCTAssertEqual("\"\(string)\"^^xsd:gMonth", lit.sparql)
        XCTAssertTrue(lit.dataType! == XSD.gMonth)
        XCTAssertNil(lit.language)
        XCTAssertNil(lit.longValue)
        XCTAssertEqual(string, lit.dateValue?.gMonth)
        
        string = "--04"
        lit = Literal(stringValue: string, dataType: XSD.gMonth)!
        XCTAssertTrue(lit.dateValue!.isRecurring)
        XCTAssertEqual(string, lit.stringValue)
        XCTAssertEqual("\"\(string)\"^^xsd:gMonth", lit.sparql)
        XCTAssertTrue(lit.dataType! == XSD.gMonth)
        XCTAssertNil(lit.language)
        XCTAssertNil(lit.longValue)
        XCTAssertEqual(string, lit.dateValue?.gMonth)
    }
    
    func testgDayLiteral(){
        let date = GregorianDate(day: 4, timezone: NSTimeZone(forSecondsFromGMT: -7200))
        var lit = Literal(gregorianDate: date)
        XCTAssertEqual("---04-02:00", lit.stringValue)
        XCTAssertEqual("\"---04-02:00\"^^xsd:gDay", lit.sparql)
        XCTAssertTrue(lit.dataType! == XSD.gDay)
        XCTAssertNil(lit.language)
        XCTAssertNil(lit.longValue)
        XCTAssertTrue(lit.dateValue!.isRecurring)
        lit = Literal(gDayValue: date)!
        XCTAssertEqual("---04-02:00", lit.stringValue)
        XCTAssertEqual("\"---04-02:00\"^^xsd:gDay", lit.sparql)
        XCTAssertTrue(lit.dateValue!.isRecurring)
    }
    
    func testgDayLiteralFromString(){
        var string = "---04-02:00"
        var lit = Literal(stringValue: string, dataType: XSD.gDay)!
        XCTAssertTrue(lit.dateValue!.isRecurring)
        XCTAssertEqual(string, lit.stringValue)
        XCTAssertEqual("\"\(string)\"^^xsd:gDay", lit.sparql)
        XCTAssertTrue(lit.dataType! == XSD.gDay)
        XCTAssertNil(lit.language)
        XCTAssertNil(lit.longValue)
        XCTAssertEqual(string, lit.dateValue?.gDay)
        
        string = "---04"
        lit = Literal(stringValue: string, dataType: XSD.gDay)!
        XCTAssertTrue(lit.dateValue!.isRecurring)
        XCTAssertEqual(string, lit.stringValue)
        XCTAssertEqual("\"\(string)\"^^xsd:gDay", lit.sparql)
        XCTAssertTrue(lit.dataType! == XSD.gDay)
        XCTAssertNil(lit.language)
        XCTAssertNil(lit.longValue)
        XCTAssertEqual(string, lit.dateValue?.gDay)
    }
    
    func testDateLiteralComparissons(){
        var lit1 = Literal(stringValue: "1986-10-04-02:00", dataType: XSD.date)!
        var lit2 = Literal(stringValue: "1986-10-04-02:00", dataType: XSD.date)!
        var comparisson = lit1 == lit2
        XCTAssertNotNil(comparisson)
        XCTAssertTrue(comparisson!)
        comparisson = lit1 > lit2
        XCTAssertNotNil(comparisson)
        XCTAssertFalse(comparisson!)
        comparisson = lit1 < lit2
        XCTAssertNotNil(comparisson)
        XCTAssertFalse(comparisson!)
        comparisson = lit1 >= lit2
        XCTAssertNotNil(comparisson)
        XCTAssertTrue(comparisson!)
        comparisson = lit1 <= lit2
        XCTAssertNotNil(comparisson)
        XCTAssertTrue(comparisson!)
        lit2 = Literal(stringValue: "1986-10-05-02:00", dataType: XSD.date)!
        comparisson = lit1 == lit2
        XCTAssertNotNil(comparisson)
        XCTAssertFalse(comparisson!)
        comparisson = lit1 > lit2
        XCTAssertNotNil(comparisson)
        XCTAssertFalse(comparisson!)
        comparisson = lit1 < lit2
        XCTAssertNotNil(comparisson)
        XCTAssertTrue(comparisson!)
        comparisson = lit1 >= lit2
        XCTAssertNotNil(comparisson)
        XCTAssertFalse(comparisson!)
        comparisson = lit1 <= lit2
        XCTAssertNotNil(comparisson)
        XCTAssertTrue(comparisson!)
        lit2 = Literal(stringValue: "1986-10-03-02:00", dataType: XSD.date)!
        comparisson = lit1 == lit2
        XCTAssertNotNil(comparisson)
        XCTAssertFalse(comparisson!)
        comparisson = lit1 > lit2
        XCTAssertNotNil(comparisson)
        XCTAssertTrue(comparisson!)
        comparisson = lit1 < lit2
        XCTAssertNotNil(comparisson)
        XCTAssertFalse(comparisson!)
        comparisson = lit1 >= lit2
        XCTAssertNotNil(comparisson)
        XCTAssertTrue(comparisson!)
        comparisson = lit1 <= lit2
        XCTAssertNotNil(comparisson)
        XCTAssertFalse(comparisson!)
        
        lit1 = Literal(stringValue: "1986-10-04T12:15:02-02:00", dataType: XSD.dateTime)!
        lit2 = Literal(stringValue: "1986-10-04T12:15:02-02:00", dataType: XSD.dateTime)!
        comparisson = lit1 == lit2
        XCTAssertNotNil(comparisson)
        XCTAssertTrue(comparisson!)
        comparisson = lit1 > lit2
        XCTAssertNotNil(comparisson)
        XCTAssertFalse(comparisson!)
        comparisson = lit1 < lit2
        XCTAssertNotNil(comparisson)
        XCTAssertFalse(comparisson!)
        comparisson = lit1 >= lit2
        XCTAssertNotNil(comparisson)
        XCTAssertTrue(comparisson!)
        comparisson = lit1 <= lit2
        XCTAssertNotNil(comparisson)
        XCTAssertTrue(comparisson!)
        lit2 = Literal(stringValue: "1986-10-04T16:15:02+02:00", dataType: XSD.dateTime)!
        comparisson = lit1 == lit2
        XCTAssertNotNil(comparisson)
        XCTAssertTrue(comparisson!)
        XCTAssertTrue(comparisson!)
        comparisson = lit1 > lit2
        XCTAssertNotNil(comparisson)
        XCTAssertFalse(comparisson!)
        comparisson = lit1 < lit2
        XCTAssertNotNil(comparisson)
        XCTAssertFalse(comparisson!)
        comparisson = lit1 >= lit2
        XCTAssertNotNil(comparisson)
        XCTAssertTrue(comparisson!)
        comparisson = lit1 <= lit2
        XCTAssertNotNil(comparisson)
        XCTAssertTrue(comparisson!)
        lit2 = Literal(stringValue: "1986-10-05T02:15:02+12:00", dataType: XSD.dateTime)!
        comparisson = lit1 == lit2
        XCTAssertNotNil(comparisson)
        XCTAssertTrue(comparisson!)
        comparisson = lit1 > lit2
        XCTAssertNotNil(comparisson)
        XCTAssertFalse(comparisson!)
        comparisson = lit1 < lit2
        XCTAssertNotNil(comparisson)
        XCTAssertFalse(comparisson!)
        comparisson = lit1 >= lit2
        XCTAssertNotNil(comparisson)
        XCTAssertTrue(comparisson!)
        comparisson = lit1 <= lit2
        XCTAssertNotNil(comparisson)
        XCTAssertTrue(comparisson!)
        lit2 = Literal(stringValue: "1986-10-04T12:15:03-02:00", dataType: XSD.dateTime)!
        comparisson = lit1 == lit2
        XCTAssertNotNil(comparisson)
        XCTAssertFalse(comparisson!)
        comparisson = lit1 > lit2
        XCTAssertNotNil(comparisson)
        XCTAssertFalse(comparisson!)
        comparisson = lit1 < lit2
        XCTAssertNotNil(comparisson)
        XCTAssertTrue(comparisson!)
        comparisson = lit1 >= lit2
        XCTAssertNotNil(comparisson)
        XCTAssertFalse(comparisson!)
        comparisson = lit1 <= lit2
        XCTAssertNotNil(comparisson)
        XCTAssertTrue(comparisson!)
        lit2 = Literal(stringValue: "1986-10-04T12:15:01-02:00", dataType: XSD.dateTime)!
        comparisson = lit1 == lit2
        XCTAssertNotNil(comparisson)
        XCTAssertFalse(comparisson!)
        comparisson = lit1 > lit2
        XCTAssertNotNil(comparisson)
        XCTAssertTrue(comparisson!)
        comparisson = lit1 < lit2
        XCTAssertNotNil(comparisson)
        XCTAssertFalse(comparisson!)
        comparisson = lit1 >= lit2
        XCTAssertNotNil(comparisson)
        XCTAssertTrue(comparisson!)
        comparisson = lit1 <= lit2
        XCTAssertNotNil(comparisson)
        XCTAssertFalse(comparisson!)
    }
    
    func testDurationLiteralComparissons(){
        var lit1 = Literal(stringValue: "P2Y", dataType: XSD.duration)!
        var lit2 = Literal(stringValue: "P24M", dataType: XSD.duration)!
        var comparisson = lit1 == lit2
        XCTAssertNotNil(comparisson)
        XCTAssertTrue(comparisson!)
        comparisson = lit1 > lit2
        XCTAssertNotNil(comparisson)
        XCTAssertFalse(comparisson!)
        comparisson = lit1 < lit2
        XCTAssertNotNil(comparisson)
        XCTAssertFalse(comparisson!)
        comparisson = lit1 >= lit2
        XCTAssertNotNil(comparisson)
        XCTAssertTrue(comparisson!)
        comparisson = lit1 <= lit2
        XCTAssertNotNil(comparisson)
        XCTAssertTrue(comparisson!)
        lit2 = Literal(stringValue: "P1Y12M", dataType: XSD.duration)!
        comparisson = lit1 == lit2
        XCTAssertNotNil(comparisson)
        XCTAssertTrue(comparisson!)
        comparisson = lit1 > lit2
        XCTAssertNotNil(comparisson)
        XCTAssertFalse(comparisson!)
        comparisson = lit1 < lit2
        XCTAssertNotNil(comparisson)
        XCTAssertFalse(comparisson!)
        comparisson = lit1 >= lit2
        XCTAssertNotNil(comparisson)
        XCTAssertTrue(comparisson!)
        comparisson = lit1 <= lit2
        XCTAssertNotNil(comparisson)
        XCTAssertTrue(comparisson!)
        lit2 = Literal(stringValue: "P1Y11M31D", dataType: XSD.duration)!
        comparisson = lit1 == lit2
        XCTAssertNil(comparisson)
        comparisson = lit1 > lit2
        XCTAssertNil(comparisson)
        comparisson = lit1 < lit2
        XCTAssertNil(comparisson)
        comparisson = lit1 <= lit2
        XCTAssertNil(comparisson)
        comparisson = lit1 >= lit2
        XCTAssertNil(comparisson)
        lit2 = Literal(stringValue: "P1Y13M", dataType: XSD.duration)!
        comparisson = lit1 == lit2
        XCTAssertNotNil(comparisson)
        XCTAssertFalse(comparisson!)
        comparisson = lit1 > lit2
        XCTAssertNotNil(comparisson)
        XCTAssertFalse(comparisson!)
        comparisson = lit1 < lit2
        XCTAssertNotNil(comparisson)
        XCTAssertTrue(comparisson!)
        comparisson = lit1 >= lit2
        XCTAssertNotNil(comparisson)
        XCTAssertFalse(comparisson!)
        comparisson = lit1 <= lit2
        XCTAssertNotNil(comparisson)
        XCTAssertTrue(comparisson!)
        lit2 = Literal(stringValue: "P1Y11M15D", dataType: XSD.duration)!
        comparisson = lit1 == lit2
        XCTAssertNotNil(comparisson)
        XCTAssertFalse(comparisson!)
        comparisson = lit1 > lit2
        XCTAssertNotNil(comparisson)
        XCTAssertTrue(comparisson!)
        comparisson = lit1 < lit2
        XCTAssertNotNil(comparisson)
        XCTAssertFalse(comparisson!)
        comparisson = lit1 >= lit2
        XCTAssertNotNil(comparisson)
        XCTAssertTrue(comparisson!)
        comparisson = lit1 <= lit2
        XCTAssertNotNil(comparisson)
        XCTAssertFalse(comparisson!)
        
        lit1 = Literal(stringValue: "P10D", dataType: XSD.duration)!
        lit2 = Literal(stringValue: "PT240H", dataType: XSD.duration)!
        comparisson = lit1 == lit2
        XCTAssertNotNil(comparisson)
        XCTAssertTrue(comparisson!)
        comparisson = lit1 == lit2
        XCTAssertNotNil(comparisson)
        XCTAssertTrue(comparisson!)
        comparisson = lit1 > lit2
        XCTAssertNotNil(comparisson)
        XCTAssertFalse(comparisson!)
        comparisson = lit1 < lit2
        XCTAssertNotNil(comparisson)
        XCTAssertFalse(comparisson!)
        comparisson = lit1 >= lit2
        XCTAssertNotNil(comparisson)
        XCTAssertTrue(comparisson!)
        comparisson = lit1 <= lit2
        XCTAssertNotNil(comparisson)
        XCTAssertTrue(comparisson!)
    }
}
