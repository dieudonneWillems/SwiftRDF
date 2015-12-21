//
//  NumberFormattingError.swift
//  
//
//  Created by Don Willems on 04/12/15.
//
//

import Foundation

public enum LiteralFormattingError : ErrorType {
    
    case illegalValueForNumber(message : String)
    case malformedNumber(message : String, string : String)
    case malformedDate(message : String, string : String)
    case malformedTime(message : String, string : String)
    case malformedString(message : String, string : String)
    
}
