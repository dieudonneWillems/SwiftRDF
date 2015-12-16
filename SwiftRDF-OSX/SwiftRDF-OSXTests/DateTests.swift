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
        var gdate2 = GregorianDate(year: (gdate?.year)!, month: (gdate?.month)!, day: (gdate?.day)!, hour: (gdate?.hour)!, minute: (gdate?.minute)!, second: (gdate?.second)!, timezone: (gdate?.timezone)!)
        XCTAssertEqual(string, gdate2.dateTime)
        string = "2012-03-12T12:23:54+02:00"
        gdate = GregorianDate(dateTime: string)
        XCTAssertEqual(string, gdate?.dateTime)
        gdate2 = GregorianDate(year: (gdate?.year)!, month: (gdate?.month)!, day: (gdate?.day)!, hour: (gdate?.hour)!, minute: (gdate?.minute)!, second: (gdate?.second)!, timezone: (gdate?.timezone)!)
        XCTAssertEqual(string, gdate2.dateTime)
        string = "2012-03-12T12:23:54-08:30"
        gdate = GregorianDate(dateTime: string)
        XCTAssertEqual(string, gdate?.dateTime)
        gdate2 = GregorianDate(year: (gdate?.year)!, month: (gdate?.month)!, day: (gdate?.day)!, hour: (gdate?.hour)!, minute: (gdate?.minute)!, second: (gdate?.second)!, timezone: (gdate?.timezone)!)
        XCTAssertEqual(string, gdate2.dateTime)
        string = "2012-03-12T12:23:54-10:30"
        gdate = GregorianDate(dateTime: string)
        XCTAssertEqual(string, gdate?.dateTime)
        gdate2 = GregorianDate(year: (gdate?.year)!, month: (gdate?.month)!, day: (gdate?.day)!, hour: (gdate?.hour)!, minute: (gdate?.minute)!, second: (gdate?.second)!, timezone: (gdate?.timezone)!)
        XCTAssertEqual(string, gdate!.dateTime)
        string = "-1203-03-12T12:23:54+02:00"
        gdate = GregorianDate(dateTime: string)
        XCTAssertEqual(string, gdate!.dateTime)
        gdate2 = GregorianDate(year: (gdate?.year)!, month: (gdate?.month)!, day: (gdate?.day)!, hour: (gdate?.hour)!, minute: (gdate?.minute)!, second: (gdate?.second)!, timezone: (gdate?.timezone)!)
        XCTAssertEqual(string, gdate2.dateTime)
        string = "-1203-03-12T12:23:54.983244+02:00"
        gdate = GregorianDate(dateTime: string)
        XCTAssertEqual(string, gdate!.dateTime)
        gdate2 = GregorianDate(year: (gdate?.year)!, month: (gdate?.month)!, day: (gdate?.day)!, hour: (gdate?.hour)!, minute: (gdate?.minute)!, second: (gdate?.second)!, timezone: (gdate?.timezone)!)
        XCTAssertEqual(string, gdate2.dateTime)
        string = "-1203-03-12T12:23:54.983244"
        gdate = GregorianDate(dateTime: string)
        XCTAssertEqual(string, gdate!.dateTime)
        gdate2 = GregorianDate(year: (gdate?.year)!, month: (gdate?.month)!, day: (gdate?.day)!, hour: (gdate?.hour)!, minute: (gdate?.minute)!, second: (gdate?.second)!, timezone: (gdate?.timezone))
        XCTAssertEqual(string, gdate2.dateTime)
    }
    
    func testDate() {
        var string = "2012-03-12Z"
        var gdate = GregorianDate(date: string)
        XCTAssertEqual(string, gdate?.date)
        var gdate2 = GregorianDate(year: (gdate?.year)!, month: (gdate?.month)!, day: (gdate?.day)!, timezone: (gdate?.timezone)!)
        XCTAssertEqual(string, gdate2.date)
        string = "2012-03-12+02:00"
        gdate = GregorianDate(date: string)
        XCTAssertEqual(string, gdate?.date)
        gdate2 = GregorianDate(year: (gdate?.year)!, month: (gdate?.month)!, day: (gdate?.day)!, timezone: (gdate?.timezone)!)
        XCTAssertEqual(string, gdate2.date)
        string = "2012-03-12-08:30"
        gdate = GregorianDate(date: string)
        XCTAssertEqual(string, gdate?.date)
        gdate2 = GregorianDate(year: (gdate?.year)!, month: (gdate?.month)!, day: (gdate?.day)!, timezone: (gdate?.timezone)!)
        XCTAssertEqual(string, gdate2.date)
        string = "2012-03-12-10:30"
        gdate = GregorianDate(date: string)
        XCTAssertEqual(string, gdate?.date)
        gdate2 = GregorianDate(year: (gdate?.year)!, month: (gdate?.month)!, day: (gdate?.day)!, timezone: (gdate?.timezone)!)
        XCTAssertEqual(string, gdate2.date)
        string = "-1203-03-12+02:00"
        gdate = GregorianDate(date: string)
        XCTAssertEqual(string, gdate!.date)
        gdate2 = GregorianDate(year: (gdate?.year)!, month: (gdate?.month)!, day: (gdate?.day)!, timezone: (gdate?.timezone)!)
        XCTAssertEqual(string, gdate2.date)
        string = "-1203-03-12"
        gdate = GregorianDate(date: string)
        XCTAssertEqual(string, gdate!.date)
        gdate2 = GregorianDate(year: (gdate?.year)!, month: (gdate?.month)!, day: (gdate?.day)!, timezone: (gdate?.timezone))
        XCTAssertEqual(string, gdate2.date)
    }
    
    func testgYearMonth() {
        var string = "2012-03Z"
        var gdate = GregorianDate(gYearMonth: string)
        XCTAssertEqual(string, gdate?.gYearMonth)
        var gdate2 = GregorianDate(year: (gdate?.year)!, month: (gdate?.month)!, timezone: (gdate?.timezone)!)
        XCTAssertEqual(string, gdate2.gYearMonth)
        string = "2012-03+02:00"
        gdate = GregorianDate(gYearMonth: string)
        XCTAssertEqual(string, gdate?.gYearMonth)
        gdate2 = GregorianDate(year: (gdate?.year)!, month: (gdate?.month)!, timezone: (gdate?.timezone)!)
        XCTAssertEqual(string, gdate2.gYearMonth)
        string = "2012-03-08:30"
        gdate = GregorianDate(gYearMonth: string)
        XCTAssertEqual(string, gdate?.gYearMonth)
        gdate2 = GregorianDate(year: (gdate?.year)!, month: (gdate?.month)!, timezone: (gdate?.timezone)!)
        XCTAssertEqual(string, gdate2.gYearMonth)
        string = "2012-03-10:30"
        gdate = GregorianDate(gYearMonth: string)
        XCTAssertEqual(string, gdate?.gYearMonth)
        gdate2 = GregorianDate(year: (gdate?.year)!, month: (gdate?.month)!, timezone: (gdate?.timezone)!)
        XCTAssertEqual(string, gdate2.gYearMonth)
        string = "-1203-03+02:00"
        gdate = GregorianDate(gYearMonth: string)
        XCTAssertEqual(string, gdate?.gYearMonth)
        gdate2 = GregorianDate(year: (gdate?.year)!, month: (gdate?.month)!, timezone: (gdate?.timezone)!)
        XCTAssertEqual(string, gdate2.gYearMonth)
    }
    
    func testgYear() {
        var string = "2012Z"
        var gdate = GregorianDate(gYear: string)
        XCTAssertEqual(string, gdate?.gYear)
        var gdate2 = GregorianDate(year: (gdate?.year)!, timezone: (gdate?.timezone)!)
        XCTAssertEqual(string, gdate2.gYear)
        string = "2012+02:00"
        gdate = GregorianDate(gYear: string)
        XCTAssertEqual(string, gdate?.gYear)
        gdate2 = GregorianDate(year: (gdate?.year)!, timezone: (gdate?.timezone)!)
        XCTAssertEqual(string, gdate2.gYear)
        string = "2012-08:30"
        gdate = GregorianDate(gYear: string)
        XCTAssertEqual(string, gdate?.gYear)
        gdate2 = GregorianDate(year: (gdate?.year)!, timezone: (gdate?.timezone)!)
        XCTAssertEqual(string, gdate2.gYear)
        string = "2012-10:30"
        gdate = GregorianDate(gYear: string)
        XCTAssertEqual(string, gdate?.gYear)
        gdate2 = GregorianDate(year: (gdate?.year)!, timezone: (gdate?.timezone)!)
        XCTAssertEqual(string, gdate2.gYear)
        string = "-1203+02:00"
        gdate = GregorianDate(gYear: string)
        XCTAssertEqual(string, gdate?.gYear)
        gdate2 = GregorianDate(year: (gdate?.year)!, timezone: (gdate?.timezone)!)
        XCTAssertEqual(string, gdate2.gYear)
    }
    
    func testDateTimeDateValue() {
        var string = "2015-12-13T19:39:32.233+02:00"
        var gdate = GregorianDate(dateTime: string)
        var sdate = gdate!.startDate
        XCTAssertTrue(1450028372.233 == sdate!.timeIntervalSince1970)
        var edate = gdate!.endDate
        XCTAssertTrue(1450028372.233 == edate!.timeIntervalSince1970)
        string = "2015-12-13+02:00"
        gdate = GregorianDate(date: string)
        sdate = gdate!.startDate
        XCTAssertTrue(1449957600.0 == sdate!.timeIntervalSince1970)
        edate = gdate!.endDate
        XCTAssertTrue(1449957600.0+24*3600 == edate!.timeIntervalSince1970)
    }
    
    func testTime() {
        var string = "12:23:54Z"
        var gdate = GregorianDate(time: string)
        XCTAssertEqual(string, gdate?.time)
        XCTAssertTrue(gdate!.isRecurring)
        var gdate2 = GregorianDate(year: (gdate?.year), month: (gdate?.month), day: (gdate?.day), hour: (gdate?.hour), minute: (gdate?.minute), second: (gdate?.second), timezone: (gdate?.timezone)!)
        XCTAssertEqual(string, gdate2.time)
        string = "12:23:54+02:00"
        gdate = GregorianDate(time: string)
        XCTAssertEqual(string, gdate?.time)
        XCTAssertTrue(gdate!.isRecurring)
        gdate2 = GregorianDate(year: (gdate?.year), month: (gdate?.month), day: (gdate?.day), hour: (gdate?.hour), minute: (gdate?.minute), second: (gdate?.second), timezone: (gdate?.timezone)!)
        XCTAssertEqual(string, gdate2.time)
        string = "12:23:54-08:30"
        gdate = GregorianDate(time: string)
        XCTAssertEqual(string, gdate?.time)
        XCTAssertTrue(gdate!.isRecurring)
        gdate2 = GregorianDate(year: (gdate?.year), month: (gdate?.month), day: (gdate?.day), hour: (gdate?.hour)!, minute: (gdate?.minute)!, second: (gdate?.second)!, timezone: (gdate?.timezone)!)
        XCTAssertEqual(string, gdate2.time)
        string = "12:23:54-10:30"
        gdate = GregorianDate(time: string)
        XCTAssertEqual(string, gdate?.time)
        XCTAssertTrue(gdate!.isRecurring)
        gdate2 = GregorianDate(year: (gdate?.year), month: (gdate?.month), day: (gdate?.day), hour: (gdate?.hour)!, minute: (gdate?.minute)!, second: (gdate?.second)!, timezone: (gdate?.timezone)!)
        XCTAssertEqual(string, gdate!.time)
        string = "12:23:54+02:00"
        gdate = GregorianDate(time: string)
        XCTAssertEqual(string, gdate!.time)
        XCTAssertTrue(gdate!.isRecurring)
        gdate2 = GregorianDate(year: (gdate?.year), month: (gdate?.month), day: (gdate?.day), hour: (gdate?.hour)!, minute: (gdate?.minute)!, second: (gdate?.second)!, timezone: (gdate?.timezone)!)
        XCTAssertEqual(string, gdate2.time)
        string = "12:23:54.983244+02:00"
        gdate = GregorianDate(time: string)
        XCTAssertEqual(string, gdate!.time)
        XCTAssertTrue(gdate!.isRecurring)
        gdate2 = GregorianDate(year: (gdate?.year), month: (gdate?.month), day: (gdate?.day), hour: (gdate?.hour)!, minute: (gdate?.minute)!, second: (gdate?.second)!, timezone: (gdate?.timezone)!)
        XCTAssertEqual(string, gdate2.time)
        string = "12:23:54.983244"
        gdate = GregorianDate(time: string)
        XCTAssertEqual(string, gdate!.time)
        XCTAssertTrue(gdate!.isRecurring)
        gdate2 = GregorianDate(year: (gdate?.year), month: (gdate?.month), day: (gdate?.day), hour: (gdate?.hour)!, minute: (gdate?.minute)!, second: (gdate?.second)!, timezone: (gdate?.timezone))
        XCTAssertEqual(string, gdate2.time)
    }
    
    func testgMonthDay() {
        var string = "--12-15Z"
        var gdate = GregorianDate(gMonthDay: string)
        XCTAssertEqual(string, gdate?.gMonthDay)
        XCTAssertTrue(gdate!.isRecurring)
        var gdate2 = GregorianDate(year: (gdate?.year), month: (gdate?.month), day: (gdate?.day), hour: (gdate?.hour), minute: (gdate?.minute), second: (gdate?.second), timezone: (gdate?.timezone))
        XCTAssertEqual(string, gdate2.gMonthDay)
        string = "--05-22+00:30"
        gdate = GregorianDate(gMonthDay: string)
        XCTAssertEqual(string, gdate?.gMonthDay)
        XCTAssertTrue(gdate!.isRecurring)
        gdate2 = GregorianDate(year: (gdate?.year), month: (gdate?.month), day: (gdate?.day), hour: (gdate?.hour), minute: (gdate?.minute), second: (gdate?.second), timezone: (gdate?.timezone))
        XCTAssertEqual(string, gdate2.gMonthDay)
        string = "--01-12-04:00"
        gdate = GregorianDate(gMonthDay: string)
        XCTAssertEqual(string, gdate?.gMonthDay)
        XCTAssertTrue(gdate!.isRecurring)
        gdate2 = GregorianDate(year: (gdate?.year), month: (gdate?.month), day: (gdate?.day), hour: (gdate?.hour), minute: (gdate?.minute), second: (gdate?.second), timezone: (gdate?.timezone))
        XCTAssertEqual(string, gdate2.gMonthDay)
        string = "--01-12"
        gdate = GregorianDate(gMonthDay: string)
        XCTAssertEqual(string, gdate?.gMonthDay)
        XCTAssertTrue(gdate!.isRecurring)
        gdate2 = GregorianDate(year: (gdate?.year), month: (gdate?.month), day: (gdate?.day), hour: (gdate?.hour), minute: (gdate?.minute), second: (gdate?.second), timezone: (gdate?.timezone))
        XCTAssertEqual(string, gdate2.gMonthDay)
        string = "-02-12Z"
        gdate = GregorianDate(gMonthDay: string)
        XCTAssertNil(gdate)
        string = "--00-12Z"
        gdate = GregorianDate(gMonthDay: string)
        XCTAssertNil(gdate)
        string = "--13-12Z"
        gdate = GregorianDate(gMonthDay: string)
        XCTAssertNil(gdate)
        string = "--2-12Z"
        gdate = GregorianDate(gMonthDay: string)
        XCTAssertNil(gdate)
        string = "12:23:54.983244+02:00"
        gdate = GregorianDate(gMonthDay: string)
        XCTAssertNil(gdate)
    }
    
    func testgMonth() {
        var string = "--12Z"
        var gdate = GregorianDate(gMonth: string)
        XCTAssertEqual(string, gdate?.gMonth)
        XCTAssertTrue(gdate!.isRecurring)
        var gdate2 = GregorianDate(year: (gdate?.year), month: (gdate?.month), day: (gdate?.day), hour: (gdate?.hour), minute: (gdate?.minute), second: (gdate?.second), timezone: (gdate?.timezone))
        XCTAssertEqual(string, gdate2.gMonth)
        string = "--05+00:30"
        gdate = GregorianDate(gMonth: string)
        XCTAssertEqual(string, gdate?.gMonth)
        XCTAssertTrue(gdate!.isRecurring)
        gdate2 = GregorianDate(year: (gdate?.year), month: (gdate?.month), day: (gdate?.day), hour: (gdate?.hour), minute: (gdate?.minute), second: (gdate?.second), timezone: (gdate?.timezone))
        XCTAssertEqual(string, gdate2.gMonth)
        string = "--01-04:00"
        gdate = GregorianDate(gMonth: string)
        XCTAssertEqual(string, gdate?.gMonth)
        XCTAssertTrue(gdate!.isRecurring)
        gdate2 = GregorianDate(year: (gdate?.year), month: (gdate?.month), day: (gdate?.day), hour: (gdate?.hour), minute: (gdate?.minute), second: (gdate?.second), timezone: (gdate?.timezone))
        XCTAssertEqual(string, gdate2.gMonth)
        string = "--01"
        gdate = GregorianDate(gMonth: string)
        XCTAssertEqual(string, gdate?.gMonth)
        XCTAssertTrue(gdate!.isRecurring)
        gdate2 = GregorianDate(year: (gdate?.year), month: (gdate?.month), day: (gdate?.day), hour: (gdate?.hour), minute: (gdate?.minute), second: (gdate?.second), timezone: (gdate?.timezone))
        XCTAssertEqual(string, gdate2.gMonth)
        string = "--05-12Z"
        gdate = GregorianDate(gMonth: string)
        XCTAssertNil(gdate)
        string = "-02Z"
        gdate = GregorianDate(gMonth: string)
        XCTAssertNil(gdate)
        string = "---02Z"
        gdate = GregorianDate(gMonth: string)
        XCTAssertNil(gdate)
        string = "--00-12Z"
        gdate = GregorianDate(gMonth: string)
        XCTAssertNil(gdate)
        string = "--13-12Z"
        gdate = GregorianDate(gMonth: string)
        XCTAssertNil(gdate)
        string = "--2-12Z"
        gdate = GregorianDate(gMonth: string)
        XCTAssertNil(gdate)
        string = "12:23:54.983244+02:00"
        gdate = GregorianDate(gMonth: string)
        XCTAssertNil(gdate)
    }
    
    func testgDay() {
        var string = "---12Z"
        var gdate = GregorianDate(gDay: string)
        XCTAssertEqual(string, gdate?.gDay)
        XCTAssertTrue(gdate!.isRecurring)
        var gdate2 = GregorianDate(year: (gdate?.year), month: (gdate?.month), day: (gdate?.day), hour: (gdate?.hour), minute: (gdate?.minute), second: (gdate?.second), timezone: (gdate?.timezone))
        XCTAssertEqual(string, gdate2.gDay)
        string = "---05+00:30"
        gdate = GregorianDate(gDay: string)
        XCTAssertEqual(string, gdate?.gDay)
        XCTAssertTrue(gdate!.isRecurring)
        gdate2 = GregorianDate(year: (gdate?.year), month: (gdate?.month), day: (gdate?.day), hour: (gdate?.hour), minute: (gdate?.minute), second: (gdate?.second), timezone: (gdate?.timezone))
        XCTAssertEqual(string, gdate2.gDay)
        string = "---01-04:00"
        gdate = GregorianDate(gDay: string)
        XCTAssertEqual(string, gdate?.gDay)
        XCTAssertTrue(gdate!.isRecurring)
        gdate2 = GregorianDate(year: (gdate?.year), month: (gdate?.month), day: (gdate?.day), hour: (gdate?.hour), minute: (gdate?.minute), second: (gdate?.second), timezone: (gdate?.timezone))
        XCTAssertEqual(string, gdate2.gDay)
        string = "---01"
        gdate = GregorianDate(gDay: string)
        XCTAssertEqual(string, gdate?.gDay)
        XCTAssertTrue(gdate!.isRecurring)
        gdate2 = GregorianDate(year: (gdate?.year), month: (gdate?.month), day: (gdate?.day), hour: (gdate?.hour), minute: (gdate?.minute), second: (gdate?.second), timezone: (gdate?.timezone))
        XCTAssertEqual(string, gdate2.gDay)
        string = "--02Z"
        gdate = GregorianDate(gDay: string)
        XCTAssertNil(gdate)
        string = "12:23:54.983244+02:00"
        gdate = GregorianDate(gDay: string)
        XCTAssertNil(gdate)
    }
}


