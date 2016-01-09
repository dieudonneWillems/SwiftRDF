//
//  XSD.swift
//  
//
//  Created by Don Willems on 26/11/15.
//
//

import Foundation

/**
 This vocabulary class defines static constant variables for each of the datatypes in the
 [XML Schema specification for datatypes](http://www.w3.org/TR/xmlschema-2/).
 */
public class XSD : Vocabulary {
    
    // MARK: XSD Namespace
    
    private static let ns = "http://www.w3.org/2001/XMLSchema#"
    
    /// The namespace of the XML Schema vocabulary, i.e. `http://www.w3.org/2001/XMLSchema#`.
    public override class func namespace() -> String {
        return ns
    }
    
    /**
     Returns the suggested prefix to be used for the XML Schema vocabulary, i.e. `xsd`.
     
     - returns: The prefix for the vocabulary.
     */
    public override class func prefix() -> String {
        return "xsd"
    }
    
    // MARK: XSD Datatypes
    
    /// The generic datatype in XML Schema, i.e. `xsd:anyType`.
    public static let anyType = XSD.createDatatype(XSD.ns, localName: "anyType", derivedFromDatatype: nil, isListDataType: false)
    
    /// The generic simple datatype in XML Schema, i.e. `xsd:anySimpleType`.
    public static let anySimpleType = XSD.createDatatype( XSD.ns, localName: "anySimpleType", derivedFromDatatype: anyType, isListDataType: false)
    
    /**
     Data of type `xsd:dateTime` respresent moments in time represented with a date and a time.
     For example, 2002-10-10T12:00:00-05:00 (noon on 10 October 2002, Central Daylight Savings Time as 
     well as Eastern Standard Time in the U.S.) is 2002-10-10T17:00:00Z, five hours later than 2002-10-10T12:00:00Z.
     */
    public static let dateTime = XSD.createDatatype( XSD.ns, localName: "dateTime", derivedFromDatatype: anySimpleType, isListDataType: false)
    
    /// Represents an instance of time that reoccurs every day, e.g. 17:00:00Z.
    public static let time = XSD.createDatatype( XSD.ns, localName: "time", derivedFromDatatype: anySimpleType, isListDataType: false)
    
    /// Represents a date, e.g. 2002-10-10Z
    public static let date = XSD.createDatatype( XSD.ns, localName: "date", derivedFromDatatype: anySimpleType, isListDataType: false)
    
    /// Represents a year and a month in the gregorian calendar, e.g. 2002-10.
    public static let gYearMonth = XSD.createDatatype( XSD.ns, localName: "gYearMonth", derivedFromDatatype: anySimpleType, isListDataType: false)
    
    /// Represents a year in the gregorian calendar, e.g. 2002.
    public static let gYear = XSD.createDatatype( XSD.ns, localName: "gYear", derivedFromDatatype: anySimpleType, isListDataType: false)
    
    /// Represent a gregorian data that reoccurs every year, e.g. 10-05, the fifth of October.
    public static let gMonthDay = XSD.createDatatype( XSD.ns, localName: "gMonthDay", derivedFromDatatype: anySimpleType, isListDataType: false)
    
    /// Represent a gregorian day that reoccurs every month, e.g. 10, the tenth day of a month.
    public static let gDay = XSD.createDatatype( XSD.ns, localName: "gDay", derivedFromDatatype: anySimpleType, isListDataType: false)
    
    /// Represents a gregorian month that reoccurs every year, e.g. 10, the month of October.
    public static let gMonth = XSD.createDatatype( XSD.ns, localName: "gMonth", derivedFromDatatype: anySimpleType, isListDataType: false)
    
    /// Represents a boolean value, required to support the mathematical concept of binary-valued logic: {true, false}.
    public static let boolean = XSD.createDatatype( XSD.ns, localName: "boolean", derivedFromDatatype: anySimpleType, isListDataType: false)
    
    /** Represents a duration of time. The ·value space· of duration is a six-dimensional space where the coordinates designate 
        the Gregorian year, month, day, hour, minute, and second components respectively. For instance, P1Y2MT2H.*/
    public static let duration = XSD.createDatatype( XSD.ns, localName: "duration", derivedFromDatatype: anySimpleType, isListDataType: false)
    
    /// Represents binary data encoded in base 64.
    public static let base64Binary = XSD.createDatatype( XSD.ns, localName: "base64Binary", derivedFromDatatype: anySimpleType, isListDataType: false)
    
    /// Represent hex-binary data.
    public static let hexBinary = XSD.createDatatype( XSD.ns, localName: "hexBinary", derivedFromDatatype: anySimpleType, isListDataType: false)
    
    /// Represents a float data value, which is patterned after the IEEE single-precision 32-bit floating point type.
    public static let float = XSD.createDatatype( XSD.ns, localName: "float", derivedFromDatatype: anySimpleType, isListDataType: false)
    
