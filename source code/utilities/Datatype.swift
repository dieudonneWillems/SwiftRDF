//
//  Datatype.swift
//  
//
//  Created by Don Willems on 26/11/15.
//
//

import Foundation

/**
 Defines a datatype that can be used to specify the datatype of data contained in a `Literal`.  
 Datatype is a subclass of `URI` as the datatype are specified using URI's that define the datatype.
 Usually the datatypes used are those defined in the 
 [XML Schema specification for datatypes](http://www.w3.org/TR/xmlschema-2/).
 For the SwiftRDF framework, these datatypes are defined in the `XSD` vocabulary class.
 */
public class Datatype : URI {
    
    // MARK: Properties
    
    private let derivedFromDatatype : Datatype?
    
    /**
     Defines whether the datatype is a list such as `xsd:IDREFS` or `NMTokens`.
    */
    public let isListDataType : Bool
    
    
    // MARK: Initialisers
    
    /**
     Initialises a new datatype in the specified namespace and with the specified local name.
     
     - parameter namespace: The namespace to which the datatype belong.
     - parameter localName: The local name of the datatype.
     - parameter derivedFromDatatype: The parent datatype from which this datatype is derived (either by restriction
        or by list.
     - parameter isListDataType: Set to true when the datatype specified data provided as a list of data.
    
     - returns: The datatype, or nil if the namespace and local name could not be combined to a valid URI.
     */
    public init?(namespace: String, localName : String, derivedFromDatatype: Datatype?, isListDataType : Bool) {
        self.derivedFromDatatype = derivedFromDatatype
        self.isListDataType = isListDataType
        super.init(namespace: namespace, localName: localName)
    }
    
    /**
     Initialises a new datatype in the specified namespace and with the specified local name.
     
     - parameter uri: The URI of the datatype.
     - parameter derivedFromDatatype: The parent datatype from which this datatype is derived (either by restriction
     or by list.
     - parameter isListDataType: Set to true when the datatype specified data provided as a list of data.
     - returns: The datatype, or nil if the uri string did not represent a valid URI.
     */
    public init?(uri : String, derivedFromDatatype: Datatype?, isListDataType : Bool) {
        self.derivedFromDatatype = derivedFromDatatype
        self.isListDataType = isListDataType
        super.init(string: uri)
    }
    
    // MARK: Methods
    
    /**
    Returns true when the datatype is derived (either by restriction or list) from the specified datatype or when the
    specified datatype is the same datatype as the reciever.
    
    - parameter datatype: The datatype that is tested whether this datatype is derived from it.
    - returns: True, when this datatype is derived from the specified datatype or when the specified datatype is the reciever, false otherwise.
    */
    public func isDerivedFromDatatype(datatype : Datatype) -> Bool {
        if datatype == self {
            return true
        }
        if derivedFromDatatype == nil {
            return false
        }
        if derivedFromDatatype! == datatype {
            return true
        }
        return derivedFromDatatype!.isDerivedFromDatatype(datatype)
    }
}