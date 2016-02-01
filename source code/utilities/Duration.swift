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
    private static var _literalRegularExpression : NSRegularExpression?
    
    private static var regularExpression : NSRegularExpression {
        if _literalRegularExpression == nil {
            Duration.createRegularExpression()
        }
        return _literalRegularExpression!
    }
    
    private static func createRegularExpression() {
        do {
            _literalRegularExpression = try NSRegularExpression(pattern: literalPattern, options: [.CaseInsensitive])
        } catch {
            //should never happen.
        }
    }
    
    
    // MARK: Properties
    
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
    
    // MARK: Initialisers
    
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
        let regex = Duration.regularExpression
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
    }
    
    // MARK: Private functions
    
    /**
     Calculates the duration in seconds and returns a tuple containing three doubles,
     the expected duration in seconds, the minimum duration in seconds, and the maximum duration in
     seconds. The uncertainty is caused by leap seconds, months of different number of days,
     and leap years.
     
     - returns: The duration (expected, minimum, maximum) in seconds as a tuple.
    */
    private func durationInNanoSeconds() -> (UInt, UInt, UInt) {
        var nseconds : Double = seconds
        var nmax : Double = seconds
        var nmin : Double = seconds
    
        let (dMinutes, minMinutes, maxMinutes) = durationInMinutes()
        if dMinutes > 0 {
            nseconds += Double(dMinutes * 60)
            var minNHalfYears = 1 + minMinutes / 263520
            if minMinutes < 1 {
                minNHalfYears = 0
            }
            nmin += Double(minMinutes * 60 - minNHalfYears) // negative leap seconds one per half year max
            let maxNHalfYears = 1 + maxMinutes / 262800
            nmax += Double(maxMinutes * 60 + maxNHalfYears) // positive leap seconds one per half year max
        }
            
        let durationInSeconds = (UInt(nseconds*1e9), UInt(nmin*1e9), UInt(nmax*1e9))
        return durationInSeconds
    }
    
    /**
     Calculates the duration in minutes and returns a tuple containing three integers,
     the expected duration in minutes, the minimum duration in minutes, and the maximum duration in
     minutes. The uncertainty is caused by months of different number of days
     and leap years. Seconds are disregarded by this function.
     
     - returns: The duration (expected, minimum, maximum) in minutes as a tuple.
     */
    private func durationInMinutes() -> (UInt, UInt, UInt) {
        var nminutes : UInt = minutes
        var nmax : UInt = minutes
        var nmin : UInt = minutes
        
        nminutes += hours * 60
        nmax += hours * 60
        nmin += hours * 60
        
        nminutes += days * 1440
        nmax += days * 1440
        nmin += days * 1440
        
        let nmonths = durationInMonths()
        
        if nmonths <= 120 && nmonths > 0 {
            let ndaysFromMonths = Duration.dayInMonths[Int(nmonths)]
            nminutes += UInt(ndaysFromMonths.ndays * 1440)
            nmax += UInt(ndaysFromMonths.ndays + ndaysFromMonths.posError+0.9) * 1440
            nmin += UInt(ndaysFromMonths.ndays - ndaysFromMonths.negError-0.9) * 1440
        } else if nmonths > 120 {
            let mn = nmonths%12
            let ndaysFromMonths = Duration.dayInMonthInYear[Int(mn)]
            let ndays = ndaysFromMonths.ndays * Double(nmonths)
            nminutes += UInt(ndays * 1440)
            nmax += UInt(ndays + ndaysFromMonths.posError+0.9) * 1440
            nmin += UInt(ndays - ndaysFromMonths.negError-0.9) * 1440
        }
        
        let durationInMinutes = (nminutes, nmin, nmax)
        return durationInMinutes
    }
    
    /**
     Calculates the duration in months and returns the expected duration in months. 
     The duration in months is equal to the number of months adding the number of years times 12.
     Seconds, minutes, hours, and days are disregarded by this function.
     
     - returns: The duration in months.
     */
    private func durationInMonths() -> UInt {
        var nmonths : UInt = months
        
        nmonths += years * 12
        
        return nmonths
    }
    
    /**
     This array gives tuples for the remainder of the total number of months divided by a year, i.e. `nmonths % 12`.
     `ndays` is the average number of days in a month for each remainder. This value should be multiplied with the 
     number of months. The `posError` and `negError` are the positive and negative errors in the number of days. These
     numbers should NOT be multiplied with the number of months. The errors are smallest when the duration is a multiple
     of a whole year (only one day error per year), i.e. when `nmonths % 12 = 0`.
     
     This array can be used to compare durations where the number of months is > 120 (i.e. 10 years).
     */
    private static let dayInMonthInYear: [(ndays: Double, posError : Double, negError : Double)] = [
        (ndays: 30.4063427033538, posError: 1.7183333333378, negError: 1.68166666667094),
        (ndays: 30.4366457878586, posError: 1.88500000000931, negError: 2.11499999999069),
        (ndays: 30.4365963144368, posError: 2.97166666667908, negError: 4.14833333334536),
        (ndays: 30.43654794038, posError: 2.61833333334653, negError: 4.50166666667792),
        (ndays: 30.4365009020763, posError: 3.26500000001397, negError: 3.85500000001048),
        (ndays: 30.4364549730922, posError: 2.91166666668141, negError: 4.20833333334303),
        (ndays: 30.4364716159735, posError: 3.47500000000582, negError: 3.64500000001863),
        (ndays: 30.4364841069373, posError: 4.03833333333023, negError: 3.08166666666648),
        (ndays: 30.4365510798647, posError: 3.51833333334071, negError: 3.60166666668374),
        (ndays: 30.4366130269508, posError: 3.99833333335118, negError: 3.12166666667326),
        (ndays: 30.4366712356985, posError: 3.47833333333256, negError: 2.64166666667006),
        (ndays: 30.43672654676, posError: 3.95833333334303, negError: 3.16166666668141)
    ]
    
    /**
     This array gives the average number of days, positive and negative error for durations where the 
     number of months is between 1 and 120 inclusive.
     */
    private static let dayInMonths: [(ndays: Double, posError : Double, negError : Double)] = [
        (ndays: 30.3541666666667, posError: 0.645833333333332, negError: 2.35416666666667),
        (ndays: 60.7083333333333, posError: 1.29166666666666, negError: 2.70833333333334),
        (ndays: 91.0616666666667, posError: 0.938333333333333, negError: 3.06166666666667),
        (ndays: 121.415, posError: 1.58499999999999, negError: 2.41500000000001),
        (ndays: 151.768333333333, posError: 1.23166666666665, negError: 2.76833333333335),
        (ndays: 182.205, posError: 1.79499999999999, negError: 2.20500000000001),
        (ndays: 212.641666666667, posError: 2.35833333333332, negError: 1.64166666666668),
        (ndays: 243.161666666667, posError: 1.83833333333334, negError: 2.16166666666666),
        (ndays: 273.681666666667, posError: 2.31833333333333, negError: 1.68166666666667),
        (ndays: 304.201666666667, posError: 1.79833333333335, negError: 1.20166666666665),
        (ndays: 334.721666666667, posError: 2.27833333333331, negError: 1.72166666666669),
        (ndays: 365.241666666667, posError: 0.758333333333326, negError: 0.241666666666674),
        (ndays: 395.595, posError: 1.40499999999997, negError: 2.59500000000003),
        (ndays: 425.948333333333, posError: 2.05166666666668, negError: 2.94833333333332),
        (ndays: 456.301666666667, posError: 1.69833333333332, negError: 3.30166666666668),
        (ndays: 486.655, posError: 2.34500000000003, negError: 2.65499999999997),
        (ndays: 517.008333333333, posError: 1.99166666666667, negError: 3.00833333333333),
        (ndays: 547.445, posError: 2.55499999999995, negError: 2.44500000000005),
        (ndays: 577.881666666667, posError: 3.11833333333334, negError: 1.88166666666666),
        (ndays: 608.401666666667, posError: 2.59833333333336, negError: 2.40166666666664),
        (ndays: 638.921666666667, posError: 3.07833333333338, negError: 1.92166666666662),
        (ndays: 669.441666666667, posError: 2.55833333333328, negError: 1.44166666666672),
        (ndays: 699.961666666667, posError: 3.0383333333333, negError: 1.9616666666667),
        (ndays: 730.481666666667, posError: 0.518333333333317, negError: 0.481666666666683),
        (ndays: 760.835, posError: 1.16499999999996, negError: 2.83500000000004),
        (ndays: 791.188333333333, posError: 1.81166666666661, negError: 3.18833333333339),
        (ndays: 821.541666666667, posError: 1.45833333333337, negError: 3.54166666666663),
        (ndays: 851.895, posError: 2.10500000000002, negError: 2.89499999999998),
        (ndays: 882.248333333333, posError: 1.75166666666667, negError: 3.24833333333333),
        (ndays: 912.685, posError: 2.31500000000005, negError: 2.68499999999995),
        (ndays: 943.121666666667, posError: 2.87833333333333, negError: 2.12166666666667),
        (ndays: 973.641666666667, posError: 2.35833333333335, negError: 2.64166666666665),
        (ndays: 1004.16166666667, posError: 2.83833333333337, negError: 2.16166666666663),
        (ndays: 1034.68166666667, posError: 2.31833333333338, negError: 1.68166666666662),
        (ndays: 1065.20166666667, posError: 2.7983333333334, negError: 2.2016666666666),
        (ndays: 1095.72166666667, posError: 0.278333333333421, negError: 0.721666666666579),
        (ndays: 1126.075, posError: 0.924999999999955, negError: 3.07500000000005),
        (ndays: 1156.42833333333, posError: 1.57166666666672, negError: 3.42833333333328),
        (ndays: 1186.78166666667, posError: 1.21833333333325, negError: 3.78166666666675),
        (ndays: 1217.135, posError: 1.86500000000001, negError: 3.13499999999999),
        (ndays: 1247.48833333333, posError: 1.51166666666677, negError: 3.48833333333323),
        (ndays: 1277.925, posError: 2.07500000000005, negError: 2.92499999999995),
        (ndays: 1308.36166666667, posError: 2.63833333333332, negError: 2.36166666666668),
        (ndays: 1338.88166666667, posError: 2.11833333333334, negError: 2.88166666666666),
        (ndays: 1369.40166666667, posError: 2.59833333333336, negError: 2.40166666666664),
        (ndays: 1399.92166666667, posError: 2.07833333333338, negError: 1.92166666666662),
        (ndays: 1430.44166666667, posError: 2.55833333333339, negError: 2.44166666666661),
        (ndays: 1460.96166666667, posError: 0.0383333333334122, negError: 0.961666666666588),
        (ndays: 1491.315, posError: 0.684999999999945, negError: 3.31500000000005),
        (ndays: 1521.66833333333, posError: 1.33166666666671, negError: 3.66833333333329),
        (ndays: 1552.02166666667, posError: 0.978333333333239, negError: 4.02166666666676),
        (ndays: 1582.375, posError: 1.625, negError: 3.375),
        (ndays: 1612.72833333333, posError: 1.27166666666676, negError: 3.72833333333324),
        (ndays: 1643.165, posError: 1.83500000000004, negError: 3.16499999999996),
        (ndays: 1673.60166666667, posError: 2.39833333333331, negError: 2.60166666666669),
        (ndays: 1704.12166666667, posError: 1.87833333333333, negError: 3.12166666666667),
        (ndays: 1734.64166666667, posError: 2.35833333333335, negError: 2.64166666666665),
        (ndays: 1765.16166666667, posError: 1.83833333333337, negError: 2.16166666666663),
        (ndays: 1795.68166666667, posError: 2.31833333333338, negError: 2.68166666666662),
        (ndays: 1826.20166666667, posError: 0.798333333333403, negError: 1.2016666666666),
        (ndays: 1856.555, posError: 1.44499999999994, negError: 3.55500000000006),
        (ndays: 1886.90833333333, posError: 2.0916666666667, negError: 3.9083333333333),
        (ndays: 1917.26166666667, posError: 1.73833333333323, negError: 4.26166666666677),
        (ndays: 1947.615, posError: 2.38499999999999, negError: 3.61500000000001),
        (ndays: 1977.96833333333, posError: 2.03166666666675, negError: 3.96833333333325),
        (ndays: 2008.405, posError: 2.59500000000003, negError: 3.40499999999997),
        (ndays: 2038.84166666667, posError: 3.1583333333333, negError: 2.8416666666667),
        (ndays: 2069.36166666667, posError: 2.63833333333332, negError: 3.36166666666668),
        (ndays: 2099.88166666667, posError: 3.11833333333334, negError: 2.88166666666666),
        (ndays: 2130.40166666667, posError: 2.59833333333336, negError: 2.40166666666664),
        (ndays: 2160.92166666667, posError: 3.07833333333338, negError: 2.92166666666662),
        (ndays: 2191.44166666667, posError: 0.558333333333394, negError: 1.44166666666661),
        (ndays: 2221.795, posError: 1.20499999999993, negError: 3.79500000000007),
        (ndays: 2252.14833333333, posError: 1.85166666666646, negError: 4.14833333333354),
        (ndays: 2282.50166666667, posError: 1.49833333333345, negError: 4.50166666666655),
        (ndays: 2312.855, posError: 2.14499999999998, negError: 3.85500000000002),
        (ndays: 2343.20833333333, posError: 1.79166666666652, negError: 4.20833333333348),
        (ndays: 2373.645, posError: 2.35500000000002, negError: 3.64499999999998),
        (ndays: 2404.08166666667, posError: 2.91833333333352, negError: 3.08166666666648),
        (ndays: 2434.60166666667, posError: 2.39833333333354, negError: 3.60166666666646),
        (ndays: 2465.12166666667, posError: 2.87833333333356, negError: 3.12166666666644),
        (ndays: 2495.64166666667, posError: 2.35833333333312, negError: 2.64166666666688),
        (ndays: 2526.16166666667, posError: 2.83833333333314, negError: 3.16166666666686),
        (ndays: 2556.68166666667, posError: 0.318333333333157, negError: 1.68166666666684),
        (ndays: 2587.035, posError: 0.965000000000146, negError: 3.03499999999985),
        (ndays: 2617.38833333333, posError: 1.61166666666668, negError: 3.38833333333332),
        (ndays: 2647.74166666667, posError: 1.25833333333321, negError: 3.74166666666679),
        (ndays: 2678.095, posError: 1.9050000000002, negError: 3.0949999999998),
        (ndays: 2708.44833333333, posError: 1.55166666666673, negError: 3.44833333333327),
        (ndays: 2738.885, posError: 2.11499999999978, negError: 2.88500000000022),
        (ndays: 2769.32166666667, posError: 2.67833333333328, negError: 2.32166666666672),
        (ndays: 2799.84166666667, posError: 2.1583333333333, negError: 2.8416666666667),
        (ndays: 2830.36166666667, posError: 2.63833333333332, negError: 2.36166666666668),
        (ndays: 2860.88166666667, posError: 2.11833333333334, negError: 1.88166666666666),
        (ndays: 2891.40166666667, posError: 2.59833333333336, negError: 2.40166666666664),
        (ndays: 2921.92166666667, posError: 0.0783333333333758, negError: 0.921666666666624),
        (ndays: 2952.275, posError: 0.724999999999909, negError: 3.27500000000009),
        (ndays: 2982.62833333333, posError: 1.37166666666644, negError: 3.62833333333356),
        (ndays: 3012.98166666667, posError: 1.01833333333343, negError: 3.98166666666657),
        (ndays: 3043.335, posError: 1.66499999999996, negError: 3.33500000000004),
        (ndays: 3073.68833333333, posError: 1.3116666666665, negError: 3.6883333333335),
        (ndays: 3104.125, posError: 1.875, negError: 3.125),
        (ndays: 3134.56166666667, posError: 2.4383333333335, negError: 2.5616666666665),
        (ndays: 3165.08166666667, posError: 1.91833333333352, negError: 3.08166666666648),
        (ndays: 3195.60166666667, posError: 2.39833333333354, negError: 2.60166666666646),
        (ndays: 3226.12166666667, posError: 1.87833333333356, negError: 2.12166666666644),
        (ndays: 3256.64166666667, posError: 2.35833333333312, negError: 2.64166666666688),
        (ndays: 3287.16166666667, posError: 0.838333333333139, negError: 1.16166666666686),
        (ndays: 3317.515, posError: 1.48500000000013, negError: 3.51499999999987),
        (ndays: 3347.86833333333, posError: 2.13166666666666, negError: 3.86833333333334),
        (ndays: 3378.22166666667, posError: 1.77833333333319, negError: 4.22166666666681),
        (ndays: 3408.575, posError: 2.42500000000018, negError: 3.57499999999982),
        (ndays: 3438.92833333333, posError: 2.07166666666672, negError: 3.92833333333328),
        (ndays: 3469.365, posError: 2.63500000000022, negError: 3.36499999999978),
        (ndays: 3499.80166666667, posError: 3.19833333333327, negError: 2.80166666666673),
        (ndays: 3530.32166666667, posError: 2.67833333333328, negError: 3.32166666666672),
        (ndays: 3560.84166666667, posError: 3.1583333333333, negError: 2.8416666666667),
        (ndays: 3591.36166666667, posError: 2.63833333333332, negError: 2.36166666666668),
        (ndays: 3621.88166666667, posError: 3.11833333333334, negError: 2.88166666666666),
        (ndays: 3652.40166666667, posError: 0.598333333333358, negError: 1.40166666666664)
    ]
}