    /// Represents a double data value, which is patterned after the IEEE double-precision 64-bit floating point type.
    public static let double = XSD.createDatatype( XSD.ns, localName: "double", derivedFromDatatype: anySimpleType, isListDataType: false)
    
    /// Represents a Uniform Resource Identifier Reference (URI).
    public static let anyURI = XSD.createDatatype( XSD.ns, localName: "anyURI", derivedFromDatatype: anySimpleType, isListDataType: false)
    
    /// Represents, a QName or XML qualified name.
    public static let QName = XSD.createDatatype( XSD.ns, localName: "QName", derivedFromDatatype: anySimpleType, isListDataType: false)
    
    /** NOTATION represents the NOTATION attribute type from [XML 1.0 (Second Edition)]. The value space of NOTATION is the set of QNames of notations declared in the current schema. */
    public static let NOTATION = XSD.createDatatype( XSD.ns, localName: "NOTATION", derivedFromDatatype: anySimpleType, isListDataType: false)
    
    /// The string datatype represents character strings in XML.
    public static let string = XSD.createDatatype( XSD.ns, localName: "string", derivedFromDatatype: anySimpleType, isListDataType: false)
    
    /** The normalizedString datatype represents white space normalized strings. The value space of
        normalizedString is the set of strings that do not contain the carriage return (#xD), 
        line feed (#xA) nor tab (#x9) characters.
    */
    public static let normalizedString = XSD.createDatatype( XSD.ns, localName: "normalizedString", derivedFromDatatype: string, isListDataType: false)
    
    /** The token datatype represents tokenized strings. The value space of token is the set of strings
        that do not contain the carriage return (#xD), line feed (#xA) nor tab (#x9) characters, 
        that have no leading or trailing spaces (#x20) and that have no internal sequences of two or more spaces.
    */
    public static let token = XSD.createDatatype( XSD.ns, localName: "token", derivedFromDatatype: normalizedString, isListDataType: false)
    
    /// The language datatype represents natural language identifiers
    public static let language = XSD.createDatatype( XSD.ns, localName: "language", derivedFromDatatype: token, isListDataType: false)
    
    /*
     Name represents [XML Names](http://www.w3.org/TR/2000/WD-xml-2e-20000814#dt-name). A Name is a token beginning
     with a letter or one of a few punctuation characters, and continuing with letters, digits, hyphens, underscores,
     colons, or full stops, together known as name characters.
     */
    public static let Name = XSD.createDatatype( XSD.ns, localName: "Name", derivedFromDatatype: token, isListDataType: false)
    
    /**
     An NMTOKEN is the set of tokens that match the Nmtoken production in 
     [XML 1.0 (Second Edition)](http://www.w3.org/TR/xmlschema-2/#XML)
     */
    public static let NMTOKEN = XSD.createDatatype( XSD.ns, localName: "NMTOKEN", derivedFromDatatype: token, isListDataType: false)
    
    /// Represents a list of `NMToken`s.
    public static let NMTOKENS = XSD.createDatatype( XSD.ns, localName: "NMTOKENS", derivedFromDatatype: NMTOKEN, isListDataType: true)
    
    /// NCName represents XML "non-colonized" Names.
    public static let NCName = XSD.createDatatype( XSD.ns, localName: "NCName", derivedFromDatatype: Name, isListDataType: false)
    
    /** 
     ID represents the [ID attribute](http://www.w3.org/TR/2000/WD-xml-2e-20000814#NT-TokenizedType) type 
     from [XML 1.0 (Second Edition)](http://www.w3.org/TR/xmlschema-2/#XML). 
     Values of type ID must match the Name production.
     A name must not appear more than once in an XML document as a value of this type; i.e., ID values must uniquely 
     identify the elements which bear them.
    */
    public static let ID = XSD.createDatatype( XSD.ns, localName: "ID", derivedFromDatatype: NCName, isListDataType: false)
    
    /**
     IDREF represents the [IDREF attribute](http://www.w3.org/TR/2000/WD-xml-2e-20000814#NT-TokenizedType) type
     from [XML 1.0 (Second Edition)](http://www.w3.org/TR/xmlschema-2/#XML). An IDREF is a reference to an ID.
     */
    public static let IDREF = XSD.createDatatype( XSD.ns, localName: "IDREF", derivedFromDatatype: NCName, isListDataType: false)
    
    /// Represents a list of `IDREF`s.
    public static let IDREFS = XSD.createDatatype( XSD.ns, localName: "IDREFS", derivedFromDatatype: IDREF, isListDataType: true)
    
    /**
     An ENTITY is a string that matches the NCName production and have been declared as an unparsed entity in a 
     document type definition.
     */
    public static let ENTITY = XSD.createDatatype( XSD.ns, localName: "ENTITY", derivedFromDatatype: NCName, isListDataType: false)
    
