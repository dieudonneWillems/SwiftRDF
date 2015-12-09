//
//  NSDate_extension.swift
//  
//
//  Created by Don Willems on 08/12/15.
//
//

import Foundation


public class GregorianDate : NSDate {
    
    // regex dateTime pattern: ^((?:[+-]?)(?:\d{4,}))-((?:0[1-9])|(?:1[0-2]))-((?:0[1-9])|(?:[1-2][0-9])|(?:3[0-1]))T((?:[0-1][0-9])|(?:2[0-4])):([0-5][0-9]):((?:(?:[0-5][0-9])|60)(?:\.\d*)?)(Z|(?:([+-](?:(?:0[0-9])|(?:1[0-2]))):((?:00)|(?:30))))$
    private static let dateTimePattern = "^((?:[+-]?)(?:\\d{4,}))-((?:0[1-9])|(?:1[0-2]))-((?:0[1-9])|(?:[1-2][0-9])|(?:3[0-1]))T((?:[0-1][0-9])|(?:2[0-4])):([0-5][0-9]):((?:(?:[0-5][0-9])|60)(?:\\.\\d*)?)(Z|(?:([+-](?:(?:0[0-9])|(?:1[0-2]))):((?:00)|(?:30))))$"
    private static let datePattern = "^((?:[+-]?)(?:\\d{4,}))-((?:0[1-9])|(?:1[0-2]))-((?:0[1-9])|(?:[1-2][0-9])|(?:3[0-1]))(Z|(?:([+-](?:(?:0[0-9])|(?:1[0-2]))):((?:00)|(?:30))))$"
    private static let gYearMonthPattern = "^((?:[+-]?)(?:\\d*))-((?:0[1-9])|(?:1[0-2]))(Z|(?:([+-](?:(?:0[0-9])|(?:1[0-2]))):((?:00)|(?:30))))$"
    private static let gYearPattern = "^((?:[+-]?)(?:\\d{4,}))(Z|(?:([+-](?:(?:0[0-9])|(?:1[0-2]))):((?:00)|(?:30))))$"
    