// MARK: Operators for Durations

/**
 This operator returns `true` when the Duration values are equal to each other. The returned value is an optional,
 which is `nil` if the equality cannot be determined. For instance '60 seconds == 1 minute` is not always true
 because of leap seconds.
 
 - parameter left: The left Duration in the comparison.
 - parameter right: The right Duration in the comparison.
 - returns: True when the Durations are equal, false if they are not equal, or `nil` if
    it cannot be determined whether the durations are equal.
 */
public func == (left: Duration, right: Duration) -> Bool? {
    let allequal = left.years == right.years && left.months == right.months && left.days == right.days &&
    left.hours == right.hours && left.minutes == right.minutes && left.seconds == right.seconds &&
    left.isPositive == right.isPositive
    if allequal {
        return true
    }
    if left.isPositive != right.isPositive {
        return false
    }
    
    let (nleft,nright) = durationTuplesForComparisson(left, right: right)
    
    if nleft.2 < nright.1 {
        return false
    }
    if nleft.1 > nright.2 {
        return false
    }
    
    if nleft.1 == nleft.2 && nright.1 == nright.2  && nright.0 == nleft.0 {
        return true
    }
    
    return nil
}

/**
 This operator returns `true` when the Duration values are not equal to each other. The returned value is an optional,
 which is `nil` if the equality cannot be determined. For instance '61 seconds == 1 minute` is not always false
 because of leap seconds.
 
 - parameter left: The left Duration in the comparison.
 - parameter right: The right Duration in the comparison.
 - returns: True when the Durations are not equal, false if they are equal, or `nil` if
 it cannot be determined whether the durations are not equal.
 */
