//
//  XSD.swift
//  
//
//  Created by Don Willems on 26/11/15.
//
//

import Foundation

public class XSD : Vocabulary {
    
    // MARK: XSD Namespace
    public static let NAMESPACE = "http://www.w3.org/2001/XMLSchema#"
    
    // MARK: XSD Datatypes
    public static let anyType = XSD.createDatatype(XSD.NAMESPACE, localName: "anyType", derivedFromDatatype: nil, isListDataType: false)
    public static let anySimpleType = XSD.createDatatype( XSD.NAMESPACE, localName: "anySimpleType", derivedFromDatatype: anyType, isListDataType: false)
    public static let dateTime = XSD.createDatatype( XSD.NAMESPACE, localName: "dateTime", derivedFromDatatype: anySimpleType, isListDataType: false)
    public static let time = XSD.createDatatype( XSD.NAMESPACE, localName: "time", derivedFromDatatype: anySimpleType, isListDataType: false)
    public static let date = XSD.createDatatype( XSD.NAMESPACE, localName: "date", derivedFromDatatype: anySimpleType, isListDataType: false)
    public static let gYearMonth = XSD.createDatatype( XSD.NAMESPACE, localName: "gYearMonth", derivedFromDatatype: anySimpleType, isListDataType: false)
    public static let gYear = XSD.createDatatype( XSD.NAMESPACE, localName: "gYear", derivedFromDatatype: anySimpleType, isListDataType: false)
    public static let gMonthDay = XSD.createDatatype( XSD.NAMESPACE, localName: "gMonthDay", derivedFromDatatype: anySimpleType, isListDataType: false)
    public static let gDay = XSD.createDatatype( XSD.NAMESPACE, localName: "gDay", derivedFromDatatype: anySimpleType, isListDataType: false)
    public static let gMonth = XSD.createDatatype( XSD.NAMESPACE, localName: "gMonth", derivedFromDatatype: anySimpleType, isListDataType: false)
    public static let boolean = XSD.createDatatype( XSD.NAMESPACE, localName: "boolean", derivedFromDatatype: anySimpleType, isListDataType: false)
    public static let duration = XSD.createDatatype( XSD.NAMESPACE, localName: "duration", derivedFromDatatype: anySimpleType, isListDataType: false)
    public static let base64Binary = XSD.createDatatype( XSD.NAMESPACE, localName: "base64Binary", derivedFromDatatype: anySimpleType, isListDataType: false)
    public static let hexBinary = XSD.createDatatype( XSD.NAMESPACE, localName: "hexBinary", derivedFromDatatype: anySimpleType, isListDataType: false)
    public static let float = XSD.createDatatype( XSD.NAMESPACE, localName: "float", derivedFromDatatype: anySimpleType, isListDataType: false)
    public static let double = XSD.createDatatype( XSD.NAMESPACE, localName: "double", derivedFromDatatype: anySimpleType, isListDataType: false)
    public static let anyURI = XSD.createDatatype( XSD.NAMESPACE, localName: "anyURI", derivedFromDatatype: anySimpleType, isListDataType: false)
    public static let QName = XSD.createDatatype( XSD.NAMESPACE, localName: "QName", derivedFromDatatype: anySimpleType, isListDataType: false)
    public static let NOTATION = XSD.createDatatype( XSD.NAMESPACE, localName: "NOTATION", derivedFromDatatype: anySimpleType, isListDataType: false)
    public static let string = XSD.createDatatype( XSD.NAMESPACE, localName: "string", derivedFromDatatype: anySimpleType, isListDataType: false)
    public static let normalizedString = XSD.createDatatype( XSD.NAMESPACE, localName: "normalizedString", derivedFromDatatype: string, isListDataType: false)
    public static let token = XSD.createDatatype( XSD.NAMESPACE, localName: "token", derivedFromDatatype: normalizedString, isListDataType: false)
    public static let language = XSD.createDatatype( XSD.NAMESPACE, localName: "language", derivedFromDatatype: token, isListDataType: false)
    public static let Name = XSD.createDatatype( XSD.NAMESPACE, localName: "Name", derivedFromDatatype: token, isListDataType: false)
    public static let NMTOKEN = XSD.createDatatype( XSD.NAMESPACE, localName: "NMTOKEN", derivedFromDatatype: token, isListDataType: false)
    public static let NMTOKENS = XSD.createDatatype( XSD.NAMESPACE, localName: "NMTOKENS", derivedFromDatatype: NMTOKEN, isListDataType: true)
    public static let NCName = XSD.createDatatype( XSD.NAMESPACE, localName: "NCName", derivedFromDatatype: Name, isListDataType: false)
    public static let ID = XSD.createDatatype( XSD.NAMESPACE, localName: "ID", derivedFromDatatype: NCName, isListDataType: false)
    public static let IDREF = XSD.createDatatype( XSD.NAMESPACE, localName: "IDREF", derivedFromDatatype: NCName, isListDataType: false)
    public static let IDREFS = XSD.createDatatype( XSD.NAMESPACE, localName: "IDREFS", derivedFromDatatype: IDREF, isListDataType: true)
    public static let ENTITY = XSD.createDatatype( XSD.NAMESPACE, localName: "ENTITY", derivedFromDatatype: NCName, isListDataType: false)
    public static let ENTITIES = XSD.createDatatype( XSD.NAMESPACE, localName: "ENTITIES", derivedFromDatatype: ENTITY, isListDataType: true)
    public static let decimal = XSD.createDatatype( XSD.NAMESPACE, localName: "decimal", derivedFromDatatype: anySimpleType, isListDataType: false)
    public static let integer = XSD.createDatatype( XSD.NAMESPACE, localName: "integer", derivedFromDatatype: decimal, isListDataType: false)
    public static let nonPositiveInteger = XSD.createDatatype( XSD.NAMESPACE, localName: "nonPositiveInteger", derivedFromDatatype: integer, isListDataType: false)
    public static let negativeInteger = XSD.createDatatype( XSD.NAMESPACE, localName: "negativeInteger", derivedFromDatatype: nonPositiveInteger, isListDataType: false)
    public static let long = XSD.createDatatype( XSD.NAMESPACE, localName: "long", derivedFromDatatype: integer, isListDataType: false)
    public static let int = XSD.createDatatype( XSD.NAMESPACE, localName: "int", derivedFromDatatype: long, isListDataType: false)
    public static let short = XSD.createDatatype( XSD.NAMESPACE, localName: "short", derivedFromDatatype: int, isListDataType: false)
    public static let byte = XSD.createDatatype( XSD.NAMESPACE, localName: "byte", derivedFromDatatype: short, isListDataType: false)
    public static let nonNegativeInteger = XSD.createDatatype( XSD.NAMESPACE, localName: "nonNegativeInteger", derivedFromDatatype: integer, isListDataType: false)
    public static let unsignedLong = XSD.createDatatype( XSD.NAMESPACE, localName: "unsignedLong", derivedFromDatatype: nonNegativeInteger, isListDataType: false)
    public static let unsignedInt = XSD.createDatatype( XSD.NAMESPACE, localName: "unsignedInt", derivedFromDatatype: unsignedLong, isListDataType: false)
    public static let unsignedShort = XSD.createDatatype( XSD.NAMESPACE, localName: "unsignedShort", derivedFromDatatype: unsignedInt, isListDataType: false)
    public static let unsignedByte = XSD.createDatatype( XSD.NAMESPACE, localName: "unsignedByte", derivedFromDatatype: unsignedShort, isListDataType: false)
    public static let positiveInteger = XSD.createDatatype( XSD.NAMESPACE, localName: "positiveInteger", derivedFromDatatype: nonNegativeInteger, isListDataType: false)
    
    
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
