//
//  Literal.swift
//  
//
//  Created by Don Willems on 20/11/15.
//
//

import Foundation

/**
 Instances of this class represent an RDF literal, which are used for strings, numbers and dates.
 A literal may contain a language tag if the literal contains a string value, i.e. is of type `xsd:string`.
 It also contains optionally a datatype such as those defined in `XSD`. 
 
 All parameters such as `booleanValue` or `durationValue` are optionals and are by default `nil`. Depending on the datatype specific
 parameters have a value. Only `stringValue`, inheritted from `Value` is not optional. If the datatype is not a string, the `stringValue`
 will contain a textual representation of the data.
 
 All [XML Schema datatypes](http://www.w3.org/TR/xmlschema-2/) except `xsd:NOTATION`, `xsd:ENTITY` and `xsd:ENTITIES` are supported.
 */
public class Literal: Value{
    
    // regular expression: ^((("(.*)")|('([\w\s]*)'))((@(\w*(-\w*)?))(\^\^xsd:(string))?|\^\^(xsd:(\w*)|<(.*)>))?|([+-]?[\d]*)|([+-]?[\d\.]*)|([+-]?[\d\.]*[eE][+-]?\d*)|(true|false))$
    private static let literalPattern = "^(((\"(.*)\")|('([\\w\\s]*)'))((@(\\w*(-\\w*)?))(\\^\\^xsd:(string))?|\\^\\^(xsd:(\\w*)|<(.*)>))?|([+-]?[\\d]*)|([+-]?[\\d\\.]*)|([+-]?[\\d\\.]*[eE][+-]?\\d*)|(true|false))$"
    
    // MARK: Properties
    
    /// The Datatype of the value represented by this literal (see `XSD` for the list of datatypes defined in XML Schema).
    public private(set) var dataType : Datatype?
    
    /** 
     The language (encoded as ISO-639) of the string value of the literal. 
     This is only valid if the datatype is `XSD.string`.
     */
    public private(set) var language : String?
    
    
    // MARK: String subtype values
    
    /**
     The normalised string value, or `nil` if the string value is not normalised.
     */
    public var normalizedStringValue : String? {
        if !stringValue.isNormalised {
            return nil
        }
        return stringValue
    }
    
    /**
     The token value, or `nil` if the string value is not tokenised.
     */
    public var tokenValue : String? {
        if !stringValue.isTokenised {
            return nil
        }
        return stringValue
    }
    
    /**
     The language value, or `nil` if the string value is not a valid language identifier.
     This is not the language of the string value of the literal but is the content of the literal
     itself. To get the language of the string value use `Literal.language`.
     */
    public var languageValue : String? {
        if !stringValue.validLanguageIdentifier {
            return nil
        }
        return stringValue
    }
    
    /**
     The name value, or `nil` if the string value is not a valid name, i.e. of datatype `xsd:Name`.
     */
    public var NameValue : String? {
        if !stringValue.validName {
            return nil
        }
        return stringValue
    }
    
    /**
     The 'non-colonized' name value, or `nil` if the string value is not a valid 'non-colonized' name, 
     i.e. of datatype `xsd:NCName`.
     */
    public var NCNameValue : String? {
        if !stringValue.validNCName {
            return nil
        }
        return stringValue
    }
    
    /**
     The ID value, or `nil` if the string value is not a valid ID, i.e. not a 'non-colonized' name
     of datatype `xsd:ID`.
     */
    public var IDValue : String? {
        return NCNameValue
    }
    
    /**
     The IDREF value, or `nil` if the string value is not a valid IDREF, i.e. not a 'non-colonized' name
     of datatype `xsd:IDREF`.
     */
    public var IDREFValue : String? {
        return NCNameValue
    }
    
    /**
     The IDREFS value, or `nil` if the string value is not a valid list of IDREFs, i.e. not a list of 'non-colonized' names
     of datatype `xsd:IDREF`, which is of type `xsd:IDREFS`.
     */
    public private(set) var IDREFSValue : [String]?
    
    /**
     The NMTOKEN value, or `nil` if the string value is not a valid NMTOKEN, i.e. of datatype `xsd:NMTOKEN`.
     */
    public var NMTOKENValue : String? {
        if !stringValue.validNMToken {
            return nil
        }
        return stringValue
    }
    
    /**
     The NMTOKENS value, or `nil` if the string value is not a valid list of NMTOKENs, i.e. of type `xsd:NMTOKENS`.
     */
    public private(set) var NMTOKENSValue : [String]?
    
    /**
     True when the literal contains a string or one of its derived types. The datatype has to have been set, if
     the Literal was created with `init(stringValue:)`, no datatype is provided and this property will be false, 
     even if the string value is a string.
     */
    public var isStringLiteral : Bool {
        if dataType != nil {
            if dataType!.isDerivedFromDatatype(XSD.string) {
                return true
            }
        }
        return false
    }
    
    
    
    // MARK: Date and Time values
    
    /// The date value of the literal. This value can encapsulate all date/time values, including recuring dates/times.
    public private(set) var dateValue : GregorianDate?
    
    /// The duration value of the literal.
    public private(set) var durationValue : Duration?
    
    
    /**
     True when the literal contains a date, recurrent data, or duration value.
     */
    public var isDateLiteral : Bool {
        if dateValue != nil || durationValue != nil {
            return true
        }
        return false
    }
    
    
    // MARK: Numerical values
    
    /// The boolean value of the literal.
    public private(set) var booleanValue : Bool?
    
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
    public var isNumericLiteral : Bool {
        get {
            return longValue != nil || unsignedLongValue != nil || nonPositiveIntegerValue != nil || floatValue != nil || doubleValue != nil
        }
    }
    
    // MARK: Miscellaneous values
    
    /// The URI value of the literal corresponding with a value of XSD type `xsd:anyURI`.
    public private(set) var anyURIValue : URI?
    
    /// The NSData value of the literal corresponding with a value of XSD type `xsd:base64Binary` or `xsd:hexBinary`.
    public private(set) var dataValue : NSData?
    
    /**
     The qualified name value, or `nil` if the string value is not a valid qualified name,
     i.e. of datatype `xsd:QName`. An example of a qualified name is `prefix:localPart`.
     This property is the same as `Literal.qualifiedName`.
     */
    public var QNameValue : String? {
        if !stringValue.isQualifiedName {
            return nil
        }
        return stringValue
    }
    
