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
    
    /**
     Defines the way in which statements are ordered by the formatter in its output.
     */
    var sortingOption : RDFFormatterSortingOption {get}
    
    
    // MARK: Initialisers
    
    /**
     Initialises a new formatter with the default sorting order.
     */
    init()
    
    /**
     Initialises a new formatter with the specified sorting option.
     
     - parameter sorting: The sorting order of the output created by the formatter.
     */
    init(sorting: RDFFormatterSortingOption)
    
    
    
    // MARK: Write functions
    
    /**
     Writes the contents of the specified `Graph` to the specified URL.
     If the file cannot be written to the specified URL, an error is thrown.
    
     - parameter graph: The graph whose contents should be written to the URL.
     - parameter toURL : The URL of the file where the contents of the `Graph` should
     be written to.
     - returns: True when the RDF data was succesfully writen to the URL.
     */
    func write(graph : Graph, toURL : NSURL) -> Bool
    
    
    // MARK: Format functions
    
    /**
     Formats the contents of the specified `Graph` and writes it to a data object.
     - parameter graph: The graph whose contents should be written into the data object.
     - returns: The data object.
     */
    func data(graph : Graph) -> NSData
    
    /**
     Formats the contents of the specified `Graph` and writes it to a string object.
     - parameter graph: The graph whose contents should be written into the string object.
     - returns: The string object.
     */
    func string(graph : Graph) -> String
}