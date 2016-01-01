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
    
    func testDurationComparissonsInYearsAndMonths(){
        let duration1 = Duration(stringValue: "P12Y")!
        var duration2 = Duration(stringValue: "P13Y")!
        var comparisson = duration1 == duration2
        XCTAssertNotNil(comparisson)
        XCTAssertFalse(comparisson!)
        comparisson = duration1 != duration2
        XCTAssertNotNil(comparisson)
        XCTAssertTrue(comparisson!)
        comparisson = duration1 < duration2
        XCTAssertNotNil(comparisson)
        XCTAssertTrue(comparisson!)
        comparisson = duration1 <= duration2
        XCTAssertNotNil(comparisson)
        XCTAssertTrue(comparisson!)
        comparisson = duration1 > duration2
        XCTAssertNotNil(comparisson)
        XCTAssertFalse(comparisson!)
        comparisson = duration1 >= duration2
        XCTAssertNotNil(comparisson)
        XCTAssertFalse(comparisson!)
        
        duration2 = Duration(stringValue: "P12Y")!
        comparisson = duration1 == duration2
        XCTAssertNotNil(comparisson)
        XCTAssertTrue(comparisson!)
        comparisson = duration1 != duration2
        XCTAssertNotNil(comparisson)
        XCTAssertFalse(comparisson!)
        comparisson = duration1 < duration2
        XCTAssertNotNil(comparisson)
        XCTAssertFalse(comparisson!)
        comparisson = duration1 <= duration2
        XCTAssertNotNil(comparisson)
        XCTAssertTrue(comparisson!)
        comparisson = duration1 > duration2
        XCTAssertNotNil(comparisson)
        XCTAssertFalse(comparisson!)
        comparisson = duration1 >= duration2
        XCTAssertNotNil(comparisson)
        XCTAssertTrue(comparisson!)
        
        duration2 = Duration(stringValue: "P11Y")!
        comparisson = duration1 == duration2
        XCTAssertNotNil(comparisson)
        XCTAssertFalse(comparisson!)
        comparisson = duration1 != duration2
        XCTAssertNotNil(comparisson)
        XCTAssertTrue(comparisson!)
        comparisson = duration1 < duration2
        XCTAssertNotNil(comparisson)
        XCTAssertFalse(comparisson!)
        comparisson = duration1 <= duration2
        XCTAssertNotNil(comparisson)
        XCTAssertFalse(comparisson!)
        comparisson = duration1 > duration2
        XCTAssertNotNil(comparisson)
        XCTAssertTrue(comparisson!)
        comparisson = duration1 >= duration2
        XCTAssertNotNil(comparisson)
        XCTAssertTrue(comparisson!)
        
        duration2 = Duration(stringValue: "P144M")!
        comparisson = duration1 == duration2
        XCTAssertNotNil(comparisson)
        XCTAssertTrue(comparisson!)
        comparisson = duration1 != duration2
        XCTAssertNotNil(comparisson)
        XCTAssertFalse(comparisson!)
        comparisson = duration1 < duration2
        XCTAssertNotNil(comparisson)
        XCTAssertFalse(comparisson!)
        comparisson = duration1 <= duration2
        XCTAssertNotNil(comparisson)
        XCTAssertTrue(comparisson!)
        comparisson = duration1 > duration2
        XCTAssertNotNil(comparisson)
        XCTAssertFalse(comparisson!)
        comparisson = duration1 >= duration2
        XCTAssertNotNil(comparisson)
        XCTAssertTrue(comparisson!)
        
        duration2 = Duration(stringValue: "P145M")!
        comparisson = duration1 == duration2
        XCTAssertNotNil(comparisson)
        XCTAssertFalse(comparisson!)
        comparisson = duration1 != duration2
        XCTAssertNotNil(comparisson)
        XCTAssertTrue(comparisson!)
        comparisson = duration1 < duration2
        XCTAssertNotNil(comparisson)
        XCTAssertTrue(comparisson!)
        comparisson = duration1 <= duration2
        XCTAssertNotNil(comparisson)
        XCTAssertTrue(comparisson!)
        comparisson = duration1 > duration2
        XCTAssertNotNil(comparisson)
        XCTAssertFalse(comparisson!)
        comparisson = duration1 >= duration2
        XCTAssertNotNil(comparisson)
        XCTAssertFalse(comparisson!)
        
        duration2 = Duration(stringValue: "P143M")!
        comparisson = duration1 == duration2
        XCTAssertNotNil(comparisson)
        XCTAssertFalse(comparisson!)
        comparisson = duration1 != duration2
        XCTAssertNotNil(comparisson)
        XCTAssertTrue(comparisson!)
        comparisson = duration1 < duration2
        XCTAssertNotNil(comparisson)
        XCTAssertFalse(comparisson!)
        comparisson = duration1 <= duration2
        XCTAssertNotNil(comparisson)
        XCTAssertFalse(comparisson!)
        comparisson = duration1 > duration2
        XCTAssertNotNil(comparisson)
        XCTAssertTrue(comparisson!)
        comparisson = duration1 >= duration2
        XCTAssertNotNil(comparisson)
        XCTAssertTrue(comparisson!)
        
        duration2 = Duration(stringValue: "P11Y12M")!
        comparisson = duration1 == duration2
        XCTAssertNotNil(comparisson)
        XCTAssertTrue(comparisson!)
        comparisson = duration1 != duration2
        XCTAssertNotNil(comparisson)
        XCTAssertFalse(comparisson!)
        comparisson = duration1 < duration2
        XCTAssertNotNil(comparisson)
        XCTAssertFalse(comparisson!)
        comparisson = duration1 <= duration2
        XCTAssertNotNil(comparisson)
        XCTAssertTrue(comparisson!)
        comparisson = duration1 > duration2
        XCTAssertNotNil(comparisson)
        XCTAssertFalse(comparisson!)
        comparisson = duration1 >= duration2
        XCTAssertNotNil(comparisson)
        XCTAssertTrue(comparisson!)
        
        duration2 = Duration(stringValue: "P11Y13M")!
        comparisson = duration1 == duration2
        XCTAssertNotNil(comparisson)
        XCTAssertFalse(comparisson!)
        comparisson = duration1 != duration2
        XCTAssertNotNil(comparisson)
        XCTAssertTrue(comparisson!)
        comparisson = duration1 < duration2
        XCTAssertNotNil(comparisson)
        XCTAssertTrue(comparisson!)
        comparisson = duration1 <= duration2
        XCTAssertNotNil(comparisson)
        XCTAssertTrue(comparisson!)
        comparisson = duration1 > duration2
        XCTAssertNotNil(comparisson)
        XCTAssertFalse(comparisson!)
        comparisson = duration1 >= duration2
        XCTAssertNotNil(comparisson)
        XCTAssertFalse(comparisson!)
        
        duration2 = Duration(stringValue: "P11Y11M")!
        comparisson = duration1 == duration2
        XCTAssertNotNil(comparisson)
        XCTAssertFalse(comparisson!)
        comparisson = duration1 != duration2
        XCTAssertNotNil(comparisson)
        XCTAssertTrue(comparisson!)
        comparisson = duration1 < duration2
        XCTAssertNotNil(comparisson)
        XCTAssertFalse(comparisson!)
        comparisson = duration1 <= duration2
        XCTAssertNotNil(comparisson)
        XCTAssertFalse(comparisson!)
        comparisson = duration1 > duration2
        XCTAssertNotNil(comparisson)
        XCTAssertTrue(comparisson!)
        comparisson = duration1 >= duration2
        XCTAssertNotNil(comparisson)
        XCTAssertTrue(comparisson!)
        
        duration2 = Duration(stringValue: "P11Y12M15D")!
        comparisson = duration1 == duration2
        XCTAssertNotNil(comparisson)
        XCTAssertFalse(comparisson!)
        comparisson = duration1 != duration2
        XCTAssertNotNil(comparisson)
        XCTAssertTrue(comparisson!)
        comparisson = duration1 < duration2
        XCTAssertNotNil(comparisson)
        XCTAssertTrue(comparisson!)
        comparisson = duration1 <= duration2
        XCTAssertNotNil(comparisson)
        XCTAssertTrue(comparisson!)
        comparisson = duration1 > duration2
        XCTAssertNotNil(comparisson)
        XCTAssertFalse(comparisson!)
        comparisson = duration1 >= duration2
        XCTAssertNotNil(comparisson)
        XCTAssertFalse(comparisson!)
        
        duration2 = Duration(stringValue: "P11Y11M15D")!
        comparisson = duration1 == duration2
        XCTAssertNotNil(comparisson)
        XCTAssertFalse(comparisson!)
        comparisson = duration1 != duration2
        XCTAssertNotNil(comparisson)
        XCTAssertTrue(comparisson!)
        comparisson = duration1 < duration2
        XCTAssertNotNil(comparisson)
        XCTAssertFalse(comparisson!)
        comparisson = duration1 <= duration2
        XCTAssertNotNil(comparisson)
        XCTAssertFalse(comparisson!)
        comparisson = duration1 > duration2
        XCTAssertNotNil(comparisson)
        XCTAssertTrue(comparisson!)
        comparisson = duration1 >= duration2
        XCTAssertNotNil(comparisson)
        XCTAssertTrue(comparisson!)
        
        duration2 = Duration(stringValue: "P11Y12M01D")!
        comparisson = duration1 == duration2
        XCTAssertNil(comparisson)
        comparisson = duration1 != duration2
        XCTAssertNil(comparisson)
        comparisson = duration1 < duration2
        XCTAssertNil(comparisson)
        comparisson = duration1 <= duration2
        XCTAssertNil(comparisson)
        comparisson = duration1 > duration2
        XCTAssertNil(comparisson)
        comparisson = duration1 >= duration2
        XCTAssertNil(comparisson)
        
        duration2 = Duration(stringValue: "P11Y11M31D")!
        comparisson = duration1 == duration2
        XCTAssertNil(comparisson)
        comparisson = duration1 != duration2
        XCTAssertNil(comparisson)
        comparisson = duration1 < duration2
        XCTAssertNil(comparisson)
        comparisson = duration1 <= duration2
        XCTAssertNil(comparisson)
        comparisson = duration1 > duration2
        XCTAssertNil(comparisson)
        comparisson = duration1 >= duration2
        XCTAssertNil(comparisson)

    }
    
    func testDurationComparissonsInMinutesAndSeconds(){
        let duration1 = Duration(stringValue: "PT02M")!
        var duration2 = Duration(stringValue: "PT03M")!
        var comparisson = duration1 == duration2
        XCTAssertNotNil(comparisson)
        XCTAssertFalse(comparisson!)
        comparisson = duration1 != duration2
        XCTAssertNotNil(comparisson)
        XCTAssertTrue(comparisson!)
        comparisson = duration1 < duration2
        XCTAssertNotNil(comparisson)
        XCTAssertTrue(comparisson!)
        comparisson = duration1 <= duration2
        XCTAssertNotNil(comparisson)
        XCTAssertTrue(comparisson!)
        comparisson = duration1 > duration2
        XCTAssertNotNil(comparisson)
        XCTAssertFalse(comparisson!)
        comparisson = duration1 >= duration2
        XCTAssertNotNil(comparisson)
        XCTAssertFalse(comparisson!)
        
        duration2 = Duration(stringValue: "PT02M")!
        comparisson = duration1 == duration2
        XCTAssertNotNil(comparisson)
        XCTAssertTrue(comparisson!)
        comparisson = duration1 != duration2
        XCTAssertNotNil(comparisson)
        XCTAssertFalse(comparisson!)
        comparisson = duration1 < duration2
        XCTAssertNotNil(comparisson)
        XCTAssertFalse(comparisson!)
        comparisson = duration1 <= duration2
        XCTAssertNotNil(comparisson)
        XCTAssertTrue(comparisson!)
        comparisson = duration1 > duration2
        XCTAssertNotNil(comparisson)
        XCTAssertFalse(comparisson!)
        comparisson = duration1 >= duration2
        XCTAssertNotNil(comparisson)
        XCTAssertTrue(comparisson!)
        
        duration2 = Duration(stringValue: "PT01M")!
        comparisson = duration1 == duration2
        XCTAssertNotNil(comparisson)
        XCTAssertFalse(comparisson!)
        comparisson = duration1 != duration2
        XCTAssertNotNil(comparisson)
        XCTAssertTrue(comparisson!)
        comparisson = duration1 < duration2
        XCTAssertNotNil(comparisson)
        XCTAssertFalse(comparisson!)
        comparisson = duration1 <= duration2
        XCTAssertNotNil(comparisson)
        XCTAssertFalse(comparisson!)
        comparisson = duration1 > duration2
        XCTAssertNotNil(comparisson)
        XCTAssertTrue(comparisson!)
        comparisson = duration1 >= duration2
        XCTAssertNotNil(comparisson)
        XCTAssertTrue(comparisson!)
        
        duration2 = Duration(stringValue: "PT118S")!
        comparisson = duration1 == duration2
        XCTAssertNotNil(comparisson)
        XCTAssertFalse(comparisson!)
        comparisson = duration1 != duration2
        XCTAssertNotNil(comparisson)
        XCTAssertTrue(comparisson!)
        comparisson = duration1 < duration2
        XCTAssertNotNil(comparisson)
        XCTAssertFalse(comparisson!)
        comparisson = duration1 <= duration2
        XCTAssertNotNil(comparisson)
        XCTAssertFalse(comparisson!)
        comparisson = duration1 > duration2
        XCTAssertNotNil(comparisson)
        XCTAssertTrue(comparisson!)
        comparisson = duration1 >= duration2
        XCTAssertNotNil(comparisson)
        XCTAssertTrue(comparisson!)
        
        duration2 = Duration(stringValue: "PT122S")!
        comparisson = duration1 == duration2
        XCTAssertNotNil(comparisson)
        XCTAssertFalse(comparisson!)
        comparisson = duration1 != duration2
        XCTAssertNotNil(comparisson)
        XCTAssertTrue(comparisson!)
        comparisson = duration1 < duration2
        XCTAssertNotNil(comparisson)
        XCTAssertTrue(comparisson!)
        comparisson = duration1 <= duration2
        XCTAssertNotNil(comparisson)
        XCTAssertTrue(comparisson!)
        comparisson = duration1 > duration2
        XCTAssertNotNil(comparisson)
        XCTAssertFalse(comparisson!)
        comparisson = duration1 >= duration2
        XCTAssertNotNil(comparisson)
        XCTAssertFalse(comparisson!)
        
        duration2 = Duration(stringValue: "PT119S")!
        comparisson = duration1 == duration2
        XCTAssertNil(comparisson)
        comparisson = duration1 != duration2
        XCTAssertNil(comparisson)
        comparisson = duration1 < duration2
        XCTAssertNil(comparisson)
        comparisson = duration1 <= duration2
        XCTAssertNil(comparisson)
        comparisson = duration1 > duration2
        XCTAssertNil(comparisson)
        comparisson = duration1 >= duration2
        XCTAssertNil(comparisson)
        
        duration2 = Duration(stringValue: "PT121S")!
        comparisson = duration1 == duration2
        XCTAssertNil(comparisson)
        comparisson = duration1 != duration2
        XCTAssertNil(comparisson)
        comparisson = duration1 < duration2
        XCTAssertNil(comparisson)
        comparisson = duration1 <= duration2
        XCTAssertNil(comparisson)
        comparisson = duration1 > duration2
        XCTAssertNil(comparisson)
        comparisson = duration1 >= duration2
        XCTAssertNil(comparisson)
    }
    
    
    /*
    // To calculate the number of days for durations in months (see `Duration`).
    func testDetermineMonthMinAnMax() {
        let calendar = NSCalendar.currentCalendar()
        var min = [Int](count: 12000, repeatedValue: 0)
        var max = [Int](count: 12000, repeatedValue: 0)
        var ave = [Double](count: 12000, repeatedValue: 0)
        for var year = 2000; year < 2100; year++ {
            print("progress: \((year-2000))%")
            for var month = 1; month <= 12 ; month++ {
                var components = NSDateComponents()
                components.year = year
                components.month = month
                components.day = 15
                let startdate = calendar.dateFromComponents(components)
                let starttime = startdate?.timeIntervalSince1970
                for var nmonths = 1; nmonths < 12000; nmonths++ {
                    components = NSDateComponents()
                    components.month = nmonths
                    let date = calendar.dateByAddingComponents(components, toDate: startdate!, options: NSCalendarOptions(rawValue: 0))
                    let time = date?.timeIntervalSince1970
                    let difftime = Double(Int((time!-starttime!)/86400))
                    
                    ave[nmonths] += difftime
                    if difftime > Double(max[nmonths]) || max[nmonths] == 0 {
                        max[nmonths] = Int(difftime)
                    }
                    if difftime < Double(min[nmonths]) || min[nmonths] == 0 {
                        min[nmonths] = Int(difftime)
                    }
                }
                
            }
        }
        
        
        for var nmonths = 1; nmonths < 12000; nmonths++ {
            ave[nmonths] = ave[nmonths]/1200.0
        }
        
        print("let dayInMonths: [(ndays: Double, posError : Double, negError : Double)] = [ ")
        for var nmonths = 1; nmonths <= 120; nmonths++ {
            var comma = ","
            if nmonths == 120 {
                comma = ""
            }
            print("(ndays: \(ave[nmonths]), posError: \(Double(max[nmonths])-ave[nmonths]), negError: \(ave[nmonths]-Double(min[nmonths])))\(comma)")
        }
        print("]")
        
        var yrave = [Double](count: 12, repeatedValue: 0)
        var yrmin = [Double](count: 12, repeatedValue: 0)
        var yrmax = [Double](count: 12, repeatedValue: 0)
        for var nmonths = 1; nmonths < 12000; nmonths++ {
            let mnr = nmonths%12
            yrave[mnr] += Double(ave[nmonths]) / Double(nmonths)
            if yrmin[mnr] < ave[nmonths]-Double(min[nmonths]) || mnr == 1 {
                yrmin[mnr] = ave[nmonths]-Double(min[nmonths])
            }
            if yrmax[mnr] < Double(max[nmonths])-ave[nmonths] || mnr == 1 {
                yrmax[mnr] = Double(max[nmonths])-ave[nmonths]
            }
        }
        print("let dayInMonthInYear: [(ndays: Double, posError : Double, negError : Double)] = [ ")
        for var nm = 0; nm < 12; nm++ {
            yrave[nm] =  yrave[nm]/1000
            var comma = ","
            if nm == 11 {
                comma = ""
            }
            print("(ndays: \(yrave[nm]), posError: \(yrmax[nm]), negError: \(yrmin[nm]))\(comma)")
        }
        print("]")
        
    }
*/
}
