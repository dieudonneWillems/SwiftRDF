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
}