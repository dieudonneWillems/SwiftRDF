//
//  Duration.swift
//  
//
//  Created by Don Willems on 07/12/15.
//
//

import Foundation

/**
 A duration represents a duration of time and is expressed in a combination of six components, the number of years, months, days, hours, minutes, and seconds.
 There is no determinate relation between the different components, for instance a month may contain 28,29,30, or 31 days and a minute may contain 59, 60, or 61
 seconds (due to leap seconds). Durations can only be compared to each other when viewed in their context, i.e. the starting or ending date of the duration when
 the length of a month is known and when the addition of leap seconds is known.
 */
public struct Duration {
    
    // regular expression: ^([+-]?)P(?:([0-9]+)Y)?(?:([0-9]+)M)?(?:([0-9]+)D)?(?:T(?:([0-9]+)H)?(?:([0-9]+)M)?(?:([0-9]+(?:\.[0-9]+)?)S)?)?$
    private static let literalPattern = "^([+-]?)P(?:([0-9]+)Y)?(?:([0-9]+)M)?(?:([0-9]+)D)?(?:T(?:([0-9]+)H)?(?:([0-9]+)M)?(?:([0-9]+(?:\\.[0-9]+)?)S)?)?$"
    
    /// True when the duration is a positive duration, false if it is negative.
    public let isPositive : Bool
    
    /// The number of years in the duration.
    public let years : UInt
    
    /// The number of months in the duration.
    public let months : UInt
    
    /// The number of days in the duration.
    public let days : UInt
    
    /// The number of hours in the duration.
    public let hours : UInt
    
    /// The number of minutes in the duration.
    public let minutes : UInt
    
    /// The number of seconds (a floating point number) in the duration.
    public let seconds : Double
    
    /**
     The lexical representation of the duration.
     
     The lexical representation of a duration is of the form `±PnYnMnDTnHnMnS` where `nY` represents the number of years. All values except the number of seconds are
     unsigned integers, the number of seconds may be a floating point number. The duration may be preceded by a `+` or `-` sign when the duration is a positive duration
     (the sign is optional) or when the duration is negative (the negative sign is required). Folowing the optional sign is the letter `P` (required). Only those components
     that are not equal to 0 need to be included in the lexical representation. The letter `T` is required to separate the date from the time. For instance the representation
     `P4M` specifies a duration of four months, while the representation `PT4M` specifies a duration of four minutes.
     
     Examples: `P1347Y`, `P1347M`, `P1Y2MT2H`, `PT5.34S`, and `-P22DT5H12M`.
     */
    public var description : String {
        get {
            var descr = ""
            if !isPositive {
                descr = "-"
            }
            descr += "P"
            if years != 0 {
                descr += "\(years)Y"
            }
            if months != 0 {
                descr += "\(months)M"
            }
            if days != 0 {
                descr += "\(days)D"
            }
            if hours != 0 || minutes != 0 || seconds != 0 {
                descr += "T"
                if hours != 0 {
                    descr += "\(hours)H"
                }
                if minutes != 0 {
                    descr += "\(minutes)M"
                }
                if seconds != 0 {
                    if Double(Int(seconds)) == seconds {
                        descr += "\(Int(seconds))S"
                    } else {
                        descr += "\(seconds)S"
                    }
                }
            }
            return descr
        }
    }
    
    /**
     Creates a new Duration based on the specified time interval (in seconds). The time interval is given as a number of seconds. The corresponding 
     duration consists of only one component, i.e. the number of seconds. The time interval is returned by several methods in, for instance, the
     `NSDate` class.
     
     - parameter timeInterval: The time interval (in seconds).
     */
    public init(timeInterval : NSTimeInterval) {
        if timeInterval < 0 {
            isPositive = false
        } else {
            isPositive = true
        }
        let ti = fabs(timeInterval)
        self.seconds = ti
        self.minutes = 0
        self.hours = 0
        self.days = 0
        self.months = 0
        self.years = 0
    }
    