public func != (left: Duration, right: Duration) -> Bool? {
    let equals = left == right
    if equals == nil {
        return nil
    }
    if !equals! {
        return true
    }
    return false
}

/**
 This operator returns `true` when the left Duration is smaller than the right Duration. The returned value is an optional,
 which is `nil` if the relation cannot be determined. For instance '59 seconds < 1 minute` is not always true
 because of leap seconds.
 
 - parameter left: The left Duration in the comparison.
 - parameter right: The right Duration in the comparison.
 - returns: True when the left Duration is smaller than the right Duration, false if the left Duration is larger than, or
 equal to the right Duration, or `nil` if the durations cannot be compared.
 */
public func < (left: Duration, right: Duration) -> Bool? {
    if left.isPositive && !right.isPositive {
        return false
    }
    
    let (nleft,nright) = durationTuplesForComparisson(left, right: right)
    
    if nleft.2 < nright.1 {
        return true
    }
    if nleft.1 > nright.2 {
        return false
    }
    if nleft.1 == nright.2 {
        if nleft.1 == nleft.2 && nright.1 == nright.2 {
            return false
        }
    }
    return nil
}

/**
 This operator returns `true` when the left Duration is smaller than or equal to the right Duration. The returned value is an optional,
 which is `nil` if the relation cannot be determined. For instance '29 days <= 1 month` is not always true
 because of the number of days in the month of February.
 
 - parameter left: The left Duration in the comparison.
 - parameter right: The right Duration in the comparison.
 - returns: True when the left Duration is smaller than or equal to the right Duration, false if the left Duration is larger than the 
 right Duration, or `nil` if the durations cannot be compared.
 */
