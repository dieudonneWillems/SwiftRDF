//
//  Value.swift
//  
//
//  Created by Don Willems on 20/11/15.
//
//

import Foundation

public class Value : SPARQLValue {
    
    public private(set) var stringValue : String
    
    public var sparql : String {
        get{
            return ""
        }
    }
    
    public init(stringValue : String) {
        self.stringValue = stringValue
    }
    
}

public func == (left: Value, right: Value) -> Bool {
    return left === right
}

public func != (left: Value, right: Value) -> Bool {
    return !(left == right)
}