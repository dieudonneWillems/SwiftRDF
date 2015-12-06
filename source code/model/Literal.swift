//
//  Literal.swift
//  
//
//  Created by Don Willems on 20/11/15.
//
//

import Foundation

public class Literal: Value {
    
    // MARK: Properties
    
    public private(set) var dataType : Datatype?
    
    public private(set) var language : String?
    
    public private(set) var booleanValue : Bool?
    
    public private(set) var calendarValue : NSCalendar?
    
    public private(set) var dateValue : NSDate?
    
    public private(set) var floatValue : Float?
    
    public private(set) var doubleValue : Double?
    
    public private(set) var decimalValue : Decimal?
    
    public private(set) var integerValue : Int?
    
    public private(set) var nonPositiveIntegerValue : UInt? // NB. The value is positive even though the integer is negative
    
    public private(set) var negativeIntegerValue : UInt?  // NB. The value is positive even though the integer is negative
    
    public private(set) var nonNegativeIntegerValue : UInt?
    
    public private(set) var positiveIntegerValue : UInt?
    
    public private(set) var longValue : Int64?
    
    public private(set) var intValue : Int32?
    
    public private(set) var shortValue : Int16?
    
    public private(set) var byteValue : Int8?
    
    public private(set) var unsignedLongValue : UInt64?
    
    public private(set) var unsignedIntValue : UInt32?
    
    public private(set) var unsignedShortValue : UInt16?
    
    public private(set) var unsignedByteValue : UInt8?
    
    public var isNumeric : Bool {
        get {
            return longValue != nil || unsignedLongValue != nil || nonPositiveIntegerValue != nil || floatValue != nil || doubleValue != nil
        }
    }
    
    // MARK: SPARQL properties
    
    /**
    The representation of this Literal as used in a SPARQL query. The format depends on the datatype
    of the literal.
    */
    public override var sparql : String {
        get{
            if dataType != nil {
                if dataType! == XSD.string {
                    if language == nil {
                        return "\"\(self.stringValue)\"^^xsd:string"
                    } else {
                        return "\"\(self.stringValue)\"@\(language!)"
                    }
                } else if dataType! == XSD.integer {
                    return "\(integerValue!)";
                } else if dataType! == XSD.long {
                    return "\"\(longValue!)\"^^xsd:long";
                } else if dataType! == XSD.int {
                    return "\"\(intValue!)\"^^xsd:int";
                } else if dataType! == XSD.short {
                    return "\"\(shortValue!)\"^^xsd:short";
                } else if dataType! == XSD.byte {
                    return "\"\(byteValue!)\"^^xsd:byte";
                } else if dataType! == XSD.unsignedLong {
                    return "\"\(unsignedLongValue!)\"^^xsd:unsignedLong";
                } else if dataType! == XSD.unsignedInt {
                    return "\"\(unsignedIntValue!)\"^^xsd:unsignedInt";
                } else if dataType! == XSD.unsignedShort {
                    return "\"\(unsignedShortValue!)\"^^xsd:unsignedShort";
                } else if dataType! == XSD.unsignedByte {
                    return "\"\(unsignedByteValue!)\"^^xsd:unsignedByte";
                } else if dataType! == XSD.nonNegativeInteger {
                    return "\"\(nonNegativeIntegerValue!)\"^^xsd:nonNegativeInteger";
                } else if dataType! == XSD.positiveInteger {
                    return "\"\(positiveIntegerValue!)\"^^xsd:positiveInteger";
                } else if dataType! == XSD.nonPositiveInteger {
                    if nonPositiveIntegerValue == 0 {
                        return "\"0\"^^xsd:nonPositiveInteger";
                    }
                    return "\"-\(nonPositiveIntegerValue!)\"^^xsd:nonPositiveInteger";
                } else if dataType! == XSD.negativeInteger {
                    return "\"-\(negativeIntegerValue!)\"^^xsd:negativeInteger";
                } else if dataType! == XSD.double {
                    let logv = log10(doubleValue!)
                    var ilogv = Int(logv)
                    var sign = "+"
                    if logv < 0 {
                        ilogv = ilogv - 1
                        sign = "-"
                    }
                    let val = doubleValue! / pow(10.0,Double(ilogv))
                    if ilogv < 0 {
                        ilogv = -ilogv
                    }
                    return "\(val)E\(sign)\(ilogv)";
                } else if dataType! == XSD.float {
                    return "\"\(floatValue!)\"^^xsd:float";
                }
            }
            return "\"\(self.stringValue)\""
        }
    }
    
