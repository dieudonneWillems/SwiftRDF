//
//  Duration.swift
//  
//
//  Created by Don Willems on 07/12/15.
//
//

import Foundation

public struct Duration {
    
    // regular expression: ^([+-]?)P(?:([0-9]+)Y)?(?:([0-9]+)M)?(?:([0-9]+)D)?(?:T(?:([0-9]+)H)?(?:([0-9]+)M)?(?:([0-9]+(?:\.[0-9]+)?)S)?)?$
    private static let literalPattern = "^([+-]?)P(?:([0-9]+)Y)?(?:([0-9]+)M)?(?:([0-9]+)D)?(?:T(?:([0-9]+)H)?(?:([0-9]+)M)?(?:([0-9]+(?:\\.[0-9]+)?)S)?)?$"
    
    public let isPositive : Bool
    public let years : UInt
    public let months : UInt
    public let days : UInt
    public let hours : UInt
    public let minutes : UInt
    public let seconds : Double
    
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
    
    public init(positive: Bool, years: UInt, months: UInt, days: UInt, hours: UInt, minutes: UInt, seconds: Double) {
        self.isPositive = positive
        self.years = years
        self.months = months
        self.days = days
        self.hours = hours
        self.minutes = minutes
        self.seconds = seconds
    }
    
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