public func <= (left: Duration, right: Duration) -> Bool? {
    if !left.isPositive && right.isPositive {
        return true
    }
    
    let equals = left == right
    if equals == nil {
        return nil
    }
    if equals! {
        return true
    }
    
    let (nleft,nright) = durationTuplesForComparisson(left, right: right)
    
    if nleft.2 < nright.1 {
        return true
    }
    if nleft.1 > nright.2 {
        return false
    }
    if nleft.1 == nright.2 {
        if nleft.1 == nleft.2 && nright.1 == nright.2 {
            return false
        }
    }
    return nil
}

/**
 This operator returns `true` when the left Duration is larger than the right Duration. The returned value is an optional,
 which is `nil` if the relation cannot be determined. For instance '61 seconds > 1 minute` is not always true
 because of leap seconds.
 
 - parameter left: The left Duration in the comparison.
 - parameter right: The right Duration in the comparison.
 - returns: True when the left Duration is larger than the right Duration, false if the left Duration is smaller than, or
 equal to the right Duration, or `nil` if the durations cannot be compared.
 */
public func > (left: Duration, right: Duration) -> Bool? {
    if !left.isPositive && right.isPositive {
        return false
    }
    
    let (nleft,nright) = durationTuplesForComparisson(left, right: right)
    
    if nleft.1 > nright.2 {
        return true
    }
    if nleft.2 < nright.1 {
        return false
    }
    if nleft.1 == nright.2 {
        if nleft.1 == nleft.2 && nright.1 == nright.2 {
            return false
        }
    }
    return nil
}