    // MARK: Initialisers
    
    public override init(stringValue: String){
        super.init(stringValue: stringValue)
    }
    
    // TODO: Initialiser that parses a SPARQL representation of the literal.
    
    public init(stringValue: String, language: String){
        super.init(stringValue: stringValue)
        self.language = language
        self.dataType = XSD.string
    }
    
    public convenience init(stringValue: String, dataType: Datatype) throws {
        self.init(stringValue: stringValue)
        self.dataType = dataType
        if dataType == XSD.long {
            longValue = try Literal.parseLong(stringValue)
            self.setIntegerValues(longValue!)
        }else if dataType == XSD.integer {
            integerValue = try Literal.parseInteger(stringValue)
            longValue = Int64(integerValue!)
            self.setIntegerValues(longValue!)
        }else if dataType == XSD.decimal {
            decimalValue = Decimal(stringValue: stringValue)
            if decimalValue != nil && decimalValue!.decimalExponent == 0 {
                self.setIntegerValues(decimalValue!.decimalInteger)
            }
        }else if dataType == XSD.unsignedLong {
            unsignedLongValue = try Literal.parseUnsignedLong(stringValue)
            self.setUnsignedIntegerValues(unsignedLongValue!)
        }else if dataType == XSD.int {
            intValue = try Literal.parseInt(stringValue)
            longValue = Int64(intValue!)
            self.setIntegerValues(longValue!)
        }else if dataType == XSD.unsignedInt {
            unsignedIntValue = try Literal.parseUnsignedInt(stringValue)
            unsignedLongValue = UInt64(unsignedIntValue!)
            self.setUnsignedIntegerValues(unsignedLongValue!)
        }else if dataType == XSD.short {
            shortValue = try Literal.parseShort(stringValue)
            longValue = Int64(shortValue!)
            self.setIntegerValues(longValue!)
        }else if dataType == XSD.unsignedShort {
            unsignedShortValue = try Literal.parseUnsignedShort(stringValue)
            unsignedLongValue = UInt64(unsignedShortValue!)
            self.setUnsignedIntegerValues(unsignedLongValue!)
        }else if dataType == XSD.byte {
            byteValue = try Literal.parseByte(stringValue)
            longValue = Int64(byteValue!)
            self.setIntegerValues(longValue!)
        }else if dataType == XSD.unsignedByte {
            unsignedByteValue = try Literal.parseUnsignedByte(stringValue)
            unsignedLongValue = UInt64(unsignedByteValue!)
            self.setUnsignedIntegerValues(unsignedLongValue!)
        }else if dataType == XSD.nonNegativeInteger {
            unsignedLongValue = try Literal.parseUnsignedLong(stringValue)
            self.setUnsignedIntegerValues(unsignedLongValue!)
        }else if dataType == XSD.positiveInteger {
            unsignedLongValue = try Literal.parseUnsignedLong(stringValue)
            if unsignedLongValue == 0 {
                throw LiteralFormattingError.malformedNumber(message: "The postive integer number \(stringValue) is malformed as it is outside the required range for a positive integer [1,\(UInt.max)]. ", string: stringValue)
            }
            self.setUnsignedIntegerValues(unsignedLongValue!)
        }else if dataType == XSD.nonPositiveInteger {
            let trimmed = stringValue.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
            if !trimmed.characters.startsWith("-".characters) && !trimmed.characters.startsWith("0".characters) {
                throw LiteralFormattingError.malformedNumber(message: "The non-postive integer number \(stringValue) is malformed as it is outside the required range for a non-positive integer [-\(UInt.max),0]. ", string: stringValue)
            }
            nonPositiveIntegerValue = UInt(trimmed.substringFromIndex(trimmed.startIndex.advancedBy(1)))
            if nonPositiveIntegerValue == nil {
                throw LiteralFormattingError.malformedNumber(message: "The non-postive integer number \(stringValue) is malformed as it is outside the required range for a non-positive integer [-\(UInt.max),0]. ", string: stringValue)
            }
            if nonPositiveIntegerValue > 0 {
                negativeIntegerValue = nonPositiveIntegerValue
            }
            if UInt64(nonPositiveIntegerValue!) < UInt64(Int64.max) {
                self.setIntegerValues(Int64(trimmed)!)
            }
        }else if dataType == XSD.negativeInteger {
            let trimmed = stringValue.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
            if !trimmed.characters.startsWith("-".characters) {
                throw LiteralFormattingError.malformedNumber(message: "The non-postive integer number \(stringValue) is malformed as it is outside the required range for a non-positive integer [-\(UInt.max),-1]. ", string: stringValue)
            }
            nonPositiveIntegerValue = UInt(trimmed.substringFromIndex(trimmed.startIndex.advancedBy(1)))
            if nonPositiveIntegerValue == nil || nonPositiveIntegerValue == 0 {
                throw LiteralFormattingError.malformedNumber(message: "The non-postive integer number \(stringValue) is malformed as it is outside the required range for a non-positive integer [-\(UInt.max),-1]. ", string: stringValue)
            }
            negativeIntegerValue = nonPositiveIntegerValue
            if UInt64(nonPositiveIntegerValue!) < UInt64(Int64.max) {
                self.setIntegerValues(Int64(trimmed)!)
            }
        }else if dataType == XSD.float {
            floatValue = try Literal.parseFloat(stringValue)
        }else if dataType == XSD.double {
            doubleValue = try Literal.parseDouble(stringValue)
        }else {
        }
    }
    