    private static let calendar = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)!
    
    public private(set) var year : Int = 0
    public private(set) var month : Int = 1
    public private(set) var day : Int = 1
    public private(set) var hour : Int = 0
    public private(set) var minute : Int = 0
    public private(set) var second : Double = 0
    public private(set) var timezone : NSTimeZone = NSTimeZone.localTimeZone()
    
    private var timeIntervalSinceReferenceDataInternal : NSTimeInterval
    private var timeSpan : NSTimeInterval
    
    public override var timeIntervalSinceReferenceDate: NSTimeInterval {
        get {
            return timeIntervalSinceReferenceDataInternal
        }
    }
    
    public var dateTime : String {
        get {
            var dateTime = "\(year)-"
            if month < 10 {
                dateTime += "0\(month)-"
            } else {
                dateTime += "\(month)-"
            }
            if day < 10 {
                dateTime += "0\(day)"
            } else {
                dateTime += "\(day)"
            }
            dateTime += "T"
            if hour < 10 {
                dateTime += "0\(hour):"
            } else {
                dateTime += "\(hour):"
            }
            if minute < 10 {
                dateTime += "0\(minute):"
            } else {
                dateTime += "\(minute):"
            }
            if Double(Int(second)) == second {
                if second < 10 {
                    dateTime += "0\(Int(second))"
                } else {
                    dateTime += "\(Int(second))"
                }
            } else {
                if second < 10 {
                    dateTime += "0\(second)"
                } else {
                    dateTime += "\(second)"
                }
            }
            let sgmt = timezone.secondsFromGMTForDate(self)
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
    
    public var date : String {
        get {
            var dateTime = "\(year)-"
            if month < 10 {
                dateTime += "0\(month)-"
            } else {
                dateTime += "\(month)-"
            }
            if day < 10 {
                dateTime += "0\(day)"
            } else {
                dateTime += "\(day)"
            }
            let sgmt = timezone.secondsFromGMTForDate(self)
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
    
    public var gYearMonth : String {
        get {
            var dateTime = "\(year)-"
            if month < 10 {
                dateTime += "0\(month)"
            } else {
                dateTime += "\(month)"
            }
            let sgmt = timezone.secondsFromGMTForDate(self)
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
    
    public var gYear : String {
        get {
            var dateTime = "\(year)"
            let sgmt = timezone.secondsFromGMTForDate(self)
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
    
    public override init() {
        timezone = NSTimeZone.localTimeZone()
        GregorianDate.calendar.timeZone = timezone
        timeIntervalSinceReferenceDataInternal = NSDate.timeIntervalSinceReferenceDate()
        timeSpan = 0
        super.init()
        let unitFlags: NSCalendarUnit = [.Hour, .Day, .Month, .Year, .Minute, .Second, .Nanosecond]
        let components = GregorianDate.calendar.components(unitFlags, fromDate:self)
        year = components.year
        month = components.month
        day = components.day
        hour = components.hour
        minute = components.minute
        second = Double(components.second)
        let nanosec = components.nanosecond
        second += Double(nanosec)*1e-9
    }
    
    public override init(timeIntervalSinceReferenceDate : NSTimeInterval) {
        timeIntervalSinceReferenceDataInternal = timeIntervalSinceReferenceDate
        timezone = NSTimeZone(forSecondsFromGMT: 0)
        timeSpan = 0
        super.init()
        let unitFlags: NSCalendarUnit = [.Hour, .Day, .Month, .Year, .Minute, .Second, .Nanosecond]
        GregorianDate.calendar.timeZone = timezone
        let components = GregorianDate.calendar.components(unitFlags, fromDate:self)
        year = components.year
        month = components.month
        day = components.day
        hour = components.hour
        minute = components.minute
        second = Double(components.second)
        let nanosec = components.nanosecond
        second += Double(nanosec)*1e-9
    }
    
    public convenience init?(year: Int, month: Int, day: Int, hour: Int, minute: Int, second: Double, timezone: NSTimeZone) {
        let components = NSDateComponents()
        GregorianDate.calendar.timeZone = timezone
        components.year = year
        components.month = month
        components.day = day
        components.hour = hour
        components.minute = minute
        components.second = Int(second)
        let nanosecs = Int(second*1e9)
        components.nanosecond = nanosecs
        let date = GregorianDate.calendar.dateFromComponents(components)
        self.init(timeIntervalSinceReferenceDate: (date?.timeIntervalSinceReferenceDate)!)
        self.timeSpan = 0
        self.timezone = timezone
        self.year = year
        self.month = month
        self.day = day
        self.hour = hour
        self.minute = minute
        self.second = second
    }
    
    public convenience init?(dateTime: String) {
        var tz : NSTimeZone = NSTimeZone.localTimeZone()
        let components = GregorianDate.parseDateString(dateTime,timeZone: &tz, pattern: GregorianDate.dateTimePattern)
        if components == nil {
            return nil
        }
        GregorianDate.calendar.timeZone = tz
        let date = GregorianDate.calendar.dateFromComponents(components!)
        self.init(timeIntervalSinceReferenceDate: (date?.timeIntervalSinceReferenceDate)!)
        self.timeSpan = 0
        self.timezone = tz
        year = components!.year
        month = components!.month
        day = components!.day
        hour = components!.hour
        minute = components!.minute
        second = Double(components!.second)
        let nanosec = components!.nanosecond
        second += Double(nanosec)*1e-9
    }
    
    
    public convenience init?(year: Int, month: Int, day: Int, timezone: NSTimeZone) {
        self.init(year:year, month:month, day: day, hour:0, minute:0, second:0, timezone:timezone)
        self.timeSpan = 86400
        self.year = year
        self.month = month
        self.day = day
    }
    
    public convenience init?(date: String) {
        var tz : NSTimeZone = NSTimeZone.localTimeZone()
        let components = GregorianDate.parseDateString(date,timeZone: &tz, pattern: GregorianDate.datePattern)
        if components == nil {
            return nil
        }
        GregorianDate.calendar.timeZone = tz
        let date = GregorianDate.calendar.dateFromComponents(components!)
        self.init(timeIntervalSinceReferenceDate: (date?.timeIntervalSinceReferenceDate)!)
        self.timeSpan = 86400
        self.timezone = tz
    }
    
    public convenience init?(year: Int, month: Int, timezone: NSTimeZone) {
        self.init(year:year, month:month, day: 1, hour:0, minute:0, second:0, timezone:timezone)
        self.timeSpan = 86400 // TODO determine time span for the specified month
        self.year = year
        self.month = month
    }
    
    public convenience init?(gYearMonth: String) {
        var tz : NSTimeZone = NSTimeZone.localTimeZone()
        let components = GregorianDate.parseDateString(gYearMonth,timeZone: &tz, pattern: GregorianDate.gYearMonthPattern)
        if components == nil {
            return nil
        }
        GregorianDate.calendar.timeZone = tz
        let date = GregorianDate.calendar.dateFromComponents(components!)
        self.init(timeIntervalSinceReferenceDate: (date?.timeIntervalSinceReferenceDate)!)
        self.timeSpan = 86400
        // TODO determine time span for the specified month
        self.timezone = tz
    }
    
    public convenience init?(year: Int, timezone: NSTimeZone) {
        self.init(year:year, month:1, day: 1, hour:0, minute:0, second:0, timezone:timezone)
        self.timeSpan = 86400 // TODO determine time span for the specified year
        self.year = year
    }
    
    public convenience init?(gYear: String) {
        var tz : NSTimeZone = NSTimeZone.localTimeZone()
        let components = GregorianDate.parseDateString(gYear,timeZone: &tz, pattern: GregorianDate.gYearPattern)
        if components == nil {
            return nil
        }
        GregorianDate.calendar.timeZone = tz
        let date = GregorianDate.calendar.dateFromComponents(components!)
        self.init(timeIntervalSinceReferenceDate: (date?.timeIntervalSinceReferenceDate)!)
        self.timeSpan = 86400
        // TODO determine time span for the specified year
        self.timezone = tz
        
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private class func parseDateString(stringValue: String, inout timeZone: NSTimeZone, pattern : String) -> NSDateComponents? {
        do {
            let regex = try NSRegularExpression(pattern: pattern, options: [])
            let matches = regex.matchesInString(stringValue, options: [], range: NSMakeRange(0, stringValue.characters.count)) as Array<NSTextCheckingResult>
            if matches.count == 0 {
                return nil
            }else{
                let datecomponents = NSDateComponents()
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
                    timeZone = NSTimeZone.init(forSecondsFromGMT: tzhrs*3600+tzmins*60)
                }
                var year = 0
                var month = 1
                var day = 1
                var hour = 0
                var minute = 0
                var second : Double = 0
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
                datecomponents.year = year
                datecomponents.month = month
                datecomponents.day = day
                datecomponents.hour = hour
                datecomponents.minute = minute
                datecomponents.second = Int(second)
                datecomponents.nanosecond = Int((second-Double(Int(second)))*1e9)
                return datecomponents
            }
        } catch {
            
        }
        return nil
    }
}