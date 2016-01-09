//
//  RDFParserError.swift
//  
//
//  Created by Don Willems on 08/01/16.
//
//

import Foundation

/**
 Defines the different errors that can be thrown while parsing an RDF file using
 implementations of `RDFParser`.
 */
public enum RDFParserError : ErrorType {
    
    /**
     The file could not be retrieved from the specfied `URI`.
     */
    case couldNotRetrieveRDFFileFromURI(message : String, uri : URI)
    
    /**
     The file could not be retrieved from the specfied `URL`.
     */
    case couldNotRetrieveRDFFileFromURL(message : String, url : NSURL)
    
    /**
     Could not create an RDF parser.
     */
    case couldNotCreateRDFParser(message : String)
    
}