    /// Represents a list of multiple instances of an `ENTITY`.
    public static let ENTITIES = XSD.createDatatype( XSD.ns, localName: "ENTITIES", derivedFromDatatype: ENTITY, isListDataType: true)
    
    /// Represents a subset of the real numbers, which can be represented by decimal numerals.
    public static let decimal = XSD.createDatatype( XSD.ns, localName: "decimal", derivedFromDatatype: anySimpleType, isListDataType: false)
    
    /** 
      Represents an integer which is derived from decimal by fixing the value of fractionDigits to be 0 and disallowing
      the trailing decimal point. This results in the standard mathematical concept of the integer numbers.
     */
    public static let integer = XSD.createDatatype( XSD.ns, localName: "integer", derivedFromDatatype: decimal, isListDataType: false)
    
    /**
     Represents a non-positive-integer which is derived from integer by setting the maximum value to be 0 inclusive, i.e. <=0.
     This results in the standard mathematical concept of the non-positive integers.
     */
    public static let nonPositiveInteger = XSD.createDatatype( XSD.ns, localName: "nonPositiveInteger", derivedFromDatatype: integer, isListDataType: false)
    
    /**
     Represents a negative integer, i.e. <0.
     This results in the standard mathematical concept of the negative integers
     */
    public static let negativeInteger = XSD.createDatatype( XSD.ns, localName: "negativeInteger", derivedFromDatatype: nonPositiveInteger, isListDataType: false)
    
    /// Represents a signed 64-bit integer of type long with a value between -9223372036854775808 and 9223372036854775807 inclusive.
    public static let long = XSD.createDatatype( XSD.ns, localName: "long", derivedFromDatatype: integer, isListDataType: false)
    
    /// Represents a signed 32-bit integer of type int with a value between -2147483648 and 2147483647 inclusive.
    public static let int = XSD.createDatatype( XSD.ns, localName: "int", derivedFromDatatype: long, isListDataType: false)
    
    // Represents a signed 16-bit integer of type short with a value between  -32768 and 32767 inclusive.
    public static let short = XSD.createDatatype( XSD.ns, localName: "short", derivedFromDatatype: int, isListDataType: false)
    
    // Represents a signed 8-bit integer of type byte with a value between  -128 and 127 inclusive.
    public static let byte = XSD.createDatatype( XSD.ns, localName: "byte", derivedFromDatatype: short, isListDataType: false)
    
    /**
     Represents a non-negative-integer which is derived from integer by setting the minimum value to be 0 inclusive, i.e. >=0.
     This results in the standard mathematical concept of the non-negative integers.
     */
    public static let nonNegativeInteger = XSD.createDatatype( XSD.ns, localName: "nonNegativeInteger", derivedFromDatatype: integer, isListDataType: false)
    
    /// Represents a non negative 64-bit integer of type long with a value between 0 and 18446744073709551615 inclusive.
    public static let unsignedLong = XSD.createDatatype( XSD.ns, localName: "unsignedLong", derivedFromDatatype: nonNegativeInteger, isListDataType: false)
    
    /// Represents a non negative 32-bit integer of type int with a value between 0 and 4294967295 inclusive.
    public static let unsignedInt = XSD.createDatatype( XSD.ns, localName: "unsignedInt", derivedFromDatatype: unsignedLong, isListDataType: false)
    
    /// Represents a non negative 16-bit integer of type short with a value between 0 and 65535 inclusive.
    public static let unsignedShort = XSD.createDatatype( XSD.ns, localName: "unsignedShort", derivedFromDatatype: unsignedInt, isListDataType: false)
    
    /// Represents a non negative 8-bit integer of type byte with a value between 0 and 255 inclusive.
    public static let unsignedByte = XSD.createDatatype( XSD.ns, localName: "unsignedByte", derivedFromDatatype: unsignedShort, isListDataType: false)
    
    /**
     Represents a positive integer, i.e. >0.
     This results in the standard mathematical concept of the positive integers
     */
    public static let positiveInteger = XSD.createDatatype( XSD.ns, localName: "positiveInteger", derivedFromDatatype: nonNegativeInteger, isListDataType: false)
    
    /**
     Creates a new Datatype to be included in the vocabulary. This method is a convenience method
     to create Datatypes without the need to catch URI initialisation errors. It is imperative that
     the Datatypes created are valid URIs, otherwise a runtime error will occur.
     
     - parameter namespace: The namespace of the vocabulary.
     - parameter localName: The local name of the concept.
     - returns: The Datatype that was created.
     */
    internal static func createDatatype(namespace: String, localName: String, derivedFromDatatype: Datatype?, isListDataType: Bool) -> Datatype {
        let datatype = Datatype(namespace: namespace, localName: localName, derivedFromDatatype: derivedFromDatatype, isListDataType: isListDataType)
        return datatype!
    }
}
