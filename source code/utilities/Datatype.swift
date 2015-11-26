//
//  Datatype.swift
//  
//
//  Created by Don Willems on 26/11/15.
//
//

import Foundation

public class Datatype : URI {
    
    public let derivedFromDatatype : Datatype?
    public let isListDataType : Bool
    
    public init(namespace: String, localName : String, derivedFromDatatype: Datatype?, isListDataType : Bool) throws {
        self.derivedFromDatatype = derivedFromDatatype
        self.isListDataType = isListDataType
        try super.init(namespace: namespace, localName: localName)
    }
}