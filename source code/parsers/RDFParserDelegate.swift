//
//  RDFParserDelegate.swift
//  
//
//  Created by Don Willems on 09/01/16.
//
//

import Foundation

public protocol RDFParserDelegate {
    
    func parserDidStartDocument(_parser : RDFParser)
    
    func parserDidEndDocument(_parser : RDFParser)
    
    func parserErrorOccurred(_parser : RDFParser, error: RDFParserError)
    
    func namespaceAdded(_parser : RDFParser, graph : Graph, prefix : String, namespaceURI : String)
    
    func statementAdded(_parser : RDFParser, graph : Graph, statement : Statement)
}