/**
 This operator returns `true` when the left Duration is larger than or equal to the right Duration. The returned value is an optional,
 which is `nil` if the relation cannot be determined. For instance '60 seconds >= 1 minute` is not always true
 because of leap seconds.
 
 - parameter left: The left Duration in the comparison.
 - parameter right: The right Duration in the comparison.
 - returns: True when the left Duration is larger than or equal to the right Duration, false if the left Duration is smaller than the
 right Duration, or `nil` if the durations cannot be compared.
 */
public func >= (left: Duration, right: Duration) -> Bool? {
    if left.isPositive && !right.isPositive {
        return true
    }
    
    let equals = left == right
    if equals == nil {
        return nil
    }
    if equals! {
        return true
    }
    
    let (nleft,nright) = durationTuplesForComparisson(left, right: right)
    
    if nleft.1 > nright.2 {
        return true
    }
    if nleft.2 < nright.1 {
        return false
    }
    if nleft.1 == nright.2 {
        if nleft.1 == nleft.2 && nright.1 == nright.2 {
            return false
        }
    }
    return nil
}

/**
 Returns a tuple consisting of two tuples each consisting of the average, the minimum and the maximum duration in either
 nanoseconds, minutes, or months for the left and right Duration respectively, and depending on which components of the 
 durations are filled in.
 */
private func durationTuplesForComparisson(left: Duration, right: Duration) -> ((UInt,UInt,UInt),(UInt,UInt,UInt)) {
    var nleft : (UInt,UInt,UInt) = (0,0,0)
    var nright : (UInt,UInt,UInt) = (0,0,0)
    if left.seconds == 0 && right.seconds == 0 {
        if left.minutes == 0 && right.minutes == 0 && left.hours == 0 && right.hours == 0 && left.days == 0 && right.days == 0 {
            let leftIM = left.durationInMonths()
            let rightIM = right.durationInMonths()
            nleft = (leftIM,leftIM,leftIM)
            nright = (rightIM,rightIM,rightIM)
        } else {
            nleft = left.durationInMinutes()
            nright = right.durationInMinutes()
        }
    } else {
        nleft = left.durationInNanoSeconds()
        nright = right.durationInNanoSeconds()
    }
    return (nleft,nright)
}