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
    private var prefixes = [String : URI]()
    
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
        prefixes.removeAll()
        
        if baseURI != nil {
            currentGraph = Graph(name: baseURI!)
            currentGraph?.baseURI = baseURI!
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
        var line = ""
        var baseURISet = false
        while index < contentString.endIndex {
            var advanced = false
            let c = contentString[index]
            
            if c == "#" && !inURI {
                inComment = true
            } else if c == "\n" {
                if inComment {
                    startStrIndex = index.advancedBy(1)
                }
                inComment = false
            }
            
            if !inComment {
                line.append(c)
                if c == "\n" {
                    line = line.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
                    var isPrefixNotBase = false
                    var declrange :Range<String.Index>? = nil
                    if line.hasPrefix("@prefix") {
                        declrange = line.rangeOfString("@prefix")
                        isPrefixNotBase = true
                    }else if line.hasPrefix("PREFIX") {
                        declrange = line.rangeOfString("PREFIX")
                        isPrefixNotBase = true
                    }else if line.hasPrefix("@PREFIX") {
                        declrange = line.rangeOfString("@PREFIX")
                        isPrefixNotBase = true
                    }else if line.hasPrefix("prefix") {
                        declrange = line.rangeOfString("prefix")
                        isPrefixNotBase = true
                    }else if line.hasPrefix("base") {
                        declrange = line.rangeOfString("base")
                        isPrefixNotBase = false
                    }else if line.hasPrefix("BASE") {
                        declrange = line.rangeOfString("BASE")
                        isPrefixNotBase = false
                    }else if line.hasPrefix("@base") {
                        declrange = line.rangeOfString("@base")
                        isPrefixNotBase = false
                    }else if line.hasPrefix("@BASE") {
                        declrange = line.rangeOfString("@BASE")
                        isPrefixNotBase = false
                    }
                    if declrange != nil {
                        let colonrange = line.rangeOfString(":")
                        var prefix : String?
                        if colonrange != nil {
                            let prefixrange = Range<String.Index>(start: declrange!.endIndex, end: colonrange!.startIndex)
                            prefix = line.substringWithRange(prefixrange).stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
                        }
                        let openAngleRange = line.rangeOfString("<")
                        let closedAngleRange = line.rangeOfString(">")
                        if openAngleRange != nil && closedAngleRange != nil {
                            let namespaceRange = Range<String.Index>(start: openAngleRange!.endIndex, end: closedAngleRange!.startIndex)
                            let namespacestr = line.substringWithRange(namespaceRange)
                            var namespace = URI(string: namespacestr)
                            if namespace == nil && baseURI != nil {
                                namespace = URI(namespace: baseURI!.stringValue, localName: namespacestr)
                            }
                            if namespace != nil {
                                if prefix != nil && isPrefixNotBase { // prefix
                                    currentGraph?.addNamespace(prefix!, namespaceURI: namespace!.stringValue)
                                    if delegate != nil {
                                        delegate!.namespaceAdded(self, graph: currentGraph!, prefix: prefix!, namespaceURI: namespace!.stringValue)
                                    }
                                    prefixes[prefix!] = namespace!
                                } else if !isPrefixNotBase { // base URI
                                    baseURI = namespace!
                                    if !baseURISet {
                                        currentGraph?.baseURI = baseURI!
                                    }
                                    baseURISet = true
                                }
                            } else {
                                // TODO: throw error
                            }
                        } else {
                            // TODO: throw error
                        }
                        currentSubject = nil
                        currentPredicate = nil
                        currentObject = nil
                    }
                    line = ""
                }
                var newValueIsURI = false
                var range : Range<String.Index>?
                if c == " " || c == "\t" || c == "\n" {
                    if inLiteralChar == nil && !inURI {
                        endStrIndex = index
                        if startStrIndex < endStrIndex {
                            range = Range<String.Index>(start: startStrIndex, end: endStrIndex)
                        }
                        startStrIndex = index.advancedBy(1)
                    }
                }else if (c == "." || c == ";" || c == ",") && inLiteralChar == nil && !inURI {
                    endStrIndex = index
                    if startStrIndex < endStrIndex {
                        range = Range<String.Index>(start: startStrIndex, end: endStrIndex)
                    }
                    startStrIndex = index.advancedBy(1)
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
                }else if c == "<" && prevc != "\\" &&  inLiteralChar == nil {
                    if !inURI {
                        inURI = true
                        startStrIndex = index.advancedBy(1)
                    }else {
                        // TODO: Throw error
                    }
                }else if c == ">" && prevc != "\\" &&  inLiteralChar == nil {
                    if inURI {
                        inURI = false
                        endStrIndex = index
                        range = Range<String.Index>(start: startStrIndex, end: endStrIndex)
                        index = index.advancedBy(1)
                        advanced = true
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
                        if newValueIsURI {
                            currentPredicate = URIFromString(curStr)
                        } else if curStr == "a" {
                            currentPredicate = RDF.type
                        } else { // should be prefixed, i.e. qname
                            let resource = resourceFromString(curStr)
                            if (resource as? URI) != nil {
                                currentPredicate = (resource as! URI)
                            }else {
                                // TODO: throw error
                            }
                        }
                    } else if currentObject == nil {
                        if newValueIsURI {
                            currentObject = URIFromString(curStr)
                        } else {
                            currentObject = resourceFromString(curStr)
                            if currentObject == nil {
                                currentObject = valueFromString(curStr)
                            }
                        }
                    }
                    
                    if currentSubject != nil && currentPredicate != nil && currentObject != nil {
                        let statement = Statement(subject: currentSubject!, predicate: currentPredicate!, object: currentObject!)
                        currentGraph?.add(statement)
                        if delegate != nil {
                            delegate?.statementAdded(self, graph: currentGraph!, statement: statement)
                        }
                        currentObject = nil
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
            
            if !advanced {
                index = index.advancedBy(1)
            }
            prevc = c
        }
        if delegate != nil {
            delegate?.parserDidEndDocument(self)
        }
    }
    
    private func resourceFromString(string : String) -> Resource? {
        let trimmed = string.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
        print("resource from string: '\(trimmed)'")
        if trimmed.hasPrefix("_:") { // blank node
            let prefrng = trimmed.rangeOfString("_:")
            let identifier = trimmed.substringFromIndex(prefrng!.endIndex)
            return BlankNode(identifier: identifier)
        } else if trimmed.isQualifiedName { // should be qname
            let prefix = trimmed.qualifiedNamePrefix
            let localname = trimmed.qualifiedNameLocalPart
            if prefix != nil {
                let namespace = prefixes[prefix!]
                if namespace != nil {
                    let uri = URI(namespace: namespace!.stringValue, localName: localname!)
                    return uri
                }else{
                    let uri = currentGraph?.createURIFromQualifiedName(trimmed)
                    return uri
                }
            }
        } else if trimmed.hasPrefix(":") { // qname with empty prefix
            let localname = trimmed.substringFromIndex(trimmed.startIndex.advancedBy(1))
            let namespace = prefixes[""]
            if namespace != nil {
                let uri = URI(namespace: namespace!.stringValue, localName: localname)
                return uri
            }
        }
        return nil
    }
    
    private func URIFromString(string : String) -> URI? {
        let trimmed = string.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
        if trimmed.characters.count > 0 {
            print("URI from string: '\(trimmed)'")
            var uri = URI(string: trimmed)
            if uri == nil  && baseURI != nil {
                uri = URI(namespace: baseURI!.stringValue, localName: trimmed)
            }
            return uri
        }
        return nil
    }
    
    private func valueFromString(string : String) -> Value? {
        let trimmed = string.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
        if trimmed.characters.count > 0 {
            print("value from string: '\(trimmed)'")
            let literal = Literal(sparqlString: trimmed)
            return literal
        }
        return nil
    }
}
