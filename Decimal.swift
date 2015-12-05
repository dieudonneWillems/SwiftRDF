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
            var pos = string.lengthOfBytesUsingEncoding(NSASCIIStringEncoding)-Int(decimalExponent)
            return string
        }
    }
    
    public init?(stringValue : String){
        // TODO: Initialisation with String
        return nil
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
        // TODO: Initialisation with double
        return nil
    }
    
    public init?(floatValue : Float){
        // TODO: Initialisation with float
        return nil
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