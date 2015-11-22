//
//  Value.swift
//  
//
//  Created by Don Willems on 20/11/15.
//
//

import Foundation

public class Value {
    
}

func == (left: Value, right: Value) -> Bool {
    return left === right
}

func != (left: Value, right: Value) -> Bool {
    return !(left == right)
}