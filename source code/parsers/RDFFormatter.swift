//
//  RDFFormatter.swift
//  
//
//  Created by Don Willems on 23/02/16.
//
//

import Foundation


/**
 This protocol defines the functions that need to be implemented by RDF formatters.
 A formatter creates a file (or `NSData` object, or string) with the content of the
 RDF graph formatted in a specific format.
 
 The RDF data is formatted when one of the `write` or `format` functions is called.
 */
public protocol RDFFormatter {
    
    // MARK: Initialisers
    init()
    
    // MARK: Write functions
    func write(graph : Graph, toURL : NSURL) throws
    
    // MARK: Format functions
    func data(graph : Graph) -> NSData
    func string(graph : Graph) -> String
}