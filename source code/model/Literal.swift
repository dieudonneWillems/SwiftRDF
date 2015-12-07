//
//  Literal.swift
//  
//
//  Created by Don Willems on 20/11/15.
//
//

import Foundation

public class Literal: Value {
    
    private static let literalPattern = "^(((\"(.*)\")|('([\\w\\s]*)'))((@(\\w*))(\\^\\^xsd:(string))?|\\^\\^(xsd:(\\w*)|<(.*)>))?|([+-]?[\\d]*)|([+-]?[\\d\\.]*)|([+-]?[\\d\\.]*[eE][+-]?\\d*)|(true|false))$"
    
    // MARK: Properties
    
    /// The Datatype of the value represented by this literal (see `XSD` for the list of datatypes defined in XML Schema).
    public private(set) var dataType : Datatype?
    
    /** 
     The language (encoded as ISO-639) of the string value of the literal. 
     This is only valid if the datatype is `XSD.string`.
     */
    public private(set) var language : String?
    
    /// The boolean value of the literal.
    public private(set) var booleanValue : Bool?
    
    /// The calendar value of the literal.
    public private(set) var calendarValue : NSCalendar?
    
    /// The data value of the literal.
    public private(set) var dateValue : NSDate?
    
    /** 
     The float value of the literal. If the datatype is `XSD.double`, the float value will also represent a value,
     i.e. the same value as the double value but with a smaller precision.
     */
    public private(set) var floatValue : Float?
    
    /**
     The double value of the literal. If the datatype is `float`, the double value will also represent a value,
     i.e. the same value as the float value.
     */
    public private(set) var doubleValue : Double?
    
    /**
     The decimal value of the literal. The decimal value contains a number with a maximum of 19 digits but
     without an exponent.
     */
    public private(set) var decimalValue : Decimal?
    
    /**
     The integer value of the literal. The integer value is the native integer supported by the system, i.e.
     a 32-bit integer on 32-bit system, and a 64-bit integer on 64-but systems.
     This parameter will return a value if the value represented by the
     literal is an integer whose value is within the required range for an integer value. I.e. the presence
     of this value does not imply that the datatype of the literal is `XSD.integer`.
     */
    public private(set) var integerValue : Int?
    
    /**
     The non positive integer value of the literal. NB. The value is positive even though the integer is negative.
     If a string representation of the non-positive integer is used, a minus symbol will be present.
     This parameter will return a value if the value represented by the
     literal is an integer whose value is within the required range for a non-positive integer value. I.e. the presence
     of this value does not imply that the datatype of the literal is `XSD.nonPositiveInteger`.
     */
    public private(set) var nonPositiveIntegerValue : UInt? // NB. The value is positive even though the integer is negative
    
    /**
    The negative integer value of the literal. NB. The value is positive even though the integer is negative.
    If a string representation of the negative integer is used, a minus symbol will be present. 
    This parameter will return a value if the value represented by the
    literal is an integer whose value is within the required range for a negative integer value. I.e. the presence
    of this value does not imply that the datatype of the literal is `XSD.negativeInteger`.
    */
    public private(set) var negativeIntegerValue : UInt?  // NB. The value is positive even though the integer is negative
    
    /**
     The non-negative integer value of the literal. This parameter will return a value if the value represented by the
     literal is an integer whose value is within the required range for a non-negative integer value. I.e. the presence
     of this value does not imply that the datatype of the literal is `XSD.nonNegativeInteger`.
     */
    public private(set) var nonNegativeIntegerValue : UInt?
    
    /**
     The positive integer value of the literal. This parameter will return a value if the value represented by the
     literal is an integer whose value is within the required range for a positive integer value. I.e. the presence
     of this value does not imply that the datatype of the literal is `XSD.positiveInteger`.
     */
    public private(set) var positiveIntegerValue : UInt?
    
    /**
     The long (base-64 integer) value of the literal. This parameter will return a value if the value represented by the
     literal is an integer whose value is within the required range for a long value. I.e. the presence
     of this value does not imply that the datatype of the literal is `XSD.long`.
     */
    public private(set) var longValue : Int64?
    
    /**
     The int (base-32 integer) value of the literal. This parameter will return a value if the value represented by the
     literal is an integer whose value is within the required range for an int value. I.e. the presence
     of this value does not imply that the datatype of the literal is `XSD.int`.
     */
    public private(set) var intValue : Int32?
    
    /**
     The short (base-16 integer) value of the literal. This parameter will return a value if the value represented by the
     literal is an integer whose value is within the required range for a short value. I.e. the presence
     of this value does not imply that the datatype of the literal is `XSD.short`.
     */
    public private(set) var shortValue : Int16?
    
