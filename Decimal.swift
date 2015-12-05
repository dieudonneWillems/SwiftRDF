//
//  Decimal.swift
//  
//
//  Created by Don Willems on 05/12/15.
//
//

import Foundation

public struct Decimal : CustomStringConvertible{
    
    public private(set) var decimalInteger : Int64
    
    public private(set) var decimalExponent: UInt8 = 0
    
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
    
    public init?(stringValue : String){
        let range = stringValue.rangeOfString(".")
        if range != nil {
            let length = stringValue.lengthOfBytesUsingEncoding(NSASCIIStringEncoding)
            let pos = stringValue.startIndex.distanceTo(range!.startIndex)
            let string = stringValue.substringWithRange(Range<String.Index>(start: stringValue.startIndex, end: stringValue.startIndex.advancedBy(pos))) + stringValue.substringWithRange(Range<String.Index>(start: stringValue.startIndex.advancedBy(pos+1), end: stringValue.endIndex))
            let di = Int64(string)
            if di == nil {
                return nil
            }
            decimalInteger = di!
            decimalExponent = UInt8(length - pos-1)
        } else {
            let di = Int64(stringValue)
            if di == nil {
                return nil
            }
            decimalInteger = di!
            decimalExponent = 0
        }
    }
    
    public init(integerValue : Int){
        decimalInteger = Int64(integerValue)
    }
    
    public init(longValue : Int64){
        decimalInteger = longValue
    }
    
    public init(intValue : Int32){
        decimalInteger = Int64(intValue)
    }
    
    public init(shortValue : Int16){
        decimalInteger = Int64(shortValue)
    }
    
    public init(byteValue : Int8){
        decimalInteger = Int64(byteValue)
    }
    
    public init?(doubleValue : Double){
        self.init(stringValue: "\(doubleValue)")
    }
    
    public init?(floatValue : Float){
        self.init(stringValue: "\(floatValue)")
    }
    
    public init?(decimalInteger : Int64, decimalExponent : UInt8){
        if decimalExponent > 18 {
            return nil
        }
        self.decimalInteger = decimalInteger
        self.decimalExponent = decimalExponent
    }
    
}

// TODO: operators for Binary