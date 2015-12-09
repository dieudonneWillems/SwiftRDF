//
//  NSDateTests.swift
//  SwiftRDF-OSX
//
//  Created by Don Willems on 08/12/15.
//  Copyright © 2015 lapsedpacifist. All rights reserved.
//

import Foundation

import XCTest
@testable import SwiftRDFOSX

class DateTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testXSDStringCreation() {
        var date = GregorianDate(dateTime: "2002-10-10T12:00:00Z")!
        XCTAssertTrue(1034251200.0 == date.timeIntervalSince1970)
        date = GregorianDate(dateTime: "2002-10-10T12:00:00-05:00")!
        XCTAssertTrue(1034269200.0 == date.timeIntervalSince1970)
        date = GregorianDate(dateTime: "2002-02-10T12:00:00-05:00")!
        XCTAssertTrue(1013360400.0 == date.timeIntervalSince1970)
        XCTAssertTrue(35053200.0 == date.timeIntervalSinceReferenceDate)
        print("ref date: \(date.timeIntervalSinceReferenceDate)")
        var testdate = NSDate(timeIntervalSince1970:1013360400.0)
        print("date 1: \(testdate)")
        testdate = NSDate(timeIntervalSinceReferenceDate:35053200.0)
        print("date 2: \(testdate)")
    }
    
    func testXSDStringDateTimeRepresentation() {
        var date = GregorianDate(timeIntervalSince1970: 1034251200.0)
        XCTAssertEqual("2002-10-10T12:00:00Z", date.dateTime)
        XCTAssertEqual("2002-10-10Z", date.date)
        XCTAssertEqual("2002-10Z", date.gYearMonth)
        XCTAssertEqual("2002Z", date.gYear)
        date = GregorianDate(timeIntervalSince1970: 1034269200.0)
        XCTAssertEqual("2002-10-10T17:00:00Z", date.dateTime)
        XCTAssertEqual("2002-10-10Z", date.date)
        XCTAssertEqual("2002-10Z", date.gYearMonth)
        XCTAssertEqual("2002Z", date.gYear)
        date = GregorianDate(timeIntervalSince1970: 1013360400.0)
        XCTAssertEqual("2002-02-10T17:00:00Z", date.dateTime)
        XCTAssertEqual("2002-02-10Z", date.date)
        XCTAssertEqual("2002-02Z", date.gYearMonth)
        XCTAssertEqual("2002Z", date.gYear)
        date = GregorianDate(timeIntervalSinceReferenceDate: 35053200.0)
        XCTAssertEqual("2002-02-10T17:00:00Z", date.dateTime)
        XCTAssertEqual("2002-02-10Z", date.date)
        XCTAssertEqual("2002-02Z", date.gYearMonth)
        XCTAssertEqual("2002Z", date.gYear)
    }
    
    func testXSDDateStringCreation() {
        var date = GregorianDate(date: "2002-10-10Z")!
        XCTAssertEqual("2002-10-10T00:00:00Z", date.dateTime)
        XCTAssertEqual("2002-10-10Z", date.date)
        XCTAssertEqual("2002-10Z", date.gYearMonth)
        XCTAssertEqual("2002Z", date.gYear)
        date = GregorianDate(date: "1254-10-03-05:00")!
        XCTAssertEqual("1254-10-03T00:00:00-05:00", date.dateTime)
        XCTAssertEqual("1254-10-03-05:00", date.date)
        XCTAssertEqual("1254-10-05:00", date.gYearMonth)
        XCTAssertEqual("1254-05:00", date.gYear)
    }
    
    func testXSDgYearMonthStringCreation() {
        var date = GregorianDate(gYearMonth: "2002-10Z")!
        XCTAssertEqual("2002-10-01T00:00:00Z", date.dateTime)
        XCTAssertEqual("2002-10-01Z", date.date)
        XCTAssertEqual("2002-10Z", date.gYearMonth)
        XCTAssertEqual("2002Z", date.gYear)
        date = GregorianDate(gYearMonth: "1254-10-05:00")!
        XCTAssertEqual("1254-10-01T00:00:00-05:00", date.dateTime)
        XCTAssertEqual("1254-10-01-05:00", date.date)
        XCTAssertEqual("1254-10-05:00", date.gYearMonth)
        XCTAssertEqual("1254-05:00", date.gYear)
    }
    
    func testXSDgYearStringCreation() {
        var date = GregorianDate(gYear: "2002Z")!
        XCTAssertEqual("2002-01-01T00:00:00Z", date.dateTime)
        XCTAssertEqual("2002-01-01Z", date.date)
        XCTAssertEqual("2002-01Z", date.gYearMonth)
        XCTAssertEqual("2002Z", date.gYear)
        date = GregorianDate(gYear: "1254-05:00")!
        XCTAssertEqual("1254-01-01T00:00:00-05:00", date.dateTime)
        XCTAssertEqual("1254-01-01-05:00", date.date)
        XCTAssertEqual("1254-01-05:00", date.gYearMonth)
        XCTAssertEqual("1254-05:00", date.gYear)
    }
}


