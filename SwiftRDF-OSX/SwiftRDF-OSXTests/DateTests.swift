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
    
    func testDateTime() {
        var string = "2012-03-12T12:23:54Z"
        var gdate = GregorianDate(dateTime: string)
        XCTAssertEqual(string, gdate?.dateTime)
        string = "2012-03-12T12:23:54+02:00"
        gdate = GregorianDate(dateTime: string)
        XCTAssertEqual(string, gdate?.dateTime)
        string = "2012-03-12T12:23:54-08:30"
        gdate = GregorianDate(dateTime: string)
        XCTAssertEqual(string, gdate?.dateTime)
        string = "2012-03-12T12:23:54-10:30"
        gdate = GregorianDate(dateTime: string)
        XCTAssertEqual(string, gdate?.dateTime)
        string = "-1203-03-12T12:23:54+02:00"
        gdate = GregorianDate(dateTime: string)
        XCTAssertEqual(string, gdate?.dateTime)
    }
    
    func testDate() {
        var string = "2012-03-12Z"
        var gdate = GregorianDate(date: string)
        XCTAssertEqual(string, gdate?.date)
        string = "2012-03-12+02:00"
        gdate = GregorianDate(date: string)
        XCTAssertEqual(string, gdate?.date)
        string = "2012-03-12-08:30"
        gdate = GregorianDate(date: string)
        XCTAssertEqual(string, gdate?.date)
        string = "2012-03-12-10:30"
        gdate = GregorianDate(date: string)
        XCTAssertEqual(string, gdate?.date)
        string = "-1203-03-12+02:00"
        gdate = GregorianDate(date: string)
        XCTAssertEqual(string, gdate?.date)
    }
    
    func testgYearMonth() {
        var string = "2012-03Z"
        var gdate = GregorianDate(gYearMonth: string)
        XCTAssertEqual(string, gdate?.gYearMonth)
        string = "2012-03+02:00"
        gdate = GregorianDate(gYearMonth: string)
        XCTAssertEqual(string, gdate?.gYearMonth)
        string = "2012-03-08:30"
        gdate = GregorianDate(gYearMonth: string)
        XCTAssertEqual(string, gdate?.gYearMonth)
        string = "2012-03-10:30"
        gdate = GregorianDate(gYearMonth: string)
        XCTAssertEqual(string, gdate?.gYearMonth)
        string = "-1203-03+02:00"
        gdate = GregorianDate(gYearMonth: string)
        XCTAssertEqual(string, gdate?.gYearMonth)
    }
    
    func testgYear() {
        var string = "2012Z"
        var gdate = GregorianDate(gYear: string)
        XCTAssertEqual(string, gdate?.gYear)
        string = "2012+02:00"
        gdate = GregorianDate(gYear: string)
        XCTAssertEqual(string, gdate?.gYear)
        string = "2012-08:30"
        gdate = GregorianDate(gYear: string)
        XCTAssertEqual(string, gdate?.gYear)
        string = "2012-10:30"
        gdate = GregorianDate(gYear: string)
        XCTAssertEqual(string, gdate?.gYear)
        string = "-1203+02:00"
        gdate = GregorianDate(gYear: string)
        XCTAssertEqual(string, gdate?.gYear)
    }
}