    /**
     Creates a new Duration based on the specified components.
     
     - parameter positive: Set to true when the duration is positive, fals when the duration is negative.
     - parameter years: The number of years.
     - parameter months: The number of months.
     - parameter days: The number of days.
     - parameter hours: The number of hours.
     - parameter minutes: The number of minutes.
     - parameter seconds: The number of seconds.
     - returns: The Duration or `nil` if the number of seconds was smaller than 0.
     */
    public init?(positive: Bool, years: UInt, months: UInt, days: UInt, hours: UInt, minutes: UInt, seconds: Double) {
        if seconds<0 {
            return nil
        }
        self.isPositive = positive
        self.years = years
        self.months = months
        self.days = days
        self.hours = hours
        self.minutes = minutes
        self.seconds = seconds
    }
    
    /**
     Creates a new duration by parsing the specified lexical representation of the duration.
     
     The lexical representation of a duration is of the form `±PnYnMnDTnHnMnS` where `nY` represents the number of years. All values except the number of seconds are
     unsigned integers, the number of seconds may be a floating point number. The duration may be preceded by a `+` or `-` sign when the duration is a positive duration
     (the sign is optional) or when the duration is negative (the negative sign is required). Folowing the optional sign is the letter `P` (required). Only those components
     that are not equal to 0 need to be included in the lexical representation. The letter `T` is required to separate the date from the time. For instance the representation
     `P4M` specifies a duration of four months, while the representation `PT4M` specifies a duration of four minutes.
     
     Examples: `P1347Y`, `P1347M`, `P1Y2MT2H`, `PT5.34S`, and `-P22DT5H12M`.
     
     - parameter stringValue: The lexical representation of the duration to be parsed.
     - returns: The duration represented by the string, or nil if the lexical representation string is not allowed.
     */
    public init?(stringValue: String){
        do {
            let regex = try NSRegularExpression(pattern: Duration.literalPattern, options: [.CaseInsensitive])
            let matches = regex.matchesInString(stringValue, options: [], range: NSMakeRange(0, stringValue.characters.count)) as Array<NSTextCheckingResult>
            if matches.count == 0 {
                return nil
            }else{
                let match = matches[0]
                let nsstring = stringValue as NSString
                var isPos : Bool = true
                if match.rangeAtIndex(1).location != NSNotFound {
                    let signstr = nsstring.substringWithRange(match.rangeAtIndex(1)) as String
                    if signstr == "-" {
                        isPos = false
                    }
                }
                self.isPositive = isPos
                if match.rangeAtIndex(2).location != NSNotFound {
                    let yearstr = nsstring.substringWithRange(match.rangeAtIndex(2)) as String
                    let yrs = UInt(yearstr)
                    if yrs != nil {
                        self.years = yrs!
                    } else {
                        self.years = 0
                    }
                } else {
                    self.years = 0
                }
                if match.rangeAtIndex(3).location != NSNotFound {
                    let monthstr = nsstring.substringWithRange(match.rangeAtIndex(3)) as String
                    let mns = UInt(monthstr)
                    if mns != nil {
                        self.months = mns!
                    } else {
                        self.months = 0
                    }
                } else {
                    self.months = 0
                }
                if match.rangeAtIndex(4).location != NSNotFound {
                    let daystr = nsstring.substringWithRange(match.rangeAtIndex(4)) as String
                    let dss = UInt(daystr)
                    if dss != nil {
                        self.days = dss!
                    } else {
                        self.days = 0
                    }
                } else {
                    self.days = 0
                }
                if match.rangeAtIndex(5).location != NSNotFound {
                    let hourstr = nsstring.substringWithRange(match.rangeAtIndex(5)) as String
                    let hrs = UInt(hourstr)
                    if hrs != nil {
                        self.hours = hrs!
                    } else {
                        self.hours = 0
                    }
                } else {
                    self.hours = 0
                }
                if match.rangeAtIndex(6).location != NSNotFound {
                    let minutestr = nsstring.substringWithRange(match.rangeAtIndex(6)) as String
                    let mins = UInt(minutestr)
                    if mins != nil {
                        self.minutes = mins!
                    } else {
                        self.minutes = 0
                    }
                } else {
                    self.minutes = 0
                }
                if match.rangeAtIndex(7).location != NSNotFound {
                    let secondstr = nsstring.substringWithRange(match.rangeAtIndex(7)) as String
                    let secs = Double(secondstr)
                    if secs != nil {
                        self.seconds = secs!
                    } else {
                        self.seconds = 0
                    }
                } else {
                    self.seconds = 0
                }
            }
        } catch {
            return nil
        }
    }
}