    // TODO: Initialiser for decimals
    
    public convenience init(decimalValue : Decimal) {
        self.init(stringValue: "\(decimalValue)")
        self.decimalValue = decimalValue
        if decimalValue.decimalExponent == 0 {
            self.setIntegerValues(decimalValue.decimalInteger)
        }
        self.dataType = XSD.decimal
    }
    
    public convenience init(integerValue : Int) {
        self.init(stringValue: "\(integerValue)")
        self.integerValue = integerValue
        self.setIntegerValues(Int64(integerValue))
        self.dataType = XSD.integer
    }
    
    public convenience init(nonNegativeIntegerValue : UInt) {
        self.init(stringValue: "\(nonNegativeIntegerValue)")
        self.nonNegativeIntegerValue = nonNegativeIntegerValue
        self.setUnsignedIntegerValues(UInt64(nonNegativeIntegerValue))
        self.dataType = XSD.nonNegativeInteger
    }
    
    public convenience init?(positiveIntegerValue : UInt) {
        if positiveIntegerValue == 0 {
            return nil
        }
        self.init(stringValue: "\(positiveIntegerValue)")
        self.positiveIntegerValue = positiveIntegerValue
        self.setUnsignedIntegerValues(UInt64(positiveIntegerValue))
        self.dataType = XSD.positiveInteger
    }
    
    public convenience init?(nonPositiveIntegerValue : Int) {
        if nonPositiveIntegerValue > 0 {
            return nil
        }
        self.init(stringValue: "\(nonPositiveIntegerValue)")
        let longV = Int64(nonPositiveIntegerValue)
        self.setIntegerValues(longV)
        self.nonPositiveIntegerValue = UInt(-nonPositiveIntegerValue)
        self.dataType = XSD.nonPositiveInteger
    }
    
    public convenience init(nonPositiveIntegerValue : UInt) {
        self.init(stringValue: "-\(nonPositiveIntegerValue)")
        if nonPositiveIntegerValue <= UInt(Int64.max) {
            let longV = Int64(-(Int64(nonPositiveIntegerValue)))
            self.setIntegerValues(longV)
        }
        self.nonPositiveIntegerValue = nonPositiveIntegerValue
        self.dataType = XSD.nonPositiveInteger
    }
    
    public convenience init?(negativeIntegerValue : Int) {
        if negativeIntegerValue >= 0 {
            return nil
        }
        self.init(nonPositiveIntegerValue:negativeIntegerValue)
    }
    
    public convenience init?(negativeIntegerValue : UInt) {
        if negativeIntegerValue == 0 {
            return nil
        }
        self.init(nonPositiveIntegerValue:negativeIntegerValue)
    }
    
