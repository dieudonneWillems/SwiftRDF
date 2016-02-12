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
    
    private var grammar : [String : NSRegularExpression]? = nil
    
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
        self.init(data: data!, baseURI:baseURI!,encoding: NSUTF8StringEncoding)
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
     - parameter encoding: The string encoding used in the data, e.g. `NSUTF8StringEncoding` or
     `NSUTF32StringEncoding`.
     - returns: An initialised RDF parser.
     */
    public required init(data : NSData, baseURI : URI, encoding : NSStringEncoding) {
        contentString = NSString(data: data, encoding: encoding) as! String
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
        if grammar == nil {
            createGrammar()
        }
        if delegate != nil {
            delegate?.parserDidStartDocument(self)
        }
        self.parseTurtle(contentString)
        if delegate != nil {
            delegate?.parserDidEndDocument(self)
        }
    }
    
    private func parseTurtle(contentString: String) {
        let statements = self.statements(contentString)
        for statement in statements {
            print("\(statement)")
        }
    }
    
    private func statements(contentString : String) -> [String] {
        return self.runRegularExpression(grammar!["statement"]!, onString: contentString)
    }
    
    private func runRegularExpression(regex: NSRegularExpression, onString: String) -> [String] {
        var results = [String]()
        let nsstring = onString as NSString
        let matches = regex.matchesInString(onString, options: [], range: NSMakeRange(0, onString.characters.count)) as Array<NSTextCheckingResult>
        for match in matches {
            if match.rangeAtIndex(0).location != NSNotFound {
                let string = nsstring.substringWithRange(match.rangeAtIndex(0)) as String
                results.append(string)
            }
        }
        return results
    }
    
    private func createGrammar() {
        let PN_LOCAL_ESC = "\\\\[_~\\.\\-!\\$&'\\(\\)\\*\\+,;=/\\?#@%]"
        let HEX = "[0-9A-Fa-f]"
        let PERCENT = "%"+HEX+HEX
        let PLX = "(?:\(PERCENT))|(\(PN_LOCAL_ESC))"
        let PN_CHARS_BASE = "[A-Z]|[a-z]|[\\u00C0-\\u00D6]|[\\u00D8-\\u00F6]|[\\u00F8-\\u02FF]|[\\u0370-\\u037D]|[\\u037F-\\u1FFF]|[\\u200C-\\u200D]|[\\u2070-\\u218F]|[\\u2C00-\\u2FEF]|[\\u3001-\\uD7FF]|[\\uF900-\\uFDCF]|[\\uFDF0-\\uFFFD]|[\\U00010000-\\U000EFFFF]"
        let PN_CHARS_U = "(?:\(PN_CHARS_BASE)|_)"
        let PN_CHARS = "(?:\(PN_CHARS_U)|\\-|[0-9]|\\u00B7|[\\u0300-\\u036F]|[\\u203F-\\u2040])"
        let PN_PREFIX = "(?:\(PN_CHARS_BASE))(?:(?:(?:\(PN_CHARS)|\\.)*\(PN_CHARS))?)"
        let PN_LOCAL = "(?:\(PN_CHARS_U)|:|[0-9]|\(PLX))(?:(?:\(PN_CHARS)|\\.|:|\(PLX))*(?:\(PN_CHARS)|:|\(PLX)))?"
        let PNAME_NS = "(?:\(PN_PREFIX))?:"
        let PNAME_LN = "\(PNAME_NS)\(PN_LOCAL)"
        let BLANK_NODE_LABEL = "_:(\(PN_CHARS_U)|[0-9])((\(PN_CHARS)|\\.)*\(PN_CHARS))?"
        let LANGTAG = "@[a-zA-Z]+(-[a-zA-Z0-9]+)*"
        let INTEGER = "[+-]?[0-9]+"
        let DECIMAL = "[+-]?[0-9]*\\.[0-9]+"
        let EXPONENT = "(?:[eE][+-]?[0-9]+)"
        let DOUBLE = "(?:[+-]?(?:([0-9]+\\.[0-9]*\(EXPONENT))|(?:\\.[0-9]+\(EXPONENT))|(?:[0-9]+\(EXPONENT))))"
        let ECHAR = "\\\\[\\t\\n\\r\\f\\\"\\'\\\\]" // misses \b (backspace)
        let UCHAR = "(?:\\\\U\(HEX)\(HEX)\(HEX)\(HEX)\(HEX)\(HEX)\(HEX)\(HEX))|(?:\\\\u\(HEX)\(HEX)\(HEX)\(HEX))"
        let STRING_LITERAL_QUOTE = "\"(?:[^\\u0022\\u005C\\u000A\\u000D]|\(ECHAR)|\(UCHAR))*\"" /* #x22=" #x5C=\ #xA=new line #xD=carriage return */
        let STRING_LITERAL_SINGLE_QUOTE = "'(?:[^\\u0027\\u005C\\u000A\\u000D]|\(ECHAR)|\(UCHAR))*'" /* #x27=' #x5C=\ #xA=new line #xD=carriage return */
        let STRING_LITERAL_LONG_SINGLE_QUOTE = "'''(?:(?:'|'')?(?:[^'\\\\]|\(ECHAR)|\(UCHAR)))*'''"
        let STRING_LITERAL_LONG_QUOTE = "\"\"\"(?:(?:\"|\"\")?(?:[^\"\\\\]|\(ECHAR)|\(UCHAR)))*\"\"\""
        let ANON = "\\[\\s*\\]"
        let IRIREF = "<(?:[^\\u0000-\\u0020<>\"\\|\\^`\\\\]|\(UCHAR))*>\(PN_CHARS)?"
        
        let blankNode = "(?:\(BLANK_NODE_LABEL))|(?:\(ANON))"
        let prefixedName = "(?:\(PNAME_LN))|(?:\(PNAME_NS))"
        let iri = "(?:(?:\(IRIREF))|(?:\(prefixedName)))"
        let string = "(?:(?:\(STRING_LITERAL_QUOTE))|(?:\(STRING_LITERAL_SINGLE_QUOTE))|(?:\(STRING_LITERAL_LONG_SINGLE_QUOTE))|(?:\(STRING_LITERAL_LONG_QUOTE)))"
        let booleanLiteral = "true|false"
        let RDFLiteral = "(?:(?:\(string))(?:(?:\(LANGTAG))|(?:\\^\\^\(iri)))?)"
        let numericalLiteral = "(?:(?:\(INTEGER))|(?:\(DECIMAL))|(?:\(DOUBLE)))"
        let literal = "(?:(?:\(RDFLiteral))|(?:\(numericalLiteral))|(?:\(booleanLiteral)))"
        let predicate = iri
        let collectionPlaceholder = "(?:\\(\\p{L}\\p{M}*\\))" // If matches on collection placeholder - test further with collection pattern
        let blankNodePropertyListPlaceholder = "(?:\\[\\p{L}\\p{M}*\\])" // If matches on blanknode property list placeholder - test further with blanknode property list pattern
        let object = "(?:(?:\(iri))|(?:\(blankNode))|(?:\(literal))|(?:\(collectionPlaceholder))|(?:\(blankNodePropertyListPlaceholder)))"
        let collection = "\\(\(object)*\\)"
        let objectList = "(?:\(object)(?:\\s*,\\s*\(object))*)"
        let verb = "(?:\(predicate)|a)"
        let predicateObjectList = "(?:\(verb)\\s*\(objectList)(?:\\s*;\\s*(?:\(verb)\\s*\(objectList))?)*)"
        let blankNodePropertyList = "(?:\\[\(predicateObjectList)\\])"
        let subject = "(?:\(iri)|\(blankNode)|\(collection))"
        let triples = "(?:(?:\(subject)\\s*\(predicateObjectList))|(?:\(blankNodePropertyList)\\s*\(predicateObjectList)?))"
        let sparqlPrefix = "(?:(?i)PREFIX(?-i)\\s*\(PNAME_NS)\\s*\(IRIREF))" // prefix should be case insensitive
        let sparqlBase = "(?:(?i)BASE(?-i)\\s*\(IRIREF))" // base should be case insensitive
        let prefixID = "(?:@prefix\\s*\(PNAME_NS)\\s*\(IRIREF)\\s*\\.)"
        let base = "(?:@base\\s*\(IRIREF)\\s*\\.)"
        let directive = "(?:(?:\(prefixID))|(?:\(base))|(?:\(sparqlPrefix))|(?:\(sparqlBase)))"
        let statement = "(?:(?:\(directive))|(?:\(triples)))"
        let turtleDoc = "\(statement)*"
        
        grammar = [String : NSRegularExpression]()
        grammar!["turtleDoc"] = self.createGrammarRegEx("^\(turtleDoc)$")!
        grammar!["statement"] = self.createGrammarRegEx(statement)!
        grammar!["directive"] = self.createGrammarRegEx("^\(directive)$")!
        grammar!["triples"] = self.createGrammarRegEx("^\(triples)$")!
    }
    
    private func createGrammarRegEx(pattern: String) -> NSRegularExpression? {
        do {
            let regex = try NSRegularExpression(pattern: "\(pattern)", options: [])
            return regex
        } catch {
            
        }
        return nil
    }
}