    /**
     The qualified name, or `nil` if the string value is not a valid qualified name,
     i.e. of datatype `xsd:QName`. An example of a qualified name is `prefix:localPart`.
     This property is the same as `Literal.QNameValue`.
     */
    public var qualifiedName : String? {
        return QNameValue
    }
    
    /**
     The prefix of the qualified name, or `nil` if the string value is not a valid qualified name,
     i.e. of datatype `xsd:QName`, or the qualified name does not contain a prefix.
     An example of a qualified name is `prefix:localPart`, where
     `prefix` is the prefix of the qualified name
     */
    public var qualifiedNamePrefix : String? {
        return QNameValue?.qualifiedNamePrefix
    }
    
    /**
     The local part of the qualified name, or `nil` if the string value is not a valid qualified name,
     i.e. of datatype `xsd:QName.
     An example of a qualified name is `prefix:localPart`, where
     `localPart` is the local part of the qualified name
     */
    public var qualifiedNameLocalPart : String? {
        return QNameValue?.qualifiedNameLocalPart
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
                } else if dataType! == XSD.boolean {
                    if booleanValue != nil {
                        if booleanValue! {
                            return "true"
                        } else {
                            return "false"
                        }
                    }
                    return "\(stringValue)";
                } else if dataType! == XSD.duration {
                    return "\"\(durationValue!.description)\"^^xsd:duration";
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
                } else if dataType! == XSD.dateTime {
                    return "\"\(dateValue!.dateTime!)\"^^xsd:dateTime";
                } else if dataType! == XSD.date {
                    return "\"\(dateValue!.date!)\"^^xsd:date";
                } else if dataType! == XSD.gYearMonth {
                    return "\"\(dateValue!.gYearMonth!)\"^^xsd:gYearMonth";
                } else if dataType! == XSD.gYear {
                    return "\"\(dateValue!.gYear!)\"^^xsd:gYear";
                } else if dataType! == XSD.time {
                    return "\"\(dateValue!.time!)\"^^xsd:time";
                } else if dataType! == XSD.gMonthDay {
                    return "\"\(dateValue!.gMonthDay!)\"^^xsd:gMonthDay";
                } else if dataType! == XSD.gMonth {
                    return "\"\(dateValue!.gMonth!)\"^^xsd:gMonth";
                } else if dataType! == XSD.gDay {
                    return "\"\(dateValue!.gDay!)\"^^xsd:gDay";
                } else if dataType! == XSD.anyURI {
                    return "\"\(stringValue)\"^^xsd:anyURI";
                } else if dataType! == XSD.base64Binary {
                    return "\"\(stringValue)\"^^xsd:base64Binary";
                } else if dataType! == XSD.hexBinary {
                    return "\"\(stringValue)\"^^xsd:hexBinary";
                } else if dataType! == XSD.normalizedString {
                    return "\"\(stringValue)\"^^xsd:normalizedString";
                } else if dataType! == XSD.token {
                    return "\"\(stringValue)\"^^xsd:token";
                } else if dataType! == XSD.language {
                    return "\"\(stringValue)\"^^xsd:language";
                } else if dataType! == XSD.Name {
                    return "\"\(stringValue)\"^^xsd:Name";
                } else if dataType! == XSD.NCName {
                    return "\"\(stringValue)\"^^xsd:NCName";
                } else if dataType! == XSD.ID {
                    return "\"\(stringValue)\"^^xsd:ID";
                } else if dataType! == XSD.IDREF {
                    return "\"\(stringValue)\"^^xsd:IDREF";
                } else if dataType! == XSD.IDREFS {
                    return "\"\(stringValue)\"^^xsd:IDREFS";
                } else if dataType! == XSD.NMTOKEN {
                    return "\"\(stringValue)\"^^xsd:NMTOKEN";
                } else if dataType! == XSD.NMTOKENS {
                    return "\"\(stringValue)\"^^xsd:NMTOKENS";
                } else if dataType! == XSD.QName {
                    return "\"\(stringValue)\"^^xsd:QName";
                }
            }
            return "\"\(self.stringValue)\""
        }
    }
    
    // MARK: Initialisers
    
    /**
     The default initialiser takes a string value and initialises the Literal with that string. No
     datatype or language (if a string) is deduced from the string. If the string value is a representation
     of a number, the value will still only be interpreted as a string value without any datatype information.
    
     - parameter stringValue: The string value with which the Literal is instantiated.
     */
    public override init(stringValue: String){
        super.init(stringValue: stringValue)
    }
    
    
    /**
     This initialiser takes a string value in SPARQL format and initialises the Literal with the contents of that
     string. A literal in SPARQL format is of the form: `"[value]"[@[language]][^^[datatype]]` where language and
     datatype are optional. If a language is provided than the datatype is required to be of type `XSD.string`. 
     If neither language or datatype is provided, the datatype is assumed to be `XSD.string`.
     
     For some datatypes such as `XSD.integer` and `XSD.boolean`, quotes are not necessary to deduce the datatype.
     
     Examples:
     
      - `"chat"`
      - `'chat'@fr` with language tag `"fr"`
      - `"xyz"^^<http://example.org/ns/userDatatype>`
      - `1`, which is the same as `"1"^^xsd:integer`
      - `1.3`, which is the same as `"1.3"^^xsd:decimal`
      - `1.300`, which is the same as `"1.300"^^xsd:decimal`
      - `1.0e6`, which is the same as `"1.0e6"^^xsd:double`
      - `true`, which is the same as `"true"^^xsd:boolean`
      - `false`, which is the same as `"false"^^xsd:boolean`
     
     - parameter stringValue: The string value with which the Literal is instantiated.
     - returns: The initialised literal, or nil when the value was not valid for the provided datatype.
     */
    public convenience init?(sparqlString : String){
        do {
            let regex = try NSRegularExpression(pattern: Literal.literalPattern, options: [.DotMatchesLineSeparators])
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
                if match.rangeAtIndex(12).location != NSNotFound {
                    dtypeStr = nsstring.substringWithRange(match.rangeAtIndex(12)) as String
                } else if match.rangeAtIndex(15).location != NSNotFound {
                    dtypeURI = nsstring.substringWithRange(match.rangeAtIndex(15)) as String
                } else if match.rangeAtIndex(14).location != NSNotFound {
                    dtypeStr = nsstring.substringWithRange(match.rangeAtIndex(14)) as String
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
                    } else if dtypeStr! == "xsd:duration" {
                        datatypeFS = XSD.duration
                    } else if dtypeStr! == "xsd:decimal" {
                        datatypeFS = XSD.decimal
                    } else if dtypeStr! == "xsd:boolean" {
                        datatypeFS = XSD.boolean
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
                    } else if dtypeStr! == "xsd:dateTime" {
                        datatypeFS = XSD.dateTime
                    } else if dtypeStr! == "xsd:date" {
                        datatypeFS = XSD.date
                    } else if dtypeStr! == "xsd:gYearMonth" {
                        datatypeFS = XSD.gYearMonth
                    } else if dtypeStr! == "xsd:gYear" {
                        datatypeFS = XSD.gYear
                    } else if dtypeStr! == "xsd:time" {
                        datatypeFS = XSD.time
                    } else if dtypeStr! == "xsd:gMonthDay" {
                        datatypeFS = XSD.gMonthDay
                    } else if dtypeStr! == "xsd:gMonth" {
                        datatypeFS = XSD.gMonth
                    } else if dtypeStr! == "xsd:gDay" {
                        datatypeFS = XSD.gDay
                    } else if dtypeStr! == "xsd:anyURI" {
                        datatypeFS = XSD.anyURI
                    } else if dtypeStr! == "xsd:base64Binary" {
                        datatypeFS = XSD.base64Binary
                    } else if dtypeStr! == "xsd:hexBinary" {
                        datatypeFS = XSD.hexBinary
                    } else if dtypeStr! == "xsd:token" {
                        datatypeFS = XSD.token
                    } else if dtypeStr! == "xsd:normalizedString" || dtypeStr! == "normalizedString" {
                        datatypeFS = XSD.normalizedString
                    } else if dtypeStr! == "xsd:language" || dtypeStr! == "language" {
                        datatypeFS = XSD.language
                    } else if dtypeStr! == "xsd:Name" || dtypeStr! == "Name" {
                        datatypeFS = XSD.Name
                    } else if dtypeStr! == "xsd:NCName" || dtypeStr! == "NCName" {
                        datatypeFS = XSD.NCName
                    } else if dtypeStr! == "xsd:ID" || dtypeStr! == "ID" {
                        datatypeFS = XSD.ID
                    } else if dtypeStr! == "xsd:IDREF" || dtypeStr! == "IDREF" {
                        datatypeFS = XSD.IDREF
                    } else if dtypeStr! == "xsd:IDREFS" || dtypeStr! == "IDREFS" {
                        datatypeFS = XSD.IDREFS
                    } else if dtypeStr! == "xsd:NMTOKEN" || dtypeStr! == "NMTOKEN" {
                        datatypeFS = XSD.NMTOKEN
                    } else if dtypeStr! == "xsd:NMTOKENS" || dtypeStr! == "NMTOKENS" {
                        datatypeFS = XSD.NMTOKENS
                    } else if dtypeStr! == "xsd:QName" || dtypeStr! == "QName" {
                        datatypeFS = XSD.QName
                    } else {
                        datatypeFS = try Datatype(namespace: XSD.namespace(), localName: dtypeStr!, derivedFromDatatype: nil, isListDataType: false)
                    }
                } else {
                    if match.rangeAtIndex(16).location != NSNotFound {
                        datatypeFS = XSD.integer
                    } else if match.rangeAtIndex(17).location != NSNotFound {
                        datatypeFS = XSD.decimal
                    } else if match.rangeAtIndex(18).location != NSNotFound {
                        datatypeFS = XSD.double
                    } else if match.rangeAtIndex(19).location != NSNotFound {
                        datatypeFS = XSD.boolean
                    } else {
                        datatypeFS = XSD.string
                    }
                }
                if langStr != nil && datatypeFS! == XSD.string {
                    self.init(stringValue: varStr, language: langStr!)
                    self.dataType = XSD.string
                } else {
                    self.init(stringValue: varStr, dataType: datatypeFS!)
                }
            }
        }catch {
            return nil
        }
    }
    
    /**
     Initialises a new String literal with the specified string value and the specified language in which
     the text of the string is expressed. If the language is not a valid language identifier, a `nil` value will
     be returned. A valid language identifier does not necessarily identify an existing language.
     
     - parameter stringValue: The string containing the text.
     - parameter language: The language of the text.
     - returns: The string literal or `nil` if the language was not a valid language identifier.
     */
    public convenience init?(stringValue: String, language: String){
        if !language.validLanguageIdentifier {
            return nil
        }
        self.init(stringValue: stringValue)
        self.language = language
        self.dataType = XSD.string
    }
    
    /**
     Initialises a new literal of the specified datatype and with a value equal to the value represented
     in the string value. The string value is parsed according to the specified data type.
     
     - parameter stringValue: The string representation of the value of the literal.
     - parameter dataType: The data type of the literal.
     - returns: The initialised literal or nil if the string value was not in the correct format or if it 
     was outside the range of the datatype.
     */
    public convenience init?(stringValue: String, dataType: Datatype) {
        self.init(stringValue: stringValue)
        self.dataType = dataType
        do {
            if dataType == XSD.string {
                // do nothing further
            }else if dataType == XSD.duration {
                durationValue = Duration(stringValue: stringValue)
            }else if dataType == XSD.boolean {
                booleanValue = try Literal.parseBoolean(stringValue)
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
                    return nil
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
                    return nil
                }
                self.setUnsignedIntegerValues(unsignedLongValue!)
            }else if dataType == XSD.nonPositiveInteger {
                let trimmed = stringValue.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
                let st0 = trimmed.characters.startsWith("0".characters)
                if !trimmed.characters.startsWith("-".characters) && !st0 {
                    return nil
                }
                if !st0 {
                    nonPositiveIntegerValue = UInt(trimmed.substringFromIndex(trimmed.startIndex.advancedBy(1)))
                } else {
                    nonPositiveIntegerValue = UInt(trimmed)
                }
                if nonPositiveIntegerValue == nil {
                    return nil
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
                    return nil
                }
                nonPositiveIntegerValue = UInt(trimmed.substringFromIndex(trimmed.startIndex.advancedBy(1)))
                if nonPositiveIntegerValue == nil || nonPositiveIntegerValue == 0 {
                    return nil
                }
                negativeIntegerValue = nonPositiveIntegerValue
                if UInt64(nonPositiveIntegerValue!) < UInt64(Int64.max) {
                    self.setIntegerValues(Int64(trimmed)!)
                }
            }else if dataType == XSD.float {
                floatValue = try Literal.parseFloat(stringValue)
            }else if dataType == XSD.double {
                doubleValue = try Literal.parseDouble(stringValue)
            }else if dataType == XSD.dateTime {
                dateValue = GregorianDate(dateTime:stringValue)
                if dateValue == nil {
                    return nil
                }
            }else if dataType == XSD.date {
                dateValue = GregorianDate(date:stringValue)
                if dateValue == nil {
                    return nil
                }
            }else if dataType == XSD.gYearMonth {
                dateValue = GregorianDate(gYearMonth:stringValue)
                if dateValue == nil {
                    return nil
                }
            }else if dataType == XSD.gYear {
                dateValue = GregorianDate(gYear:stringValue)
                if dateValue == nil {
                    return nil
                }
            }else if dataType == XSD.time {
                dateValue = GregorianDate(time:stringValue)
                if dateValue == nil {
                    return nil
                }
            }else if dataType == XSD.gMonthDay {
                dateValue = GregorianDate(gMonthDay:stringValue)
                if dateValue == nil {
                    return nil
                }
            }else if dataType == XSD.gMonth {
                dateValue = GregorianDate(gMonth:stringValue)
                if dateValue == nil {
                    return nil
                }
            }else if dataType == XSD.gDay {
                dateValue = GregorianDate(gDay:stringValue)
                if dateValue == nil {
                    return nil
                }
            }else if dataType == XSD.anyURI {
                do {
                    anyURIValue = try URI(string: stringValue)
                    if anyURIValue == nil {
                        return nil
                    }
                } catch {
                    return nil
                }
            }else if dataType == XSD.base64Binary {
                dataValue = stringValue.dataFromBase64BinaryString()
                if dataValue == nil {
                    return nil
                }
            }else if dataType == XSD.hexBinary {
                dataValue = stringValue.dataFromHexadecimalString()
                if dataValue == nil {
                    return nil
                }
            }else if dataType == XSD.normalizedString {
                if !stringValue.isNormalised {
                    return nil
                }
            }else if dataType == XSD.token {
                if !stringValue.isTokenised {
                    return nil
                }
            }else if dataType == XSD.language {
                if !stringValue.validLanguageIdentifier {
                    return nil
                }
            }else if dataType == XSD.Name {
                if !stringValue.validName {
                    return nil
                }
            }else if dataType == XSD.NCName {
                if !stringValue.validNCName {
                    return nil
                }
            }else if dataType == XSD.ID {
                if !stringValue.validNCName {
                    return nil
                }
            }else if dataType == XSD.IDREF {
                if !stringValue.validNCName {
                    return nil
                }
            }else if dataType == XSD.IDREFS {
                IDREFSValue = stringValue.characters.split{$0 == " "}.map(String.init)
                if IDREFSValue == nil || IDREFSValue!.count <= 0 {
                    return nil
                }
                for idref in IDREFSValue! {
                    if !idref.validNCName {
                        return nil
                    }
                }
            }else if dataType == XSD.NMTOKEN {
                if !stringValue.validNMToken {
                    return nil
                }
            }else if dataType == XSD.NMTOKENS {
                NMTOKENSValue = stringValue.characters.split{$0 == " "}.map(String.init)
                if NMTOKENSValue == nil || NMTOKENSValue!.count <= 0 {
                    return nil
                }
                for idref in NMTOKENSValue! {
                    if !idref.validNMToken {
                        return nil
                    }
                }
            }else if dataType == XSD.QName {
                if !stringValue.isQualifiedName {
                    return nil
                }
            }else {
            }
        } catch {
           return nil
        }
    }
    
    // MARK: Initialisers for String subtypes
    
    /**
     Creates a new Literal with the specified normalised string as value. If the string is not a 
     normalised string (i.e. with a newline, carriage return, or tab characters) `nil` will
     be returned. The data type of the literal will be `xsd:normalizedString`.
     
     - parameter normalisedStringValue: The normalised string value.
     - returns: The literal containing the normalised string, or `nil` if the string parameter is not
     a normalised string.
     */
    public convenience init?(normalisedStringValue : String){
        if !normalisedStringValue.isNormalised {
            return nil
        }
        self.init(stringValue: normalisedStringValue, dataType: XSD.normalizedString)
    }
    
    /**
     Creates a new Literal with the specified token as value. If the string is not a
     token (i.e. with a newline, carriage return, or tab characters, leading or trailing spaces
     or sequences of two or more spaces) `nil` will
     be returned. The data type of the literal will be `xsd:token`.
     
     - parameter tokenValue: The token value.
     - returns: The literal containing the token, or `nil` if the string parameter is not a token.
     */
    public convenience init?(tokenValue : String){
        if !tokenValue.isTokenised {
            return nil
        }
        self.init(stringValue: tokenValue, dataType: XSD.token)
    }
    
    /**
     Creates a new Literal with the specified language identifier as value. If the string is not a
     valid language identifier `nil` will be returned. The data type of the literal will be `xsd:language`.
     
     - parameter languageValue: The language identifier value.
     - returns: The literal containing the language, or `nil` if the string parameter is not a 
     valid language identifier.
     */
    public convenience init?(languageValue : String){
        if !languageValue.validLanguageIdentifier {
            return nil
        }
        self.init(stringValue: languageValue, dataType: XSD.language)
    }
    
    /**
     Creates a new Literal with the specified Name as value. If the string is not a
     valid Name `nil` will be returned. The data type of the literal will be `xsd:Name`.
     
     - parameter NameValue: The Name value.
     - returns: The literal containing the Name, or `nil` if the string parameter is not a
     valid Name.
     */
    public convenience init?(NameValue : String){
        if !NameValue.validName {
            return nil
        }
        self.init(stringValue: NameValue, dataType: XSD.Name)
    }
    
    /**
     Creates a new Literal with the specified 'non-colonized' Name as value. If the string is not a
     valid 'non-colonized' Name `nil` will be returned. The data type of the literal will be `xsd:NCName`.
     
     - parameter NCNameValue: The 'non-colonized' Name value.
     - returns: The literal containing the 'non-colonized' Name, or `nil` if the string parameter is not a
     valid 'non-colonized' Name.
     */
    public convenience init?(NCNameValue : String){
        if !NCNameValue.validName {
            return nil
        }
        self.init(stringValue: NCNameValue, dataType: XSD.NCName)
    }
    
    /**
     Creates a new Literal with the specified ID as value. If the string is not a
     valid ID `nil` will be returned. The data type of the literal will be `xsd:ID`.
     
     - parameter IDValue: The ID value.
     - returns: The literal containing the ID, or `nil` if the string parameter is not a
     valid ID.
     */
    public convenience init?(IDValue : String){
        if !IDValue.validNCName {
            return nil
        }
        self.init(stringValue: IDValue, dataType: XSD.ID)
    }
    
    /**
     Creates a new Literal with the specified IDREF as value. If the string is not a
     valid IDREF `nil` will be returned. The data type of the literal will be `xsd:IDREF`.
     
     - parameter IDREFValue: The IDREF value.
     - returns: The literal containing the IDREF, or `nil` if the string parameter is not a
     valid IDREF.
     */
    public convenience init?(IDREFValue : String){
        if !IDREFValue.validNCName {
            return nil
        }
        self.init(stringValue: IDREFValue, dataType: XSD.IDREF)
    }
    
    /**
     Creates a new Literal with the specified list of IDREFs as value. If the list contains non-valid IDREFs,
     `nil` will be returned. The data type of the literal will be `xsd:IDREFS`.
     
     - parameter IDREFSValue: The list of IDREFs.
     - returns: The literal containing the list of IDREFS, or `nil` if the list contains non-valid IDREFs, or
     when the number of IDREFs is less than 1.
     */
    public convenience init?(IDREFSValue : [String]){
        if IDREFSValue.count <= 0 {
            return nil
        }
        var strval = ""
        for idref in IDREFSValue {
            if !idref.validNCName {
                return nil
            }
            if strval.characters.count > 0 {
                strval += " "
            }
            strval += idref
        }
        self.init(stringValue: strval)
        self.dataType = XSD.IDREFS
        self.IDREFSValue = IDREFSValue
    }
    
    /**
     Creates a new Literal with the specified NMTOKEN as value. If the string is not a
     valid NMTOKEN `nil` will be returned. The data type of the literal will be `xsd:NMTOKEN`.
     
     - parameter NMTOKENValue: The NMTOKEN value.
     - returns: The literal containing the NMTOKEN, or `nil` if the string parameter is not a
     valid NMTOKEN.
     */
    public convenience init?(NMTOKENValue : String){
        if !NMTOKENValue.validNMToken {
            return nil
        }
        self.init(stringValue: NMTOKENValue, dataType: XSD.NMTOKEN)
    }
    
    /**
     Creates a new Literal with the specified list of NMTOKENs as value. If the list contains non-valid NMTOKENs,
     `nil` will be returned. The data type of the literal will be `xsd:NMTOKENS`.
     
     - parameter NMTOKENSValue: The list of NMTOKNEs.
     - returns: The literal containing the list of NMTOKENs, or `nil` if the list contains non-valid NMTOKENs, or
     when the number of NMTOKENs is less than 1.
     */
    public convenience init?(NMTOKENSValue : [String]){
        if NMTOKENSValue.count <= 0 {
            return nil
        }
        var strval = ""
        for nmtoken in NMTOKENSValue {
            if !nmtoken.validNMToken {
                return nil
            }
            if strval.characters.count > 0 {
                strval += " "
            }
            strval += nmtoken
        }
        self.init(stringValue: strval)
        self.dataType = XSD.NMTOKENS
        self.NMTOKENSValue = NMTOKENSValue
    }
    
    
    
    // MARK: Initialisers for Date and Time Literals
    
    /**
    Creates a new Literal with the specified Gregorian date, which can represent values for the different
    date and time datatypes defined for XML Schema.
    
    - parameter gregorianDate: The Gregorian date value.
    */
    public convenience init(gregorianDate : GregorianDate) {
        self.init(stringValue: "\(gregorianDate)")
        self.dateValue = gregorianDate
        self.dataType = gregorianDate.XSDDataType
    }
    
    /**
     Creates a new Literal with the specified `NSDate` instance.
     
     - parameter date: The date as an `NSDate` instance.
     */
    public convenience init(date : NSDate) {
        let gregorianDate = GregorianDate(date: date)
        self.init(stringValue: "\(gregorianDate)")
        self.dateValue = gregorianDate
        self.dataType = gregorianDate.XSDDataType
    }
    
    /**
     Creates a new Literal with a Gregorian date and time as value and with an `XSD.dateTime` datatype.
     
     - parameter dateValue: The date value.
     - returns: The created literal or `nil` if the Gregorian date is not of type `xsd:dateTime`.
     */
    public convenience init?(dateTimeValue : GregorianDate) {
        let datatype = dateTimeValue.XSDDataType
        if datatype == nil ||  datatype! != XSD.dateTime {
            return nil
        }
        self.init(stringValue: "\(dateTimeValue)")
        self.dateValue = dateTimeValue
        self.dataType = XSD.dateTime
    }
    
    /**
     Creates a new Literal with a Gregorian date (including time of day) as value and with an
     `XSD.dateTime` datatype.
     The date only contains date information and does not include time of day. 
     This date, therefore, specifies a whole day.
     
     - parameter dateValue: The date value.
     - returns: The created literal or `nil` if the Gregorian date is not of type `xsd:date`.
     */
    public convenience init?(dateValue : GregorianDate) {
        let datatype = dateValue.XSDDataType
        if datatype == nil ||  datatype! != XSD.date {
            return nil
        }
        self.init(stringValue: "\(dateValue)")
        self.dateValue = dateValue
        self.dataType = XSD.date
    }
    
    /**
     Creates a new Literal with a Gregorian date, containing only a year and a month as value and with an
     `XSD.gYearMonth` datatype. This date specifies a whole month.
     
     - parameter gYearMonthValue: The date value containing only year and month.
     - returns: The created literal or `nil` if the Gregorian date is not of type `xsd:gYearMonth`.
     */
    public convenience init?(gYearMonthValue : GregorianDate) {
        let datatype = gYearMonthValue.XSDDataType
        if datatype == nil ||  datatype! != XSD.gYearMonth {
            return nil
        }
        self.init(stringValue: "\(gYearMonthValue)")
        self.dateValue = gYearMonthValue
        self.dataType = XSD.gYearMonth
    }
    
    /**
     Creates a new Literal with a Gregorian date, containing only a year as value and with an
     `XSD.gYear` datatype. This date specifies a whole year.
     
     - parameter gYearValue: The date value containing only year.
     - returns: The created literal or `nil` if the Gregorian date is not of type `xsd:gYear`.
     */
    public convenience init?(gYearValue : GregorianDate) {
        let datatype = gYearValue.XSDDataType
        if datatype == nil ||  datatype! != XSD.gYear {
            return nil
        }
        self.init(stringValue: "\(gYearValue)")
        self.dateValue = gYearValue
        self.dataType = XSD.gYear
    }
    
    /**
     Creates a new Literal with a recuring Gregorian date, containing the time of day as value and with an
     `XSD.time` datatype. This date specifies a time that recurs every day.
     
     - parameter timeValue: The time value.
     - returns: The created literal or `nil` if the Gregorian date is not of type `xsd:time`.
     */
    public convenience init?(timeValue : GregorianDate) {
        let datatype = timeValue.XSDDataType
        if datatype == nil ||  datatype! != XSD.time {
            return nil
        }
        self.init(stringValue: "\(timeValue)")
        self.dateValue = timeValue
        self.dataType = XSD.time
    }
    
    /**
     Creates a new Literal with a recuring Gregorian date, containing the month and day components as value and with an
     `XSD.gMonthDay` datatype. This date specifies a date that recurs every year.
     
     - parameter gMonthDayValue: The date value containing the month and day components.
     - returns: The created literal or `nil` if the Gregorian date is not of type `xsd:gMonthDay`.
     */
    public convenience init?(gMonthDayValue : GregorianDate) {
        let datatype = gMonthDayValue.XSDDataType
        if datatype == nil ||  datatype! != XSD.gMonthDay {
            return nil
        }
        self.init(stringValue: "\(gMonthDayValue)")
        self.dateValue = gMonthDayValue
        self.dataType = XSD.gMonthDay
    }
    
    /**
     Creates a new Literal with a recuring Gregorian date, containing the month as value and with an
     `XSD.gMonth` datatype. This date specifies a month that recurs every year.
     
     - parameter gMonthValue: The month value.
     - returns: The created literal or `nil` if the Gregorian date is not of type `xsd:gMonth`.
     */
    public convenience init?(gMonthValue : GregorianDate) {
        let datatype = gMonthValue.XSDDataType
        if datatype == nil ||  datatype! != XSD.gMonth {
            return nil
        }
        self.init(stringValue: "\(gMonthValue)")
        self.dateValue = gMonthValue
        self.dataType = XSD.gMonth
    }
    
    /**
     Creates a new Literal with a recuring Gregorian date, containing the day as value and with an
     `XSD.gDay` datatype. This date specifies a day that recurs every month.
     
     - parameter gDayValue: The month value.
     - returns: The created literal or `nil` if the Gregorian date is not of type `xsd:gDay`.
     */
    public convenience init?(gDayValue : GregorianDate) {
        let datatype = gDayValue.XSDDataType
        if datatype == nil ||  datatype! != XSD.gDay {
            return nil
        }
        self.init(stringValue: "\(gDayValue)")
        self.dateValue = gDayValue
        self.dataType = XSD.gDay
    }
    
    /**
     Creates a new Literal with a duration as value and with an `XSD.duration` datatype.
     
     - parameter durationValue: The duration.
     */
    public convenience init(durationValue : Duration) {
        self.init(stringValue: "\(durationValue.description)")
        self.durationValue = durationValue
        self.dataType = XSD.duration
    }
    
    /**
     Creates a new Literal with a duration expressed as a time interval as value and with an `XSD.duration` datatype.
     
     - parameter timeInterval: The time interval in seconds.
     */
    public convenience init(timeInterval : NSTimeInterval) {
        let durval = Duration(timeInterval: timeInterval)
        self.init(stringValue: "\(durval.description)")
        self.durationValue = durval
        self.dataType = XSD.duration
    }
    
    /**
     Creates a new Literal with a duration expressed as in its components as value and with an `XSD.duration` datatype.
     
     - parameter positive: Set to true when the duration is positive, false otherwise.
     - parameter years: The number of years in the duration.
     - parameter months: The number of months in the duration.
     - parameter days: The number of days in the duration.
     - parameter hours: The number of hours in the duration.
     - parameter minutes: The number of minutes in the duration.
     - parameter seconds: The number of seconds in the duration.
     - returns: The Literal or `nil` if the literal could not be instantiated (i.e. the number of seconds was smaller than 0).
     */
    public convenience init?(positive: Bool, years: UInt, months: UInt, days: UInt, hours: UInt, minutes: UInt, seconds: Double) {
        let durval = Duration(positive: positive, years: years, months: months, days: days, hours: hours, minutes: minutes, seconds: seconds)
        if durval == nil {
            return nil
        }
        self.init(stringValue: "\(durval!.description)")
        self.durationValue = durval
        self.dataType = XSD.duration
    }
    
    // MARK: Initialisers for Booleans and Numbers
    
    /**
     Creates a new Literal with a boolean as value and with an `XSD.boolean` datatype.
     
     - parameter booleanValue: The boolean value.
     */
    public convenience init(booleanValue : Bool) {
        self.init(stringValue: "\(booleanValue)")
        self.booleanValue = booleanValue
        self.dataType = XSD.boolean
    }
    
    
    /**
     Creates a new Literal with a `Decimal` as value and with an `XSD.decimal` datatype.
     A decimal represents a subset of the real numbers, which can be represented by decimal numerals.
     The value space of decimal is the set of numbers that can be obtained by multiplying an integer (i.e. `decimalInteger`)
     by a non-positive power of ten (i.e. `decimalExponent`), i.e., expressible as i × 10^-n where i and n are integers
     and n >= 0. This implementation supports decimals with 19 decimal digits.
     
     - parameter decimalValue: The decimal value.
     */
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
    
    /**
     Creates a new Literal with a integer as value and with an `XSD.integer` datatype.
     The type of the integer is the natively supported type of integer, i.e. a 32-bit integer on 32-bit systems and
     a 64-bit integer on 64-bit systems.
     
     - parameter integerValue: The integer value.
     */
    public convenience init(integerValue : Int) {
        self.init(stringValue: "\(integerValue)")
        self.integerValue = integerValue
        self.setIntegerValues(Int64(integerValue))
        self.dataType = XSD.integer
    }
    
    /**
     Creates a new Literal with a non-negative integer as value and with an `XSD.nonNegativeInteger` datatype. The integer
     needs to be in the range [0,UInt.max] where UInt.max is the maximum integer value supported by the system.
     The type of the integer is the natively supported type of integer, i.e. a 32-bit integer on 32-bit systems and
     a 64-bit integer on 64-bit systems.
     
     - parameter nonNegativeIntegerValue: The non-negative integer value.
     */
    public convenience init(nonNegativeIntegerValue : UInt) {
        self.init(stringValue: "\(nonNegativeIntegerValue)")
        self.nonNegativeIntegerValue = nonNegativeIntegerValue
        self.setUnsignedIntegerValues(UInt64(nonNegativeIntegerValue))
        self.dataType = XSD.nonNegativeInteger
    }
    
    /**
     Creates a new Literal with a positive integer as value and with an `XSD.positiveInteger` datatype. The integer
     needs to be in the range [1,UInt.max] where UInt.max is the maximum integer value supported by the system.
     The type of the integer is the natively supported type of integer, i.e. a 32-bit integer on 32-bit systems and
     a 64-bit integer on 64-bit systems.
     
     - parameter positiveIntegerValue: The positive integer value.
     - returns: The positive integer Literal or nil if the parameter is outside the range for positive integers.
     */
    public convenience init?(positiveIntegerValue : UInt) {
        if positiveIntegerValue == 0 {
            return nil
        }
        self.init(stringValue: "\(positiveIntegerValue)")
        self.positiveIntegerValue = positiveIntegerValue
        self.setUnsignedIntegerValues(UInt64(positiveIntegerValue))
        self.dataType = XSD.positiveInteger
    }
    
    /**
     Creates a new Literal with a non-positive integer as value and with an `XSD.nonPositiveInteger` datatype. The integer
     needs to be in the range [Int.min,0] where Int.min is the minimum integer value supported by the system.
     The type of the integer is the natively supported type of integer, i.e. a 32-bit integer on 32-bit systems and
     a 64-bit integer on 64-bit systems.
     
     - parameter nonPositiveIntegerValue: The non-positive integer value.
     - returns: The non positive integer Literal or nil if the parameter is outside the range for non positive integers.
     */
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
    
    /**
     Creates a new Literal with the **absolute** value of a non-positive integer as value and with an
     `XSD.nonPositiveInteger` datatype. The integer needs to be in the range [0,UInt.max] where UInt.max
     is the maximum integer value supported by the system.
     The type of the integer is the natively supported type of integer, i.e. a 32-bit integer on 32-bit systems and
     a 64-bit integer on 64-bit systems.
     
     - parameter nonPositiveIntegerValue: The absolute value of the non-positive integer value.
     */
    public convenience init(nonPositiveIntegerValue : UInt) {
        self.init(stringValue: "-\(nonPositiveIntegerValue)")
        if nonPositiveIntegerValue <= UInt(Int64.max) {
            let longV = Int64(-(Int64(nonPositiveIntegerValue)))
            self.setIntegerValues(longV)
        }
        self.nonPositiveIntegerValue = nonPositiveIntegerValue
        self.dataType = XSD.nonPositiveInteger
    }
    
    /**
     Creates a new Literal with a negative integer as value and with an `XSD.negativeInteger` datatype. The integer
     needs to be in the range [Int.min,1] where Int.min is the minimum integer value supported by the system.
     The type of the integer is the natively supported type of integer, i.e. a 32-bit integer on 32-bit systems and
     a 64-bit integer on 64-bit systems.
     
     - parameter nonPositiveIntegerValue: The negative integer value.
     - returns: The negative integer Literal or nil if the parameter is outside the range for negative integers.
     */
    public convenience init?(negativeIntegerValue : Int) {
        if negativeIntegerValue >= 0 {
            return nil
        }
        self.init(nonPositiveIntegerValue:negativeIntegerValue)
        self.dataType = XSD.negativeInteger
    }
    
    /**
     Creates a new Literal with the **absolute** value of a negative integer as value and with an
     `XSD.negativeInteger` datatype. The integer needs to be in the range [1,UInt.max] where UInt.max
     is the maximum integer value supported by the system.
     The type of the integer is the natively supported type of integer, i.e. a 32-bit integer on 32-bit systems and
     a 64-bit integer on 64-bit systems.
     
     - parameter negativeIntegerValue: The absolute value of the negative integer value.
     - returns: The negative integer Literal or nil if the parameter is outside the range for negative integers.
     */
    public convenience init?(negativeIntegerValue : UInt) {
        if negativeIntegerValue == 0 {
            return nil
        }
        self.init(nonPositiveIntegerValue:negativeIntegerValue)
        self.dataType = XSD.negativeInteger
    }
    
    /**
     Creates a new Literal with a long (base-64 integer) as value and with an `XSD.long` datatype.
     
     - parameter longValue: The long value.
     */
    public convenience init(longValue : Int64) {
        self.init(stringValue: "\(longValue)")
        self.longValue = longValue
        self.setIntegerValues(longValue)
        self.dataType = XSD.long
    }
    
    /**
     Creates a new Literal with an unsigned long (base-64 integer) as value and with an `XSD.unsignedLong` datatype.
     
     - parameter unsignedLongValue: The unsigned long value.
     */
    public convenience init(unsignedLongValue : UInt64) {
        self.init(stringValue: "\(unsignedLongValue)")
        self.unsignedLongValue = unsignedLongValue
        self.setUnsignedIntegerValues(unsignedLongValue)
        self.dataType = XSD.unsignedLong
    }
    
    /**
     Creates a new Literal with an int (base-32 integer) as value and with an `XSD.int` datatype.
     
     - parameter intValue: The int value.
     */
    public convenience init(intValue : Int32) {
        self.init(stringValue: "\(intValue)")
        self.intValue = intValue
        self.setIntegerValues(Int64(intValue))
        self.dataType = XSD.int
    }
    
    /**
     Creates a new Literal with an unsigned int (base-32 integer) as value and with an `XSD.unsignedInt` datatype.
     
     - parameter unsignedIntValue: The unsigned int value.
     */
    public convenience init(unsignedIntValue : UInt32) {
        self.init(stringValue: "\(unsignedIntValue)")
        self.unsignedIntValue = unsignedIntValue
        self.setUnsignedIntegerValues(UInt64(unsignedIntValue))
        self.dataType = XSD.unsignedInt
    }
    
    /**
     Creates a new Literal with a short (base-16 integer) as value and with an `XSD.short` datatype.
     
     - parameter shortValue: The short value.
     */
    public convenience init(shortValue : Int16) {
        self.init(stringValue: "\(shortValue)")
        self.shortValue = shortValue
        self.setIntegerValues(Int64(shortValue))
        self.dataType = XSD.short
    }
    
    /**
     Creates a new Literal with an unsigned short (base-16 integer) as value and with an `XSD.unsignedShort` datatype.
     
     - parameter unsignedShortValue: The unsigned short value.
     */
    public convenience init(unsignedShortValue : UInt16) {
        self.init(stringValue: "\(unsignedShortValue)")
        self.unsignedShortValue = unsignedShortValue
        self.setUnsignedIntegerValues(UInt64(unsignedShortValue))
        self.dataType = XSD.unsignedShort
    }
    
    /**
     Creates a new Literal with a byte (base-8 integer) as value and with an `XSD.byte` datatype.
     
     - parameter byteValue: The byte value.
     */
    public convenience init(byteValue : Int8) {
        self.init(stringValue: "\(byteValue)")
        self.byteValue = byteValue
        self.setIntegerValues(Int64(byteValue))
        self.dataType = XSD.byte
    }
    
    /**
     Creates a new Literal with an unsigned byte (base-8 integer) as value and with an `XSD.unsignedByte` datatype.
     
     - parameter unsignedByteValue: The unsigned byte value.
     */
    public convenience init(unsignedByteValue : UInt8) {
        self.init(stringValue: "\(unsignedByteValue)")
        self.unsignedByteValue = unsignedByteValue
        self.setUnsignedIntegerValues(UInt64(unsignedByteValue))
        self.dataType = XSD.unsignedByte
    }
    
    /**
     Creates a new Literal with a single precision floating point number (float) as value and with an `XSD.float` datatype.
     
     - parameter floatValue: The float value.
     */
    public convenience init(floatValue : Float) {
        self.init(stringValue: "\(floatValue)")
        self.floatValue = floatValue
        self.doubleValue = Double(floatValue)
        self.dataType = XSD.float
    }
    
    /**
     Creates a new Literal with a double precision floating point number (double) as value and with an `XSD.double` datatype.
     
     - parameter floatValue: The double value.
     */
    public convenience init(doubleValue : Double) {
        self.init(stringValue: "\(doubleValue)")
        self.doubleValue = doubleValue
        self.floatValue = Float(doubleValue)
        self.dataType = XSD.double
    }
    
    // MARK: Initialisers for Miscellaneous data types
    
    /**
    Creates a new Literal with a URI as value and with an `XSD.anyURI` datatype.
    
    - parameter anyURIValue: The URI value.
    */
    public convenience init(anyURIValue: URI) {
        self.init(stringValue: "\(anyURIValue.stringValue)")
        self.anyURIValue = anyURIValue
        self.dataType = XSD.anyURI
    }
    
    /**
     Creates a new Literal with a NSData instance as value and with an `XSD.base64Binary` datatype.
     The Base-64 string representation of the data is stored in the `stringValue`.
     
     - parameter base64BinaryValue: The data value.
     */
    public convenience init(base64BinaryValue: NSData) {
        let datastr = base64BinaryValue.base64String()
        self.init(stringValue: datastr)
        self.dataValue = base64BinaryValue
        self.dataType = XSD.base64Binary
    }
    
    /**
     Creates a new Literal with a NSData instance as value and with an `XSD.base64Binary` datatype.
     The Base-64 string representation of the data is stored in the `stringValue`.
     
     - parameter base64BinaryValue: The data value.
     */
    public convenience init(hexadecimalBinaryValue: NSData) {
        let datastr = hexadecimalBinaryValue.hexadecimalString()
        self.init(stringValue: datastr)
        self.dataValue = hexadecimalBinaryValue
        self.dataType = XSD.hexBinary
    }
    
    /**
     Creates a new Literal with the specified Qualified Name as value. If the string is not a
     valid qualified name (QName) `nil` will be returned. The data type of the literal will be `xsd:QName`.
     An example of a qualified name is `prefix:localPart`.
     
     - parameter QNameValue: The Qualified Name value.
     - returns: The literal containing the Qualified Name, or `nil` if the string parameter is not a
     valid Qualified Name.
     */
    public convenience init?(QNameValue : String){
        if !QNameValue.isQualifiedName {
            return nil
        }
        self.init(stringValue: QNameValue, dataType: XSD.QName)
    }
    
    /**
     Creates a new Literal with the specified prefix and local part of the Qualified Name as value.
     If the prefix or local part are not valid not-colonized names (NCNames) `nil` will be returned.
     The data type of the literal will be `xsd:QName`.
     An example of a qualified name is `prefix:localPart`.
     
     - parameter prefix: The Qualified Name prefix or `nil` if the qualified name does not contain a prefix.
     - parameter localPart: The local part of the Qualified Name.
     - returns: The literal containing the Qualified Name, or `nil` if the string parameter is not a
     valid Qualified Name.
     */
    public convenience init?(prefix : String?, localPart: String){
        var QNameValue = ""
        if prefix != nil {
            QNameValue += prefix! + ":"
        }
        QNameValue += localPart
        if !QNameValue.isQualifiedName {
            return nil
        }
        self.init(stringValue: QNameValue, dataType: XSD.QName)
    }
    
    
    // MARK: Private functions
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
    
    private static func parseBoolean(booleanAsString : String) throws -> Bool {
        var result : Bool? = nil
        if booleanAsString == "true" || booleanAsString == "yes" {
            result = true
        }else if booleanAsString == "false" || booleanAsString == "no" {
            result = false
        }
        if result == nil {
            throw LiteralFormattingError.malformedNumber(message: "Could not create boolean literal from \(booleanAsString).", string: booleanAsString);
        }
        return result!
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

// MARK: Operators for Literals

/**
 This operator returns `true` when the Literal values are equal to each other.
 
 - parameter left: The left Literal in the comparison.
 - parameter right: The right Literal in the comparison.
 - returns: True when the Literals are equal, false otherwise, or `nil` if the literal values could not be compared (because of 
    incompatible data types.
 */
public func == (left: Literal, right: Literal) -> Bool? {
    if left.dataType == nil && right.dataType == nil {
        if left.stringValue == right.stringValue {
            return true
        }
        return false
    }
    if left.dataType == nil || right.dataType == nil {
        return false        // one of the data types is nil the other is not.
    }
    if left.isStringLiteral && right.isStringLiteral {
        return left.stringValue == right.stringValue
    }
    if left.isNumericLiteral && right.isNumericLiteral {
        if left.decimalValue != nil && right.decimalValue != nil {
            return left.decimalValue! == right.decimalValue!
        }
        if left.unsignedLongValue != nil && right.unsignedLongValue != nil {
            return left.unsignedLongValue == right.unsignedLongValue
        }
        if left.doubleValue != nil && right.doubleValue != nil {
            return left.doubleValue == right.doubleValue
        }
    }
    if left.isDateLiteral && right.isDateLiteral {
        if left.dateValue != nil && right.dateValue != nil {
            return left.dateValue! == right.dateValue!
        }
        if left.durationValue != nil && right.durationValue != nil {
            return left.durationValue! == right.durationValue!
        }
    }
    return nil
}
   