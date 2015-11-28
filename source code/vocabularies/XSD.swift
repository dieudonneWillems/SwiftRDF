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
    
    
    public static let boolean = XSD.createDatatype( XSD.ns, localName: "boolean", derivedFromDatatype: anySimpleType, isListDataType: false)
    public static let duration = XSD.createDatatype( XSD.ns, localName: "duration", derivedFromDatatype: anySimpleType, isListDataType: false)
    public static let base64Binary = XSD.createDatatype( XSD.ns, localName: "base64Binary", derivedFromDatatype: anySimpleType, isListDataType: false)
    
    // Represent hex-binary data.
    public static let hexBinary = XSD.createDatatype( XSD.ns, localName: "hexBinary", derivedFromDatatype: anySimpleType, isListDataType: false)
    public static let float = XSD.createDatatype( XSD.ns, localName: "float", derivedFromDatatype: anySimpleType, isListDataType: false)
    public static let double = XSD.createDatatype( XSD.ns, localName: "double", derivedFromDatatype: anySimpleType, isListDataType: false)
    public static let anyURI = XSD.createDatatype( XSD.ns, localName: "anyURI", derivedFromDatatype: anySimpleType, isListDataType: false)
    public static let QName = XSD.createDatatype( XSD.ns, localName: "QName", derivedFromDatatype: anySimpleType, isListDataType: false)
    public static let NOTATION = XSD.createDatatype( XSD.ns, localName: "NOTATION", derivedFromDatatype: anySimpleType, isListDataType: false)
    public static let string = XSD.createDatatype( XSD.ns, localName: "string", derivedFromDatatype: anySimpleType, isListDataType: false)
    public static let normalizedString = XSD.createDatatype( XSD.ns, localName: "normalizedString", derivedFromDatatype: string, isListDataType: false)
    public static let token = XSD.createDatatype( XSD.ns, localName: "token", derivedFromDatatype: normalizedString, isListDataType: false)
    public static let language = XSD.createDatatype( XSD.ns, localName: "language", derivedFromDatatype: token, isListDataType: false)
    public static let Name = XSD.createDatatype( XSD.ns, localName: "Name", derivedFromDatatype: token, isListDataType: false)
    public static let NMTOKEN = XSD.createDatatype( XSD.ns, localName: "NMTOKEN", derivedFromDatatype: token, isListDataType: false)
    public static let NMTOKENS = XSD.createDatatype( XSD.ns, localName: "NMTOKENS", derivedFromDatatype: NMTOKEN, isListDataType: true)
    public static let NCName = XSD.createDatatype( XSD.ns, localName: "NCName", derivedFromDatatype: Name, isListDataType: false)
    public static let ID = XSD.createDatatype( XSD.ns, localName: "ID", derivedFromDatatype: NCName, isListDataType: false)
    public static let IDREF = XSD.createDatatype( XSD.ns, localName: "IDREF", derivedFromDatatype: NCName, isListDataType: false)
    public static let IDREFS = XSD.createDatatype( XSD.ns, localName: "IDREFS", derivedFromDatatype: IDREF, isListDataType: true)
    public static let ENTITY = XSD.createDatatype( XSD.ns, localName: "ENTITY", derivedFromDatatype: NCName, isListDataType: false)
    public static let ENTITIES = XSD.createDatatype( XSD.ns, localName: "ENTITIES", derivedFromDatatype: ENTITY, isListDataType: true)
    public static let decimal = XSD.createDatatype( XSD.ns, localName: "decimal", derivedFromDatatype: anySimpleType, isListDataType: false)
    public static let integer = XSD.createDatatype( XSD.ns, localName: "integer", derivedFromDatatype: decimal, isListDataType: false)
    public static let nonPositiveInteger = XSD.createDatatype( XSD.ns, localName: "nonPositiveInteger", derivedFromDatatype: integer, isListDataType: false)
    public static let negativeInteger = XSD.createDatatype( XSD.ns, localName: "negativeInteger", derivedFromDatatype: nonPositiveInteger, isListDataType: false)
    public static let long = XSD.createDatatype( XSD.ns, localName: "long", derivedFromDatatype: integer, isListDataType: false)
    public static let int = XSD.createDatatype( XSD.ns, localName: "int", derivedFromDatatype: long, isListDataType: false)
    public static let short = XSD.createDatatype( XSD.ns, localName: "short", derivedFromDatatype: int, isListDataType: false)
    public static let byte = XSD.createDatatype( XSD.ns, localName: "byte", derivedFromDatatype: short, isListDataType: false)
    public static let nonNegativeInteger = XSD.createDatatype( XSD.ns, localName: "nonNegativeInteger", derivedFromDatatype: integer, isListDataType: false)
    public static let unsignedLong = XSD.createDatatype( XSD.ns, localName: "unsignedLong", derivedFromDatatype: nonNegativeInteger, isListDataType: false)
    public static let unsignedInt = XSD.createDatatype( XSD.ns, localName: "unsignedInt", derivedFromDatatype: unsignedLong, isListDataType: false)
    public static let unsignedShort = XSD.createDatatype( XSD.ns, localName: "unsignedShort", derivedFromDatatype: unsignedInt, isListDataType: false)
    public static let unsignedByte = XSD.createDatatype( XSD.ns, localName: "unsignedByte", derivedFromDatatype: unsignedShort, isListDataType: false)
    public static let positiveInteger = XSD.createDatatype( XSD.ns, localName: "positiveInteger", derivedFromDatatype: nonNegativeInteger, isListDataType: false)
    
    
    internal static func createDatatype(namespace: String, localName: String, derivedFromDatatype: Datatype?, isListDataType: Bool) -> Datatype {
        var datatype : Datatype? = nil
        do {
            datatype = try Datatype(namespace: namespace, localName: localName, derivedFromDatatype: derivedFromDatatype, isListDataType: isListDataType)
        } catch {
            datatype = nil
        }
        return datatype!
    }
}