    public convenience init(longValue : Int64) {
        self.init(stringValue: "\(longValue)")
        self.longValue = longValue
        self.setIntegerValues(longValue)
        self.dataType = XSD.long
    }
    
    public convenience init(unsignedLongValue : UInt64) {
        self.init(stringValue: "\(unsignedLongValue)")
        self.unsignedLongValue = unsignedLongValue
        self.setUnsignedIntegerValues(unsignedLongValue)
        self.dataType = XSD.unsignedLong
    }
    
    public convenience init(intValue : Int32) {
        self.init(stringValue: "\(intValue)")
        self.intValue = intValue
        self.setIntegerValues(Int64(intValue))
        self.dataType = XSD.int
    }
    
    public convenience init(unsignedIntValue : UInt32) {
        self.init(stringValue: "\(unsignedIntValue)")
        self.unsignedIntValue = unsignedIntValue
        self.setUnsignedIntegerValues(UInt64(unsignedIntValue))
        self.dataType = XSD.unsignedInt
    }
    
    public convenience init(shortValue : Int16) {
        self.init(stringValue: "\(shortValue)")
        self.shortValue = shortValue
        self.setIntegerValues(Int64(shortValue))
        self.dataType = XSD.short
    }
    
    public convenience init(unsignedShortValue : UInt16) {
        self.init(stringValue: "\(unsignedShortValue)")
        self.unsignedShortValue = unsignedShortValue
        self.setUnsignedIntegerValues(UInt64(unsignedShortValue))
        self.dataType = XSD.unsignedShort
    }
    
    public convenience init(byteValue : Int8) {
        self.init(stringValue: "\(byteValue)")
        self.byteValue = byteValue
        self.setIntegerValues(Int64(byteValue))
        self.dataType = XSD.byte
    }
    
    public convenience init(unsignedByteValue : UInt8) {
        self.init(stringValue: "\(unsignedByteValue)")
        self.unsignedByteValue = unsignedByteValue
        self.setUnsignedIntegerValues(UInt64(unsignedByteValue))
        self.dataType = XSD.unsignedByte
    }
    
    public convenience init(floatValue : Float) {
        self.init(stringValue: "\(floatValue)")
        self.floatValue = floatValue
        self.doubleValue = Double(floatValue)
        self.dataType = XSD.float
    }
    
    public convenience init(doubleValue : Double) {
        self.init(stringValue: "\(doubleValue)")
        self.doubleValue = doubleValue
        self.floatValue = Float(doubleValue)
        self.dataType = XSD.double
    }
    
    // TODO: Initialiser for booleans
    
    // TODO: Initialiser for durations
    // TODO: Initialiser for dateTime
    // TODO: Initialiser for date
    // TODO: Initialiser for time
    // TODO: Initialiser for gYearMonth
    // TODO: Initialiser for gYear
    // TODO: Initialiser for gMonthDay
    // TODO: Initialiser for gMonth
    // TODO: Initialiser for gDay
    
    // TODO: Initialiser for base64Binary
    // TODO: Initialiser for hexBinary
    
    // TODO: Initialiser for anyURI
    
    // TODO: Initialiser for QName
    // TODO: Initialiser for NOTATION
    
    private func setIntegerValues(long : Int64){
        if long >= 0 {
            setUnsignedIntegerValues(UInt64(long))
        } else {
            decimalValue = Decimal(longValue: long)
            longValue = long
            if long >= Int64(Int.min) {
                integerValue = Int(long)
            }
            if UInt64(-long) <= UInt64(UInt.max) {
                negativeIntegerValue = UInt(-long)
                nonPositiveIntegerValue = negativeIntegerValue
            }
            if long >= Int64(Int32.min) {
                intValue = Int32(long)
                if long >= Int64(Int16.min) {
                    shortValue = Int16(long)
                    if long >= Int64(Int8.min) {
                        byteValue = Int8(long)
                    }
                }
            }
        }
    }
    
