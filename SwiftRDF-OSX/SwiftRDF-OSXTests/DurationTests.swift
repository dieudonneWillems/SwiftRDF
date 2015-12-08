//
//  DurationTests.swift
//  SwiftRDF-OSX
//
//  Created by Don Willems on 07/12/15.
//  Copyright © 2015 lapsedpacifist. All rights reserved.
//

import Foundation

import XCTest
@testable import SwiftRDFOSX

class DurationTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testNumericInitialisation() {
        let duration1 = Duration(positive: true, years: 0, months: 1, days: 2, hours: 12, minutes: 33, seconds: 9.2)!
        XCTAssertTrue(duration1.isPositive)
        XCTAssertTrue(duration1.years == 0)
        XCTAssertTrue(duration1.months == 1)
        XCTAssertTrue(duration1.days == 2)
        XCTAssertTrue(duration1.hours == 12)
        XCTAssertTrue(duration1.minutes == 33)
        XCTAssertTrue(duration1.seconds == 9.2)
        XCTAssertEqual(duration1.description, "P1M2DT12H33M9.2S")
        let duration2 = Duration(positive: false, years: 9, months: 14, days: 0, hours: 0, minutes: 0, seconds: 0)!
        XCTAssertTrue(!duration2.isPositive)
        XCTAssertTrue(duration2.years == 9)
        XCTAssertTrue(duration2.months == 14)
        XCTAssertTrue(duration2.days == 0)
        XCTAssertTrue(duration2.hours == 0)
        XCTAssertTrue(duration2.minutes == 0)
        XCTAssertTrue(duration2.seconds == 0)
        XCTAssertEqual(duration2.description, "-P9Y14M")
        let duration3 = Duration(positive: false, years: 0, months: 0, days: 0, hours: 23, minutes: 10, seconds: 20)!
        XCTAssertTrue(!duration3.isPositive)
        XCTAssertTrue(duration3.years == 0)
        XCTAssertTrue(duration3.months == 0)
        XCTAssertTrue(duration3.days == 0)
        XCTAssertTrue(duration3.hours == 23)
        XCTAssertTrue(duration3.minutes == 10)
        XCTAssertTrue(duration3.seconds == 20)
        XCTAssertEqual(duration3.description, "-PT23H10M20S")
        let duration4 = Duration(positive: false, years: 0, months: 0, days: 0, hours: 23, minutes: 10, seconds: -20)
        XCTAssertNil(duration4)
    }
    
    func testTimeIntervalInitialisation() {
        let duration1 = Duration(timeInterval: 8723.2134)
        XCTAssertTrue(duration1.isPositive)
        XCTAssertTrue(duration1.years == 0)
        XCTAssertTrue(duration1.months == 0)
        XCTAssertTrue(duration1.days == 0)
        XCTAssertTrue(duration1.hours == 0)
        XCTAssertTrue(duration1.minutes == 0)
        XCTAssertTrue(duration1.seconds == 8723.2134)
        XCTAssertEqual(duration1.description, "PT8723.2134S")
        let duration2 = Duration(timeInterval: -8723.2134)
        XCTAssertTrue(!duration2.isPositive)
        XCTAssertTrue(duration2.years == 0)
        XCTAssertTrue(duration2.months == 0)
        XCTAssertTrue(duration2.days == 0)
        XCTAssertTrue(duration2.hours == 0)
        XCTAssertTrue(duration2.minutes == 0)
        XCTAssertTrue(duration2.seconds == 8723.2134)
        XCTAssertEqual(duration2.description, "-PT8723.2134S")
    }
    
    func testStringInitialisation() {
        let duration1 = Duration(stringValue: "P12MT23M")!
        XCTAssertTrue(duration1.isPositive)
        XCTAssertTrue(duration1.years == 0)
        XCTAssertTrue(duration1.months == 12)
        XCTAssertTrue(duration1.days == 0)
        XCTAssertTrue(duration1.hours == 0)
        XCTAssertTrue(duration1.minutes == 23)
        XCTAssertTrue(duration1.seconds == 0)
        XCTAssertEqual(duration1.description, "P12MT23M")
        let duration2 = Duration(stringValue: "-P12MT23M")!
        XCTAssertTrue(!duration2.isPositive)
        XCTAssertTrue(duration2.years == 0)
        XCTAssertTrue(duration2.months == 12)
        XCTAssertTrue(duration2.days == 0)
        XCTAssertTrue(duration2.hours == 0)
        XCTAssertTrue(duration2.minutes == 23)
        XCTAssertTrue(duration2.seconds == 0)
        XCTAssertEqual(duration2.description, "-P12MT23M")
        let duration3 = Duration(stringValue: "P21Y2M13DT23H12342M1993.21S")!
        XCTAssertTrue(duration3.isPositive)
        XCTAssertTrue(duration3.years == 21)
        XCTAssertTrue(duration3.months == 2)
        XCTAssertTrue(duration3.days == 13)
        XCTAssertTrue(duration3.hours == 23)
        XCTAssertTrue(duration3.minutes == 12342)
        XCTAssertTrue(duration3.seconds == 1993.21)
        XCTAssertEqual(duration3.description, "P21Y2M13DT23H12342M1993.21S")
    }
}
