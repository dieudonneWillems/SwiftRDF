//
//  NSDate_extension.swift
//  
//
//  Created by Don Willems on 08/12/15.
//
//

import Foundation


public class GregorianDate {
    
    // regex dateTime pattern: ^((?:[+-]?)(?:\d{4,}))-((?:0[1-9])|(?:1[0-2]))-((?:0[1-9])|(?:[1-2][0-9])|(?:3[0-1]))T((?:[0-1][0-9])|(?:2[0-4])):([0-5][0-9]):((?:(?:[0-5][0-9])|60)(?:\.\d*)?)(Z|(?:([+-](?:(?:0[0-9])|(?:1[0-2]))):((?:00)|(?:30))))$
    private static let dateTimePattern = "^((?:[+-]?)(?:\\d{4,}))-((?:0[1-9])|(?:1[0-2]))-((?:0[1-9])|(?:[1-2][0-9])|(?:3[0-1]))T((?:[0-1][0-9])|(?:2[0-4])):([0-5][0-9]):((?:(?:[0-5][0-9])|60)(?:\\.\\d*)?)(Z|(?:([+-](?:(?:0[0-9])|(?:1[0-2]))):((?:00)|(?:30))))$"
    private static let datePattern = "^((?:[+-]?)(?:\\d{4,}))-((?:0[1-9])|(?:1[0-2]))-((?:0[1-9])|(?:[1-2][0-9])|(?:3[0-1]))(Z|(?:([+-](?:(?:0[0-9])|(?:1[0-2]))):((?:00)|(?:30))))$"
    private static let gYearMonthPattern = "^((?:[+-]?)(?:\\d*))-((?:0[1-9])|(?:1[0-2]))(Z|(?:([+-](?:(?:0[0-9])|(?:1[0-2]))):((?:00)|(?:30))))$"
    private static let gYearPattern = "^((?:[+-]?)(?:\\d{4,}))(Z|(?:([+-](?:(?:0[0-9])|(?:1[0-2]))):((?:00)|(?:30))))$"
    
