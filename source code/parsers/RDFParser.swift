//
//  Parser.swift
//  
//
//  Created by Don Willems on 08/01/16.
//
//

import Foundation

/**
 This protocol defines the functions that need to be implemented by RDF parsers.
 A parser is initialised with a `URL`, `URI` or `NSData` object referencing, or
 encapsulating the RDF data in a specific format. Implementations of this protocol
 need to be created for each specific RDF format.
 
 The RDF data is parsed when the `parse()` function is called.
 */
public protocol RDFParser {
    
    /**
     The delegate that recieves parsing events when parsing is in progress.
     */
    var delegate : RDFParserDelegate? {get set}
    
    /**
     Initialises a parser with the contents of the RDF file reference by the given
     URL.
     
     - parameter url: The URL of the RDF file to be parsed.
     - returns: An initialised RDF parser or nil if the parser could not
     be initialised on the URL.
     */
    init?(url : NSURL)
    
    /**
     Initialises a parser with the contents of the RDF file reference by the given
     URI. The URI should point to the file to be parsed, i.e. should be an URL, 
     which is a subtype of URI.
     
     - parameter uri: The URI of the RDF file to be parsed.
     - returns: An initialised RDF parser, or nil if the URI is not a URL.
     */
    init?(uri : URI)
    
    /**
     Initialises a parser with the RDF contents encapsulated in the `NSData` object.
     
     - parameter data: The RDF data.
     - parameter baseURI: The base URI of the document (often the URL of the document),
     will be overridden when a base URI is defined in the RDF/XML file.
     - parameter encoding: The string encoding used in the data, e.g. `NSUTF8StringEncoding` or
     `NSUTF32StringEncoding`.
     - returns: An initialised RDF parser.
     */
    init(data : NSData, baseURI : URI, encoding : NSStringEncoding)
    
    /**
     Starts the event driven parsing operation. Statements parsed from the RDF file
     are added to the returned graph. While the parsing process is running the specified
     `delegate` recieves parsing events.
     
     - returns: The graph containing all statements parsed from the RDF file, or nil if 
     an error occurred.
     */
    func parse() -> Graph?
    
    
}