    /**
     The byte (base-8 integer) value of the literal. This parameter will return a value if the value represented by the
     literal is an integer whose value is within the required range for a byte value. I.e. the presence
     of this value does not imply that the datatype of the literal is `XSD.byte`.
     */
    public private(set) var byteValue : Int8?
    
    /**
     The unsigned long (base-64 unsigned integer) value of the literal. 
     This parameter will return a value if the value represented by the
     literal is an integer whose value is within the required range for an unsigned long value. I.e. the presence
     of this value does not imply that the datatype of the literal is `XSD.unsignedLong`.
     */
    public private(set) var unsignedLongValue : UInt64?
    
    /**
     The unsigned int (base-32 unsigned integer) value of the literal.
     This parameter will return a value if the value represented by the
     literal is an integer whose value is within the required range for an unsigned int value. I.e. the presence
     of this value does not imply that the datatype of the literal is `XSD.unsignedInt`.
     */
    public private(set) var unsignedIntValue : UInt32?
    
    /**
     The unsigned short (base-16 unsigned integer) value of the literal.
     This parameter will return a value if the value represented by the
     literal is an integer whose value is within the required range for an unsigned short value. I.e. the presence
     of this value does not imply that the datatype of the literal is `XSD.unsignedShort`.
     */
    public private(set) var unsignedShortValue : UInt16?
    
    /**
     The unsigned byte (base-8 unsigned integer) value of the literal.
     This parameter will return a value if the value represented by the
     literal is an integer whose value is within the required range for an unsigned byte value. I.e. the presence
     of this value does not imply that the datatype of the literal is `XSD.unsignedByte`.
     */
    public private(set) var unsignedByteValue : UInt8?
    
