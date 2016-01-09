//
//  RDFXMLParser.swift
//  
//
//  Created by Don Willems on 08/01/16.
//
//

import Foundation


/**
 This class is an implementation of `RDFParser` that is able to parse RDF/XML files.
 A specification for the RDF/XML format can be retrieved from 
 [W3C](http://www.w3.org/TR/rdf-syntax-grammar/)
 
 The RDF data is parsed when the `parse()` function is called.
 */
public class RDFXMLParser : NSObject, RDFParser, NSXMLParserDelegate {
    
    /**
     The delegate that recieves parsing events when parsing is in progress.
     */
    public var delegate : RDFParserDelegate?
    
    private let xmlParser : NSXMLParser?
    
    /**
     Initialises a parser with the contents of the RDF file reference by the given
     URL.
     
     - parameter url: The URL of the RDF file to be parsed.
     - returns: An initialised RDF parser.
     */
    public required init(url : NSURL) {
        xmlParser = NSXMLParser(contentsOfURL: url)
        super.init()
        if xmlParser != nil {
            xmlParser!.delegate = self
            xmlParser!.shouldProcessNamespaces = true
            xmlParser!.shouldReportNamespacePrefixes = true
        }
    }
    
    /**
     Initialises a parser with the contents of the RDF file reference by the given
     URI. The URI should point to the file to be parsed, i.e. should be an URL,
     which is a subtype of URI.
     
     - parameter uri: The URI of the RDF file to be parsed.
     - returns: An initialised RDF parser.
     */
    public required convenience init?(uri : URI) {
        let url = NSURL(string: uri.stringValue)
        if url == nil {
            return nil
        }
        self.init(url: url!)
    }
    
    /**
     Initialises a parser with the RDF contents encapsulated in the `NSData` object.
     
     - parameter data: The RDF data.
     - returns: An initialised RDF parser.
     */
    public required init(data : NSData) {
        xmlParser = NSXMLParser(data: data)
        super.init()
        if xmlParser != nil {
            xmlParser!.delegate = self
            xmlParser!.shouldProcessNamespaces = true
            xmlParser!.shouldReportNamespacePrefixes = true
        }
    }
    
    /**
     Starts the event driven parsing operation. Statements parsed from the RDF file
     are added to the returned graph. While the parsing process is running the specified
     `delegate` recieves parsing events.
     
     - returns: The graph containing all statements parsed from the RDF file.
     */
    public func parse() -> Graph? {
        var success = false
        if xmlParser != nil {
            success = xmlParser!.parse()
        }
        if !success {
            if delegate != nil {
                delegate!.parserErrorOccurred(self, error: RDFParserError.couldNotCreateRDFParser(message: "Could not create the XML parser to parse the RDF/XML file."))
            }
        }
        print("** FINISHED PARSING RDF/XML **")
        return nil
    }
    
    // MARK: XML parser delegate functions
    
    public func parserDidStartDocument(parser: NSXMLParser) {
        print("Started XML document parsing.")
        if delegate != nil {
            delegate!.parserDidStartDocument(self)
        }
    }
    
    public func parserDidEndDocument(parser: NSXMLParser) {
        print("Finished XML document parsing.")
        if delegate != nil {
            delegate!.parserDidEndDocument(self)
        }
    }
    
    public func parser(parser: NSXMLParser,parseErrorOccurred parseError: NSError) {
        print("Error occurred while parsing of the XML document.")
        if delegate != nil {
            delegate!.parserErrorOccurred(self, error: RDFParserError.couldNotCreateRDFParser(message: parseError.description))
        }
    }
    
    public func parser(parser: NSXMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String]) {
        print("Started on element \(elementName) with attributes \(attributeDict).")
    }
    
    public func parser(parser: NSXMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        print("Finished on element \(elementName).")
    }
    
    public func parser(parser: NSXMLParser, didStartMappingPrefix prefix: String, toURI namespaceURI: String) {
        print("Started mapping prefix \(prefix) to namespace \(namespaceURI).")
    }
    
    public func parser(parser: NSXMLParser, didEndMappingPrefix prefix: String) {
        print("Finished mapping prefix \(prefix).")
    }
    
    public func parser(parser: NSXMLParser, foundCharacters string: String) {
        print("Found characters '\(string)'.")
    }
    
    public func parser(parser: NSXMLParser, foundIgnorableWhitespace whitespaceString: String){
        print("Found ignorable whitespace '\(whitespaceString)'.")
    }
}