//
//  Decimal.swift
//  
//
//  Created by Don Willems on 05/12/15.
//
//

import Foundation

/**
 This type defines a decimal numerical value as defined in the XML Schema namespace. 
 A decimal represents a subset of the real numbers, which can be represented by decimal numerals.
 The value space of decimal is the set of numbers that can be obtained by multiplying an integer (i.e. `decimalInteger`)
 by a non-positive power of ten (i.e. `decimalExponent`), i.e., expressible as i × 10^-n where i and n are integers
 and n >= 0. This implementation supports decimals with 19 decimal digits.
 */
public struct Decimal : CustomStringConvertible{
    
    /**
     The decimal integer which is multiplied by the non-positive power of ten, i.e. i in i × 10^-n.
     */
    public private(set) var decimalInteger : Int64
    
    /**
     The decimal exponent with which the decimal integer is multiplied i.e. n in n × 10^-n. The 
     decimal exponent is an unsigned byte and therefore positive.
     */
    public private(set) var decimalExponent: UInt8 = 0
    
    /**
     Returns the textual representation of the decimal. This string will consist only of digits and '.'.
     */
    public var description : String {
        get {
            var string = "\(decimalInteger)"
            if decimalExponent > 0 {
                var negative = false
                if decimalInteger < 0 {
                    negative = true
                    string = "\(-decimalInteger)"
                }
                let pos = Int(decimalExponent) - string.lengthOfBytesUsingEncoding(NSASCIIStringEncoding) + 1
                for var index = 0; index < pos ; index++ {
                    string = "0\(string)"
                }
                string = string.substringWithRange(Range<String.Index>(start: string.startIndex, end: string.endIndex.advancedBy(-Int(decimalExponent)))) + "." + string.substringWithRange(Range<String.Index>(start: string.endIndex.advancedBy(-Int(decimalExponent)), end: string.endIndex))
                if negative {
                    string = "-\(string)"
                }
            }
            return string
        }
    }
    
    /**
     This initialiser constructs a decimal number from a string . If the string is malformed (e.g. containing
     non-numerical characters or containing an exponent), the Optional decimal will be `nil`.
     
     - parameter stringValue: The string to be parsed into a decimal number.
     - returns: An optional decimal number containing the number represented by the parameter string or
                nil if the string could not be parsed into a decimal number.
     */
    public init?(stringValue : String){
        let trimmed = stringValue.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
        let range = trimmed.rangeOfString(".")
        if range != nil {
            let length = trimmed.lengthOfBytesUsingEncoding(NSASCIIStringEncoding)
            let pos = trimmed.startIndex.distanceTo(range!.startIndex)
            let string = trimmed.substringWithRange(Range<String.Index>(start: trimmed.startIndex, end: trimmed.startIndex.advancedBy(pos))) + trimmed.substringWithRange(Range<String.Index>(start: trimmed.startIndex.advancedBy(pos+1), end: trimmed.endIndex))
            let di = Int64(string)
            if di == nil {
                return nil
            }
            decimalInteger = di!
            decimalExponent = UInt8(length - pos-1)
        } else {
            let di = Int64(trimmed)
            if di == nil {
                return nil
            }
            decimalInteger = di!
            decimalExponent = 0
        }
    }
    
    /**
     Initialises a decimal number with the specified integer.
     
     - parameter integerValue: The integer with which the decimal number is instantiated.
     - returns: The decimal number.
     */
    public init(integerValue : Int){
        decimalInteger = Int64(integerValue)
    }
    
    /**
     Initialises a decimal number with the specified 64-bit integer (long).
     
     - parameter longValue: The integer with which the decimal number is instantiated.
     - returns: The decimal number.
     */
    public init(longValue : Int64){
        decimalInteger = longValue
    }
    
    /**
     Initialises a decimal number with the specified 32-bit integer (int).
     
     - parameter intValue: The integer with which the decimal number is instantiated.
     - returns: The decimal number.
     */
    public init(intValue : Int32){
        decimalInteger = Int64(intValue)
    }
    
    /**
     Initialises a decimal number with the specified 16-bit integer (short).
     
     - parameter shortValue: The integer with which the decimal number is instantiated.
     - returns: The decimal number.
     */
    public init(shortValue : Int16){
        decimalInteger = Int64(shortValue)
    }
    
    /**
     Initialises a decimal number with the specified 8-bit integer (byte).
     
     - parameter byteValue: The integer with which the decimal number is instantiated.
     - returns: The decimal number.
     */
    public init(byteValue : Int8){
        decimalInteger = Int64(byteValue)
    }
    
    /**
     Initialises a decimal number with the double precision real number.
     
     - parameter doubleValue: The double precision number with which the decimal number is instantiated.
     - returns: The decimal number, or nil if the double number contained exponents.
     */
    public init?(doubleValue : Double){
        self.init(stringValue: "\(doubleValue)")
    }
    
    /**
     Initialises a decimal number with the single precision real number.
     
     - parameter floatValue: The single precision number with which the decimal number is instantiated.
     - returns: The decimal number, or nil if the float number contained exponents.
     */
    public init?(floatValue : Float){
        self.init(stringValue: "\(floatValue)")
    }
    
    /**
     Initialises a decimal number with the specified decimal integer (i) and decimal exponent (n), where 
     the digital number is the number resulting from i × 10^-n.
     
     - parameter decimalInteger: The decimal integer (i).
     - parameter decimalExponent: The decimal exponent (n).
     
     - returns: The decimal or nil if the the decimal exponent was greater than 18.
     */
    public init?(decimalInteger : Int64, decimalExponent : UInt8){
        if decimalExponent > 18 {
            return nil
        }
        self.decimalInteger = decimalInteger
        self.decimalExponent = decimalExponent
    }
    
}


// Operators for Decimal are in MathFunctions.swift

