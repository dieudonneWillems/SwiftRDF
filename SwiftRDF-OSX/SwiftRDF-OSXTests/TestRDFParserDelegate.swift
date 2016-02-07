//
//  TestRDFParserDelegate.swift
//  SwiftRDF-OSX
//
//  Created by Don Willems on 07/02/16.
//  Copyright © 2016 lapsedpacifist. All rights reserved.
//

import Foundation
@testable import SwiftRDFOSX

class TestRDFParserDelegate : RDFParserDelegate {
    
    func parserDidStartDocument(_parser : RDFParser) {
        print("RDF Parser started")
    }
    
    func parserDidEndDocument(_parser : RDFParser) {
        print("RDF Parser finished")
    }
    
    func parserErrorOccurred(_parser : RDFParser, error: RDFParserError) {
        switch error {
        case .couldNotCreateRDFParser(let message) :
            print("Could not create RDF parser: \(message)")
            break
        case .couldNotRetrieveRDFFileFromURI(let message, let uri) :
            print("Could not retrieve RDF file from URI '\(uri.stringValue)': \(message)")
            break
        case .couldNotRetrieveRDFFileFromURL(let message, let url) :
            print("Could not retrieve RDF file from URL '\(url)': \(message)")
            break
        case .malformedRDFFormat(let message) :
            print("Malformed RDF: \(message)")
            break
        }
    }
    
    func namespaceAdded(_parser : RDFParser, graph : Graph, prefix : String, namespaceURI : String) {
        print("RDF Parser: namespace with prefix \(prefix) and URI \(namespaceURI) was added.")
    }
    
    func statementAdded(_parser : RDFParser, graph : Graph, statement : Statement) {
        print("RDF Parser: the statement \(statement) was added.")
    }
}