    /**
     This parameter is true when the value represented by the literal is a numeric value.
     */
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
                } else if dataType! == XSD.decimal {
                    return "\"\(decimalValue!)\"^^xsd:decimal";
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
    
    public convenience init?(sparqlString : String){
        do {
            let regex = try NSRegularExpression(pattern: Literal.literalPattern, options: [.CaseInsensitive])
            let matches = regex.matchesInString(sparqlString, options: [], range: NSMakeRange(0, sparqlString.characters.count)) as Array<NSTextCheckingResult>
            if matches.count == 0 {
                self.init(stringValue : sparqlString)
            }else{
                let match = matches[0]
                var dtypeStr : String? = nil
                var dtypeURI : String? = nil
                var langStr : String? = nil
                let nsstring = sparqlString as NSString
                var varStr : String = sparqlString
                if match.rangeAtIndex(4).location != NSNotFound {
                    varStr = nsstring.substringWithRange(match.rangeAtIndex(4)) as String
                }
                if match.rangeAtIndex(11).location != NSNotFound {
                    dtypeStr = nsstring.substringWithRange(match.rangeAtIndex(11)) as String
                } else if match.rangeAtIndex(14).location != NSNotFound {
                    dtypeURI = nsstring.substringWithRange(match.rangeAtIndex(14)) as String
                } else if match.rangeAtIndex(13).location != NSNotFound {
                    dtypeStr = nsstring.substringWithRange(match.rangeAtIndex(13)) as String
                }
                if match.rangeAtIndex(9).location != NSNotFound {
                    langStr = nsstring.substringWithRange(match.rangeAtIndex(9)) as String
                    dtypeStr = "string"
                }
                var datatypeFS : Datatype? = nil
                if dtypeURI != nil {
                    datatypeFS = try Datatype(uri: dtypeURI!, derivedFromDatatype: nil, isListDataType: false)
                }else if dtypeStr != nil {
                    if dtypeStr! == "string" {
                        datatypeFS = XSD.string
                    } else if dtypeStr! == "xsd:decimal" {
                        datatypeFS = XSD.decimal
                    } else if dtypeStr! == "xsd:integer" {
                        datatypeFS = XSD.integer
                    } else if dtypeStr! == "xsd:long" {
                        datatypeFS = XSD.long
                    } else if dtypeStr! == "xsd:int" {
                        datatypeFS = XSD.int
                    } else if dtypeStr! == "xsd:short" {
                        datatypeFS = XSD.short
                    } else if dtypeStr! == "xsd:byte" {
                        datatypeFS = XSD.byte
                    } else if dtypeStr! == "xsd:unsignedLong" {
                        datatypeFS = XSD.unsignedLong
                    } else if dtypeStr! == "xsd:unsignedInt" {
                        datatypeFS = XSD.unsignedInt
                    } else if dtypeStr! == "xsd:unsignedShort" {
                        datatypeFS = XSD.unsignedShort
                    } else if dtypeStr! == "xsd:unsignedByte" {
                        datatypeFS = XSD.unsignedByte
                    } else if dtypeStr! == "xsd:nonNegativeInteger" {
                        datatypeFS = XSD.nonNegativeInteger
                    } else if dtypeStr! == "xsd:positiveInteger" {
                        datatypeFS = XSD.positiveInteger
                    } else if dtypeStr! == "xsd:nonPositiveInteger" {
                        datatypeFS = XSD.nonPositiveInteger
                    } else if dtypeStr! == "xsd:negativeInteger" {
                        datatypeFS = XSD.negativeInteger
                    } else if dtypeStr! == "xsd:double" {
                        datatypeFS = XSD.double
                    } else if dtypeStr! == "xsd:float" {
                        datatypeFS = XSD.float
                    } else {
                        // TODO: add other datatype initialisers
                        datatypeFS = try Datatype(namespace: XSD.namespace(), localName: dtypeStr!, derivedFromDatatype: nil, isListDataType: false)
                    }
                } else {
                    if match.rangeAtIndex(15).location != NSNotFound {
                        datatypeFS = XSD.integer
                    } else if match.rangeAtIndex(16).location != NSNotFound {
                        datatypeFS = XSD.decimal
                    } else if match.rangeAtIndex(17).location != NSNotFound {
                        datatypeFS = XSD.double
                    } else if match.rangeAtIndex(18).location != NSNotFound {
                        datatypeFS = XSD.boolean
                    } else {
                        datatypeFS = XSD.string
                    }
                }
                if langStr != nil && datatypeFS! == XSD.string {
                    self.init(stringValue: varStr, language: langStr!)
                    self.dataType = XSD.string
                } else {
                    try self.init(stringValue: varStr, dataType: datatypeFS!)
                }
            }
        }catch {
            return nil
        }
    }
    
    public init(stringValue: String, language: String){
        super.init(stringValue: stringValue)
        self.language = language
        self.dataType = XSD.string
    }
    
    public convenience init(stringValue: String, dataType: Datatype) throws {
        self.init(stringValue: stringValue)
        self.dataType = dataType
        if dataType == XSD.string {
            // do nothing further
        }else if dataType == XSD.long {
            longValue = try Literal.parseLong(stringValue)
            self.setIntegerValues(longValue!)
        }else if dataType == XSD.integer {
            integerValue = try Literal.parseInteger(stringValue)
            longValue = Int64(integerValue!)
            self.setIntegerValues(longValue!)
        }else if dataType == XSD.decimal {
            decimalValue = Decimal(stringValue: stringValue)
            if decimalValue == nil {
                throw LiteralFormattingError.malformedNumber(message: "The decimal number \(stringValue) is malformed as it is outside the required range for a decimal or it contains illegal caharacters. ", string: stringValue)
            }
            if decimalValue != nil && decimalValue!.decimalExponent == 0 {
                self.setIntegerValues(decimalValue!.decimalInteger)
            } else if decimalValue != nil {
                doubleValue = Double((decimalValue?.description)!)
                floatValue = Float((decimalValue?.description)!)
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
            let st0 = trimmed.characters.startsWith("0".characters)
            if !trimmed.characters.startsWith("-".characters) && !st0 {
                throw LiteralFormattingError.malformedNumber(message: "The non-postive integer number \(stringValue) is malformed as it is outside the required range for a non-positive integer [-\(UInt.max),0]. ", string: stringValue)
            }
            if !st0 {
                nonPositiveIntegerValue = UInt(trimmed.substringFromIndex(trimmed.startIndex.advancedBy(1)))
            } else {
                nonPositiveIntegerValue = UInt(trimmed)
            }
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
    
    public convenience init(decimalValue : Decimal) {
        self.init(stringValue: "\(decimalValue)")
        self.decimalValue = decimalValue
        if decimalValue.decimalExponent == 0 {
            self.setIntegerValues(decimalValue.decimalInteger)
        }
        self.doubleValue = Double(decimalValue.description)
        self.floatValue = Float(decimalValue.description)
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
        self.dataType = XSD.negativeInteger
    }
    
    public convenience init?(negativeIntegerValue : UInt) {
        if negativeIntegerValue == 0 {
            return nil
        }
        self.init(nonPositiveIntegerValue:negativeIntegerValue)
        self.dataType = XSD.negativeInteger
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