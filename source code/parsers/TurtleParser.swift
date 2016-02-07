//
//  TurtleParser.swift
//  
//
//  Created by Don Willems on 07/02/16.
//
//

import Foundation


/**
 This class is an implementation of `RDFParser` that is able to parse Turtle files.
 A specification for the Turtle format can be retrieved from
 [W3C](https://www.w3.org/TR/turtle/)
 
 The RDF data is parsed when the `parse()` function is called.
 */
public class TurtleParser : NSObject, RDFParser {
    
    /**
     The delegate that recieves parsing events when parsing is in progress.
     */
    public var delegate : RDFParserDelegate?
    private var running = false
    private var currentGraph : Graph?
    private var baseURI : URI?
    
    /// Used during parsing
    private var contentString : String
    
    /**
     Initialises a parser with the contents of the RDF file reference by the given
     URL.
     
     - parameter url: The URL of the RDF file to be parsed.
     - returns: An initialised RDF parser or nil if the parser could not
     be initialised on the URL.
     */
    public required convenience init?(url : NSURL) {
        let data = NSData(contentsOfURL: url)
        let baseURI = URI(string: url.absoluteString)
        if data == nil  || baseURI == nil {
            return nil
        }
        self.init(data: data!, baseURI:baseURI!)
    }
    
    /**
     Initialises a parser with the contents of the RDF file reference by the given
     URI. The URI should point to the file to be parsed, i.e. should be an URL,
     which is a subtype of URI.
     
     - parameter uri: The URI of the RDF file to be parsed.
     - returns: An initialised RDF parser, or nil if the URI is not a URL.
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
     - parameter baseURI: The base URI of the document (often the URL of the document),
     will be overridden when a base URI is defined in the RDF/XML file.
     - returns: An initialised RDF parser.
     */
    public required init(data : NSData, baseURI : URI) {
        contentString = NSString(data: data, encoding: NSUTF8StringEncoding) as! String
        self.baseURI = baseURI
    }
    
    /**
     Starts the event driven parsing operation. Statements parsed from the RDF file
     are added to the returned graph. While the parsing process is running the specified
     `delegate` recieves parsing events.
     
     - returns: The graph containing all statements parsed from the RDF file, or nil if
     an error occurred.
     */
    public func parse() -> Graph? {
        while running {
            NSThread.sleepForTimeInterval(0.1)
        }
        running = true
        
        if baseURI != nil {
            currentGraph = Graph(name: baseURI!)
        }else {
            currentGraph = Graph()
        }
        parseContents()
        
        running = false
        //print("** FINISHED PARSING Turtle **")
        return currentGraph
    }
    
    /**
     Parses the string content as Turtle.
     */
    private func parseContents() {
        var currentSubject : Resource? = nil
        var currentPredicate : URI? = nil
        var currentObject : Value? = nil
        var index = contentString.startIndex
        var prevc : Character? = nil
        var startStrIndex : String.Index = index
        var endStrIndex : String.Index = index
        var inComment = false
        var inURI = false
        var inLiteralChar : Character? = nil
        while index < contentString.endIndex {
            let c = contentString[index]
            
            if c == "#" && !inURI {
                inComment = true
            } else if c == "\n" {
                inComment = false
            }
            
            if !inComment {
                var newValueIsURI = false
                var range : Range<String.Index>?
                if c == " " || c == "\t" || c == "\n" {
                    if inLiteralChar == nil && !inURI {
                        endStrIndex = index
                        if startStrIndex < endStrIndex {
                            range = Range<String.Index>(start: startStrIndex, end: endStrIndex)
                        }
                        startStrIndex = index
                    }
                }else if (c == "." || c == ";" || c == ",") && inLiteralChar == nil && !inURI {
                    endStrIndex = index
                    if startStrIndex < endStrIndex {
                        range = Range<String.Index>(start: startStrIndex, end: endStrIndex)
                    }
                    startStrIndex = index
                }else if c == "\"" && prevc != "\\" && !inURI {
                    if inLiteralChar == nil { // start double quotes
                        inLiteralChar = c
                    } else if inLiteralChar == "\"" { // close double quotes
                        inLiteralChar = nil
                    }
                }else if c == "\'" && prevc != "\\" && !inURI {
                    if inLiteralChar == nil { // start single quotes
                        inLiteralChar = c
                    } else if inLiteralChar == "\'" { // close single quotes
                        inLiteralChar = nil
                    }
                }else if c == "<" &&  inLiteralChar == nil {
                    if !inURI {
                        inURI = true
                        startStrIndex = index.advancedBy(1)
                    }else {
                        // TODO: Throw error
                    }
                }else if c == ">" &&  inLiteralChar == nil {
                    if inURI {
                        inURI = false
                        endStrIndex = index
                        range = Range<String.Index>(start: startStrIndex, end: endStrIndex)
                        index = index.advancedBy(1)
                        startStrIndex = index
                        newValueIsURI = true
                    }else {
                        // TODO: Throw error
                    }
                }
                
                if range != nil {
                    let curStr = contentString.substringWithRange(range!)
                    
                    // TODO: create subject, predicate, object
                    if currentSubject == nil {
                        if newValueIsURI {
                            currentSubject = URIFromString(curStr)
                        } else {
                            currentSubject = resourceFromString(curStr)
                        }
                    } else if currentPredicate == nil {
                        currentPredicate = URIFromString(curStr)
                    } else if currentObject == nil {
                        if newValueIsURI {
                            currentObject = URIFromString(curStr)
                        } else {
                            currentObject = valueFromString(curStr)
                        }
                    }
                    
                    if currentSubject != nil && currentPredicate != nil && currentObject != nil {
                        let statement = Statement(subject: currentSubject!, predicate: currentPredicate!, object: currentObject!)
                        currentGraph?.add(statement)
                        if delegate != nil {
                            delegate?.statementAdded(self, graph: currentGraph!, statement: statement)
                        }
                    }
                    if c == "." && inLiteralChar == nil && !inURI { // new subject expected
                        currentSubject = nil
                        currentPredicate = nil
                        currentObject = nil
                    }else if c == ";" && inLiteralChar == nil && !inURI { // new predicate expected
                        currentPredicate = nil
                        currentObject = nil
                    }else if (c == "," && inLiteralChar == nil && !inURI) || newValueIsURI { // new object expected
                        currentObject = nil
                    }
                }
            }
            
            index = index.advancedBy(1)
            prevc = c
        }
        if delegate != nil {
            delegate?.parserDidEndDocument(self)
        }
    }
    
    private func resourceFromString(string : String) -> Resource? {
        print("resource from string: \(string)")
        return nil
    }
    
    private func URIFromString(string : String) -> URI? {
        print("URI from string: \(string)")
        return URI(string: string)
    }
    
    private func valueFromString(string : String) -> Value? {
        print("value from string: \(string)")
        let literal = Literal(sparqlString: string)
        return literal
    }
}
