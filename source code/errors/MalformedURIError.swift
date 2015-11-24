//
//  MalformedURIError.swift
//  
//
//  Created by Don Willems on 22/11/15.
//
//

import Foundation

public enum MalformedURIError : ErrorType {
    
    case URISchemeMissing(message : String, uri : String)
    case URIContainsInvalidCharacters(message : String, uri : String)
    case MalformedURI(message : String, uri : String)
    
}