    private static let calendar = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)!
    
    public private(set) var year : Int?
    public private(set) var month : Int?
    public private(set) var day : Int?
    public private(set) var hour : Int?
    public private(set) var minute : Int?
    public private(set) var second : Double?
    public private(set) var timezone : NSTimeZone = NSTimeZone.localTimeZone()
    
    public var startDate : NSDate? {
        get {
            if year != nil {
                let components = NSDateComponents()
                components.year = year!
                if month != nil {
                    components.month = month!
                    if day != nil {
                        components.day = day!
                        if hour != nil && minute != nil && second != nil { // xsd:dateTime
                            components.hour = day!
                            components.minute = day!
                            components.second = Int(second!)
                            components.nanosecond = Int(second!-Double(Int(second!))*1e9)
                            
                        } else { // xsd:date
                            components.hour = 0
                            components.minute = 0
                            components.second = 0
                        }
                    } else { // xsd:gYearMonth
                        components.day = 1
                    }
                } else { // xsd:gYear
                    components.month = 1
                }
                GregorianDate.calendar.timeZone = timezone
                let date = GregorianDate.calendar.dateFromComponents(components)
                return date
            } else {
                
                
            }
            return nil
        }
    }
    
    public var endDate : NSDate? {
        get {
            if duration == nil {
                return nil
            }
            return self.addDuration(duration!)?.startDate
        }
    }
    
    public var duration : Duration? {
        get {
            if second != nil {
                return Duration(positive: true, years: 0, months: 0, days: 0, hours: 0, minutes: 0, seconds: 1)
            } else if minute != nil {
                return Duration(positive: true, years: 0, months: 0, days: 0, hours: 0, minutes: 1, seconds: 0)
            } else if hour != nil {
                return Duration(positive: true, years: 0, months: 0, days: 0, hours: 1, minutes: 0, seconds: 0)
            } else if day != nil {
                return Duration(positive: true, years: 0, months: 0, days: 1, hours: 0, minutes: 0, seconds: 0)
            } else if month != nil {
                return Duration(positive: true, years: 0, months: 1, days: 0, hours: 0, minutes: 0, seconds: 0)
            } else if year != nil {
                return Duration(positive: true, years: 1, months: 0, days: 0, hours: 0, minutes: 0, seconds: 0)
            }
            return nil
        }
    }
    
    public var isRecurring : Bool {
        get {
            return (year == nil)
        }
    }
    
    public var dateTime : String? {
        get {
            if hour == nil || minute == nil || second == nil || day == nil || month == nil || year == nil {
                return nil
            }
            var dateTime = "\(year!)-"
            if month < 10 {
                dateTime += "0\(month!)-"
            } else {
                dateTime += "\(month!)-"
            }
            if day < 10 {
                dateTime += "0\(day!)"
            } else {
                dateTime += "\(day!)"
            }
            dateTime += "T"
            if hour < 10 {
                dateTime += "0\(hour!):"
            } else {
                dateTime += "\(hour!):"
            }
            if minute < 10 {
                dateTime += "0\(minute!):"
            } else {
                dateTime += "\(minute!):"
            }
            if Double(Int(second!)) == second! {
                if second < 10 {
                    dateTime += "0\(Int(second!))"
                } else {
                    dateTime += "\(Int(second!))"
                }
            } else {
                if second < 10 {
                    dateTime += "0\(second!)"
                } else {
                    dateTime += "\(second!)"
                }
            }
            let components = NSDateComponents()
            components.year = year!
            components.month = month!
            components.day = day!
            components.hour = hour!
            components.minute = minute!
            components.second = Int(second!)
            components.nanosecond = Int(second!-Double(Int(second!))*1e9)
            let date = GregorianDate.calendar.dateFromComponents(components)
            let sgmt = timezone.secondsFromGMTForDate(date!)
            var mgmt = Int(sgmt / 60)
            var hgmt = Int(mgmt / 60)
            mgmt = Int(abs(mgmt) % 60)
            if hgmt == 0 && mgmt == 0 {
                dateTime += "Z"
            } else {
                if hgmt < 0 {
                    dateTime += "-"
                } else {
                    dateTime += "+"
                }
                hgmt = abs(hgmt)
                if hgmt < 10 {
                    dateTime += "0\(hgmt):"
                } else {
                    dateTime += "\(hgmt):"
                }
                if mgmt < 10 {
                    dateTime += "0\(mgmt)"
                } else {
                    dateTime += "\(mgmt)"
                }
            }
            return dateTime
        }
    }
    
    public var date : String? {
        get {
            if day == nil || month == nil || year == nil {
                return nil
            }
            var dateTime = "\(year!)-"
            if month < 10 {
                dateTime += "0\(month!)-"
            } else {
                dateTime += "\(month!)-"
            }
            if day < 10 {
                dateTime += "0\(day!)"
            } else {
                dateTime += "\(day!)"
            }
            let components = NSDateComponents()
            components.year = year!
            components.month = month!
            components.day = day!
            let date = GregorianDate.calendar.dateFromComponents(components)
            let sgmt = timezone.secondsFromGMTForDate(date!)
            var mgmt = Int(sgmt / 60)
            var hgmt = Int(mgmt / 60)
            mgmt = Int(abs(mgmt) % 60)
            if hgmt == 0 && mgmt == 0 {
                dateTime += "Z"
            } else {
                if hgmt < 0 {
                    dateTime += "-"
                } else {
                    dateTime += "+"
                }
                hgmt = abs(hgmt)
                if hgmt < 10 {
                    dateTime += "0\(hgmt):"
                } else {
                    dateTime += "\(hgmt):"
                }
                if mgmt < 10 {
                    dateTime += "0\(mgmt)"
                } else {
                    dateTime += "\(mgmt)"
                }
            }
            return dateTime
        }
    }
    
    public var gYearMonth : String? {
        get {
            if month == nil || year == nil {
                return nil
            }
            var dateTime = "\(year!)-"
            if month < 10 {
                dateTime += "0\(month!)"
            } else {
                dateTime += "\(month!)"
            }
            let components = NSDateComponents()
            components.year = year!
            components.month = month!
            let date = GregorianDate.calendar.dateFromComponents(components)
            let sgmt = timezone.secondsFromGMTForDate(date!)
            var mgmt = Int(sgmt / 60)
            var hgmt = Int(mgmt / 60)
            mgmt = Int(abs(mgmt) % 60)
            if hgmt == 0 && mgmt == 0 {
                dateTime += "Z"
            } else {
                if hgmt < 0 {
                    dateTime += "-"
                } else {
                    dateTime += "+"
                }
                hgmt = abs(hgmt)
                if hgmt < 10 {
                    dateTime += "0\(hgmt):"
                } else {
                    dateTime += "\(hgmt):"
                }
                if mgmt < 10 {
                    dateTime += "0\(mgmt)"
                } else {
                    dateTime += "\(mgmt)"
                }
            }
            return dateTime
        }
    }
    
    public var gYear : String? {
        get {
            if year == nil {
                return nil
            }
            var dateTime = "\(year!)"
            let components = NSDateComponents()
            components.year = year!
            let date = GregorianDate.calendar.dateFromComponents(components)
            let sgmt = timezone.secondsFromGMTForDate(date!)
            var mgmt = Int(sgmt / 60)
            var hgmt = Int(mgmt / 60)
            mgmt = Int(abs(mgmt) % 60)
            if hgmt == 0 && mgmt == 0 {
                dateTime += "Z"
            } else {
                if hgmt < 0 {
                    dateTime += "-"
                } else {
                    dateTime += "+"
                }
                hgmt = abs(hgmt)
                if hgmt < 10 {
                    dateTime += "0\(hgmt):"
                } else {
                    dateTime += "\(hgmt):"
                }
                if mgmt < 10 {
                    dateTime += "0\(mgmt)"
                } else {
                    dateTime += "\(mgmt)"
                }
            }
            return dateTime
        }
    }
    
    public convenience init() {
        self.init(date: NSDate())
    }
    
    public convenience init(date: NSDate) {
        let tz = NSTimeZone(forSecondsFromGMT: 0)
        self.init(date:date, timeZone : tz)
    }
    
    public init(date: NSDate, timeZone : NSTimeZone) {
        timezone = timeZone
        let unitFlags: NSCalendarUnit = [.Hour, .Day, .Month, .Year, .Minute, .Second, .Nanosecond]
        GregorianDate.calendar.timeZone = timezone
        let components = GregorianDate.calendar.components(unitFlags, fromDate:date)
        year = components.year
        month = components.month
        day = components.day
        hour = components.hour
        minute = components.minute
        second = Double(components.second)
        let nanosec = components.nanosecond
        second! += Double(nanosec)*1e-9
    }
    
    public init?(year: Int?, month: Int?, day: Int?, hour: Int?, minute: Int?, second: Double?, timezone: NSTimeZone) {
        self.year = year
        self.month = month
        self.day = day
        self.hour = hour
        self.minute = minute
        self.second = second
        self.timezone = timezone
    }
    
    public init?(dateTime: String) {
        let parsed = parseDateString(dateTime, pattern: GregorianDate.dateTimePattern)
        if !parsed {
            return nil
        }
    }
    
    
    public convenience init?(year: Int, month: Int, day: Int, timezone: NSTimeZone) {
        self.init(year:year, month:month, day: day, hour:nil, minute:nil, second:nil, timezone:timezone)
    }
    
    public init?(date: String) {
        let parsed = parseDateString(date, pattern: GregorianDate.datePattern)
        if !parsed {
            return nil
        }
    }
    
    public convenience init?(year: Int, month: Int, timezone: NSTimeZone) {
        self.init(year:year, month:month, day: nil, hour:nil, minute:nil, second:nil, timezone:timezone)
    }
    
    public init?(gYearMonth: String) {
        let parsed = parseDateString(gYearMonth, pattern: GregorianDate.gYearMonthPattern)
        if !parsed {
            return nil
        }
    }
    
    public convenience init?(year: Int, timezone: NSTimeZone) {
        self.init(year:year, month:nil, day: nil, hour:nil, minute:nil, second:nil, timezone:timezone)
    }
    
    public init?(gYear: String) {
        let parsed = parseDateString(gYear, pattern: GregorianDate.gYearPattern)
        if !parsed {
            return nil
        }
        
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func addDuration(duration : Duration) -> GregorianDate? {
        var sign = 1
        if !duration.isPositive {
            sign = -1
        }
        let components = NSDateComponents()
        components.year = sign*Int(duration.years)
        components.month = sign*Int(duration.months)
        components.day = sign*Int(duration.days)
        components.hour = sign*Int(duration.hours)
        components.minute = sign*Int(duration.minutes)
        components.second = sign*Int(duration.seconds)
        components.nanosecond = sign*Int(duration.seconds-Double(Int(duration.seconds))*1e9)
        GregorianDate.calendar.timeZone = timezone
        let sdate = self.startDate
        if sdate == nil {
            return nil
        }
        let ndate = GregorianDate.calendar.dateByAddingComponents(components, toDate: sdate!, options: NSCalendarOptions(rawValue: 0))
        let ngd = GregorianDate(date: ndate!, timeZone: timezone)
        return ngd
    }
    
    private func parseDateString(stringValue: String, pattern : String) -> Bool {
        do {
            let regex = try NSRegularExpression(pattern: pattern, options: [])
            let matches = regex.matchesInString(stringValue, options: [], range: NSMakeRange(0, stringValue.characters.count)) as Array<NSTextCheckingResult>
            if matches.count == 0 {
                return false
            }else{
                let match = matches[0]
                let nsstring = stringValue as NSString
                if match.rangeAtIndex(match.numberOfRanges-3).location != NSNotFound {
                    var tzhrs = 0;
                    var tzmins = 0;
                    if match.rangeAtIndex(match.numberOfRanges-2).location != NSNotFound {
                        let tzhrsStr = nsstring.substringWithRange(match.rangeAtIndex(match.numberOfRanges-2)) as String
                        tzhrs = Int(tzhrsStr)!
                    }
                    if match.rangeAtIndex(match.numberOfRanges-1).location != NSNotFound {
                        let tzminsStr = nsstring.substringWithRange(match.rangeAtIndex(match.numberOfRanges-1)) as String
                        tzmins = Int(tzminsStr)!
                    }
                    if tzhrs < 0 {
                        tzmins = -tzmins
                    }
                    timezone = NSTimeZone.init(forSecondsFromGMT: tzhrs*3600+tzmins*60)
                }
                if match.rangeAtIndex(1).location != NSNotFound {
                    let str = nsstring.substringWithRange(match.rangeAtIndex(1)) as String
                    year = Int(str)!
                }
                if match.numberOfRanges >= 6 && match.rangeAtIndex(2).location != NSNotFound {
                    let str = nsstring.substringWithRange(match.rangeAtIndex(2)) as String
                    month = Int(str)!
                }
                if match.numberOfRanges >= 7 && match.rangeAtIndex(3).location != NSNotFound {
                    let str = nsstring.substringWithRange(match.rangeAtIndex(3)) as String
                    day = Int(str)!
                }
                if match.numberOfRanges >= 8 && match.rangeAtIndex(4).location != NSNotFound {
                    let str = nsstring.substringWithRange(match.rangeAtIndex(4)) as String
                    hour = Int(str)!
                }
                if match.numberOfRanges >= 9 && match.rangeAtIndex(5).location != NSNotFound {
                    let str = nsstring.substringWithRange(match.rangeAtIndex(5)) as String
                    minute = Int(str)!
                }
                if match.numberOfRanges >= 10 && match.rangeAtIndex(6).location != NSNotFound {
                    let str = nsstring.substringWithRange(match.rangeAtIndex(6)) as String
                    second = Double(str)!
                }
                return true
            }
        } catch {
            
        }
        return false
    }
}