    private func setUnsignedIntegerValues(ulong : UInt64){
        if ulong < UInt64(Int64.max) {
            decimalValue = Decimal(longValue: Int64(ulong))
        }
        unsignedLongValue = ulong
        if ulong <= UInt64(UInt.max) {
            nonNegativeIntegerValue = UInt(ulong)
            if ulong > 0 {
                positiveIntegerValue = nonNegativeIntegerValue
            } else if ulong == 0 {
                nonPositiveIntegerValue = nonNegativeIntegerValue
            }
            if ulong <= UInt64(Int.max) {
                integerValue = Int(ulong)
            }
        }
        if ulong <= UInt64(Int64.max) {
            longValue = Int64(ulong)
            if ulong <= UInt64(UInt32.max) {
                unsignedIntValue = UInt32(ulong)
                if ulong <= UInt64(Int32.max) {
                    intValue = Int32(ulong)
                    if ulong <= UInt64(UInt16.max) {
                        unsignedShortValue = UInt16(ulong)
                        if ulong <= UInt64(Int16.max) {
                            shortValue = Int16(ulong)
                            if ulong <= UInt64(UInt8.max) {
                                unsignedByteValue = UInt8(ulong)
                                if ulong <= UInt64(Int8.max) {
                                    byteValue = Int8(ulong)
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    private static func parseInteger(integerAsString : String) throws -> Int {
        let result = Int(integerAsString)
        if result == nil {
            throw LiteralFormattingError.malformedNumber(message: "Could not create integer literal from \(integerAsString).", string: integerAsString);
        }
        return result!
    }
    
    private static func parseLong(longAsString : String) throws -> Int64 {
        let result = Int64(longAsString)
        if result == nil {
            throw LiteralFormattingError.malformedNumber(message: "Could not create 64-bit integer (long) literal from \(longAsString).", string: longAsString);
        }
        return result!
    }
    
    private static func parseUnsignedLong(longAsString : String) throws -> UInt64 {
        let result = UInt64(longAsString)
        if result == nil {
            throw LiteralFormattingError.malformedNumber(message: "Could not create 64-bit unsigned integer (long) literal from \(longAsString).", string: longAsString);
        }
        return result!
    }
    
    private static func parseInt(intAsString : String) throws -> Int32 {
        let result = Int32(intAsString)
        if result == nil {
            throw LiteralFormattingError.malformedNumber(message: "Could not create 32-bit integer (int) literal from \(intAsString).", string: intAsString);
        }
        return result!
    }
    
    private static func parseUnsignedInt(intAsString : String) throws -> UInt32 {
        let result = UInt32(intAsString)
        if result == nil {
            throw LiteralFormattingError.malformedNumber(message: "Could not create 32-bit unsigned integer (int) literal from \(intAsString).", string: intAsString);
        }
        return result!
    }
    
    private static func parseShort(intAsString : String) throws -> Int16 {
        let result = Int16(intAsString)
        if result == nil {
            throw LiteralFormattingError.malformedNumber(message: "Could not create 16-bit integer (short) literal from \(intAsString).", string: intAsString);
        }
        return result!
    }
    
    private static func parseUnsignedShort(intAsString : String) throws -> UInt16 {
        let result = UInt16(intAsString)
        if result == nil {
            throw LiteralFormattingError.malformedNumber(message: "Could not create 16-bit unsigned integer (short) literal from \(intAsString).", string: intAsString);
        }
        return result!
    }
    
    private static func parseByte(intAsString : String) throws -> Int8 {
        let result = Int8(intAsString)
        if result == nil {
            throw LiteralFormattingError.malformedNumber(message: "Could not create 8-bit integer (byte) literal from \(intAsString).", string: intAsString);
        }
        return result!
    }
    
    private static func parseUnsignedByte(intAsString : String) throws -> UInt8 {
        let result = UInt8(intAsString)
        if result == nil {
            throw LiteralFormattingError.malformedNumber(message: "Could not create 8-bit unsigned integer (byte) literal from \(intAsString).", string: intAsString);
        }
        return result!
    }
    
    private static func parseDouble(doubleAsString : String) throws -> Double {
        let result = Double(doubleAsString)
        if result == nil {
            throw LiteralFormattingError.malformedNumber(message: "Could not create double literal from \(doubleAsString).", string: doubleAsString);
        }
        return result!
    }
    
    private static func parseFloat(floatAsString : String) throws -> Float {
        let result = Float(floatAsString)
        if result == nil {
            throw LiteralFormattingError.malformedNumber(message: "Could not create float literal from \(floatAsString).", string: floatAsString);
        }
        return result!
    }
}