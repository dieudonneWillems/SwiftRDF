//
//  Document.swift
//  Ontologist
//
//  Created by Don Willems on 18/01/16.
//  Copyright © 2016 lapsedpacifist. All rights reserved.
//

import Cocoa
import SwiftRDFOSX

class RDFDocument: NSDocument, RDFParserDelegate {
    
    internal private(set) var graph : Graph? = Graph()

    override init() {
        super.init()
        // Add your subclass-specific initialization here.
    }

    override func windowControllerDidLoadNib(aController: NSWindowController) {
        super.windowControllerDidLoadNib(aController)
        // Add any code here that needs to be executed once the windowController has loaded the document's window.
    }

    override class func autosavesInPlace() -> Bool {
        return true
    }

    override func makeWindowControllers() {
        // Returns the Storyboard that contains your Document window.
        let storyboard = NSStoryboard(name: "Main", bundle: nil)
        let windowController = storyboard.instantiateControllerWithIdentifier("Document Window Controller") as! RDFDocumentWindowController
        self.addWindowController(windowController)
        windowController.startProgress(self)
    }

    override func dataOfType(typeName: String) throws -> NSData {
        // Insert code here to write your document to data of the specified type. If outError != nil, ensure that you create and set an appropriate error when returning nil.
        // You can also choose to override fileWrapperOfType:error:, writeToURL:ofType:error:, or writeToURL:ofType:forSaveOperation:originalContentsURL:error: instead.
        throw NSError(domain: NSOSStatusErrorDomain, code: unimpErr, userInfo: nil)
    }

    override func readFromData(data: NSData, ofType typeName: String) throws {
        // Insert code here to read your document from the given data of the specified type. If outError != nil, ensure that you create and set an appropriate error when returning false.
        // You can also choose to override readFromFileWrapper:ofType:error: or readFromURL:ofType:error: instead.
        // If you override either of these, you should also override -isEntireFileLoaded to return false if the contents are lazily loaded.
        print("URL: \(self.fileURL)")
        print("type: \(typeName)")
        let urlstr = self.fileURL?.absoluteString
        let uri = URI(string: urlstr!)
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0)) { // 1
            var parser : RDFParser? = nil
            if typeName == "RDF/XML Document" {
                parser = RDFXMLParser(data: data, baseURI: uri!, encoding: NSUTF8StringEncoding)
            } else if typeName == "RDF Turtle Document" {
                parser = TurtleParser(data: data, baseURI: uri!, encoding: NSUTF8StringEncoding)
            }
            if parser != nil {
                parser!.delegate = self
                self.graph = parser!.parse()
            }
            dispatch_async(dispatch_get_main_queue()) {
                if self.graph == nil {
                    print("\n\nCould not parse RDF document!\n")
                    // TODO: handle error
                    //throw NSError(domain: NSOSStatusErrorDomain, code: unimpErr, userInfo: nil)
                }else {
                    let windowControllers = self.windowControllers
                    for windowController in windowControllers {
                        if (windowController as? RDFDocumentWindowController) != nil {
                            let rdfwc = (windowController as! RDFDocumentWindowController)
                            rdfwc.documentHasBeenParsed(self)
                        }
                    }
                }
            }
        }
    }
    
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
      //  print("RDF Parser: namespace with prefix \(prefix) and URI \(namespaceURI) was added.")
    }
    
    func statementAdded(_parser : RDFParser, graph : Graph, statement : Statement) {
      //  print("RDF Parser: the statement \(statement) was added.")
    }

}

