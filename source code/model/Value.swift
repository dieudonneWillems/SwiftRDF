//
//  Value.swift
//  
//
//  Created by Don Willems on 20/11/15.
//
//

import Foundation

public class Value {
    
    public private(set) var stringValue : String
    
    public init(stringValue : String) {
        self.stringValue = stringValue
    }
    
}

func == (left: Value, right: Value) -> Bool {
    return left === right
}

func != (left: Value, right: Value) -> Bool {
    return !(left == right)
}