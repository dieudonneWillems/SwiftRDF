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
    
    // State during parsing
    private var currentSubject : Resource?
    private var currentPredicate : URI?
    
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
        contentString = self.removeComments(contentString)
        self.parseTurtle(contentString)
        if delegate != nil {
            delegate?.parserDidEndDocument(self)
        }
    }
    
    private func removeComments(string : String) -> String {
        let lines = string.characters.split{$0 == "\n"}.map(String.init)
        var newstring = ""
        let regex = grammar!["comment"]!
        for line in lines {
            let nsstring = line as NSString
            let matches = regex.matchesInString(line, options: [], range: NSMakeRange(0, line.characters.count)) as Array<NSTextCheckingResult>
            if matches.count > 0 {
                let match = matches[0]
                if match.numberOfRanges == 2 {
                    let range = match.rangeAtIndex(1)
                    if range.location != NSNotFound {
                        newstring += (nsstring.substringToIndex(range.location) as String) + "\n"
                    }else {
                        newstring += line + "\n"
                    }
                }else {
                    newstring += line + "\n"
                }
            }else {
                newstring += line + "\n"
            }
        }
        print("\n----- string without comments:\n\(newstring)")
        return newstring
    }
    
    private func parseTurtle(contentString: String) -> Bool {
        let statements = self.statements(contentString)
        for statement in statements {
            print(">>  \(statement)")
            var success = parseDirectiveFromStatement(statement)
            if !success {
                success = parseTriplesFromStatement(statement)
            }
            if !success {
                return false
            }
        }
        return true
    }
    
    private func parseDirectiveFromStatement(statement : String) -> Bool {
        let directives = self.runRegularExpression(grammar!["directive"]!, onString: statement)
        for directive in directives {
            let flag = parsePrefix(directive)
            if !flag {
                parseBaseURI(directive)
            }
        }
        return directives.count > 0
    }
    
    private func parseTriplesFromStatement(statement : String) -> Bool {
        print("statement: \(statement)")
        let subjecPredicateObjects = self.runRegularExpressionWithGroups(grammar!["triplesGroups"]!, onString: statement)
        for spos in subjecPredicateObjects {
            if spos.count == 5 {
                let subjectstr = spos[1]
                if subjectstr != nil {
                    let predicateObjectList = spos[2]
                    currentSubject = self.parseSubject(subjectstr!)
                    if currentSubject == nil {
                        delegate?.parserErrorOccurred(self, error: RDFParserError.malformedRDFFormat(message: "Could not extract subject from SubjectPredicateObject statement '\(statement)'."))
                        return false
                    }
                    if predicateObjectList == nil {
                        return false
                    }
                    let polSuccess = parsePredicateObjectLists(predicateObjectList!)
                    if !polSuccess {
                        return false
                    }
                }else {
                    let predicateObjectList = spos[4]
                    currentSubject = self.parseBlankNodePropertyList(spos[3]!)
                    if currentSubject == nil {
                        delegate?.parserErrorOccurred(self, error: RDFParserError.malformedRDFFormat(message: "Could not extract subject from SubjectPredicateObject statement '\(statement)'."))
                        return false
                    }
                    if predicateObjectList == nil {
                        return false
                    }
                    let polSuccess = parsePredicateObjectLists(predicateObjectList!)
                    if !polSuccess {
                        return false
                    }
                }
            }else if spos.count == 2 {
                delegate?.parserErrorOccurred(self, error: RDFParserError.malformedRDFFormat(message: "No Predicate and Object defined in SubjectPredicateObject statement '\(statement)'."))
                return false
            }else if spos.count <= 1 {
                delegate?.parserErrorOccurred(self, error: RDFParserError.malformedRDFFormat(message: "No Subject, Predicate and Object defined in SubjectPredicateObject statement '\(statement)'."))
                return false
            }
        }
        return subjecPredicateObjects.count > 0
    }
    
    private func parseSubject(string : String) -> Resource? {
        let subjectByType = self.runRegularExpressionWithGroups(grammar!["subjectParsingGroups"]!, onString: string)
        if subjectByType.count > 0  && subjectByType[0].count >= 4 {
            if subjectByType[0][1] != nil {
                return self.parseIRI(string)
            } else if subjectByType[0][3] != nil {
                var bnstr = string
                if bnstr.hasPrefix("_:") {
                    bnstr = bnstr.substringFromIndex(bnstr.startIndex.advancedBy("_:".characters.count))
                }
                return BlankNode(identifier: bnstr)
            } else if subjectByType[0][4] != nil {
                return BlankNode()
            } else if subjectByType[0][5] != nil {
                // TODO collection in subject
            }
        }
        return nil
    }
    
    private func parsePredicateObjectLists(string: String) -> Bool {
        let pol = self.runRegularExpressionWithGroups(grammar!["predicateObjectListGroups"]!, onString: string)
        if pol.count > 0  && pol[0].count > 3 {
            if pol[0][1] != nil {
                let predicate = pol[0][1]!
                var predicateURI : URI? = nil
                if predicate == "a" {
                    predicateURI = RDF.type
                } else {
                    predicateURI = self .parseIRI(predicate)
                }
                if predicateURI == nil {
                    delegate?.parserErrorOccurred(self, error: RDFParserError.malformedRDFFormat(message: "Malformed predicate in PredicateObjectList statement '\(string)'."))
                    return false
                }
                currentPredicate = predicateURI!
            } else {
                delegate?.parserErrorOccurred(self, error: RDFParserError.malformedRDFFormat(message: "No predicate defined in PredicateObjectList statement '\(string)'."))
                return false
            }
            if pol[0][2] != nil {
                let objectList = pol[0][2]!
                let success = self.parseObjectList(objectList)
                if !success {
                    return false
                }
            } else {
                delegate?.parserErrorOccurred(self, error: RDFParserError.malformedRDFFormat(message: "No object list defined in PredicateObjectList statement '\(string)'."))
            }
            if pol[0][3] != nil {
                let nextPredicateObjectList = pol[0][3]!
                if nextPredicateObjectList.characters.count > 0 {
                    let success = self.parsePredicateObjectLists(nextPredicateObjectList)
                    if !success {
                        return false
                    }
                }
            }
            return true
        }else {
            delegate?.parserErrorOccurred(self, error: RDFParserError.malformedRDFFormat(message: "Malformed PredicateObjectList statement '\(string)'."))
        }
        return false
    }
    
    private func parseObjectList(string : String) -> Bool {
        let ol = self.runRegularExpressionWithGroups(grammar!["objectListParsingGroups"]!, onString: string)
        if ol.count > 0  && ol[0].count > 2 {
            if ol[0][1] != nil {
                let objectstr = ol[0][1]!
                let success = self.parseObject(objectstr)
                if !success {
                    return false
                }
            }
            if ol[0][2] != nil && ol[0][2]!.characters.count > 0 {
                let objectliststr = ol[0][2]!
                let success = self.parseObjectList(objectliststr)
                if !success {
                    return false
                }
            }
            return true
        } else {
            delegate?.parserErrorOccurred(self, error: RDFParserError.malformedRDFFormat(message: "No objects were found in ObjectList statement '\(string)'."))
        }
        return false
    }
    
    private func parseObject(string : String) -> Bool {
        let ob = self.runRegularExpressionWithGroups(grammar!["objectGroups"]!, onString: string)
        if ob.count > 0  && ob[0].count > 5 {
            var object : Value?
            if ob[0][1] != nil { // iri
                let iristr = ob[0][1]!
                object = self.parseIRI(iristr)
                if object == nil {
                    delegate?.parserErrorOccurred(self, error: RDFParserError.malformedRDFFormat(message: "Malformed IRI in Object statement '\(string)'."))
                    return false
                }
            }else if ob[0][2] != nil { // blank node
                var bnstr = ob[0][2]!
                if bnstr.hasPrefix("_:") {
                    bnstr = bnstr.substringFromIndex(bnstr.startIndex.advancedBy("_:".characters.count))
                }
                object = BlankNode(identifier: bnstr)
            }else if ob[0][3] != nil { // literal
                let literalStr = ob[0][3]!
                object = Literal(sparqlString: literalStr)
            }else if ob[0][4] != nil { // collection
                // TODO: parse collection
            }else if ob[0][5] != nil { // blanknode property list
                let bnpl = ob[0][5]
                let success = self.parseBlankNodePropertyList(bnpl!) != nil
                return success
            }
            if object == nil {
                delegate?.parserErrorOccurred(self, error: RDFParserError.malformedRDFFormat(message: "Could not extract object from Object statement '\(string)'."))
                return false
            }
            if currentSubject == nil {
                delegate?.parserErrorOccurred(self, error: RDFParserError.malformedRDFFormat(message: "Object was correctly parsed but no subject was defined."))
                return false
            }
            if currentPredicate == nil {
                delegate?.parserErrorOccurred(self, error: RDFParserError.malformedRDFFormat(message: "Object was correctly parsed but no predicate was defined."))
                return false
            }
            let statement = Statement(subject: currentSubject!, predicate: currentPredicate!, object: object!, namedGraph: baseURI!)
            currentGraph?.add(statement)
            if delegate != nil {
                delegate?.statementAdded(self, graph: currentGraph!, statement: statement)
            }
            return true
        } else {
            delegate?.parserErrorOccurred(self, error: RDFParserError.malformedRDFFormat(message: "Could not extract object from Object statement '\(string)'."))
        }
        return false
    }
    
    private func parseBlankNodePropertyList(string : String) -> Resource? {
        let propertyList = self.runRegularExpressionWithGroups(grammar!["blankNodePropertyListGroups"]!, onString: string)
        if propertyList.count > 0 && propertyList[0].count == 2 {
            let newbn = BlankNode()
            if currentSubject != nil && currentPredicate != nil {
                let statement = Statement(subject: currentSubject!, predicate: currentPredicate!, object: newbn, namedGraph: baseURI!)
                currentGraph?.add(statement)
                if delegate != nil {
                    delegate?.statementAdded(self, graph: currentGraph!, statement: statement)
                }
            }
            currentSubject = newbn
            let success = self.parsePredicateObjectLists(propertyList[0][1]!)
            if !success {
                return nil
            }
            currentSubject = newbn
            return newbn
        }
        return nil
    }
    
    private func parseBaseURI(string : String) -> Bool {
        let bases = self.runRegularExpression(grammar!["bases"]!, onString: string)
        for base in bases {
            let iri = self.parseIRIRef(base)
            if iri != nil {
                baseURI = iri!
                if currentGraph?.baseURI == nil {
                    currentGraph?.baseURI = baseURI
                }
            }
        }
        return bases.count > 0
    }
    
    private func parsePrefix(string : String) -> Bool {
        let prefixes = self.runRegularExpression(grammar!["prefixes"]!, onString: string)
        for prefix in prefixes {
            let pnames = self.parsePNAME_NS(prefix)
            let iri = self.parseIRIRef(prefix)
            if iri != nil {
                self.prefixes[pnames[0]] = iri
                currentGraph?.addNamespace(pnames[0], namespaceURI: iri!.stringValue)
                if delegate != nil {
                    delegate!.namespaceAdded(self, graph: currentGraph!, prefix: pnames[0], namespaceURI: iri!.stringValue)
                }
            }
        }
        return prefixes.count > 0
    }
    
    private func parseIRI(string : String) -> URI? {
        if string.isPrefixedName {
            var prefix = string.prefixedNamePrefix
            if prefix == nil {
                prefix = ""
            }
            let localName = string.prefixedNameLocalPart
            var namespace = prefixes[prefix!]?.stringValue
            if namespace == nil {
                namespace = currentGraph?.namespaceForPrefix(prefix!)
            }
            if namespace == nil {
                // TODO Error udefined prefix.
                return nil
            }
            let uri = URI(namespace: namespace!, localName: localName!)
            return uri
        } else {
            return parseIRIRef(string)
        }
    }
    
    private func parseIRIRef(string : String) -> URI? {
        let irisstrs = self.runRegularExpression(grammar!["IRIREF"]!, onString: string)
        if irisstrs.count > 0 {
            let prsd = irisstrs[0].substringWithRange(Range<String.Index>(start: irisstrs[0].startIndex.advancedBy(1), end: irisstrs[0].endIndex.advancedBy(-1)))
            var iri = URI(string: prsd)
            if iri == nil && baseURI != nil {
                iri = URI(namespace: baseURI!.stringValue, localName: prsd)
            }
            return iri
        }
        return nil
    }
    
    private func parsePNAME_NS(string : String) -> [String] {
        var prefixes = [String]()
        let prefixstrs = self.runRegularExpression(grammar!["PNAME_NS"]!, onString: string)
        for prefixstr in prefixstrs {
            let pname = prefixstr.substringWithRange(Range<String.Index>(start: prefixstr.startIndex, end: prefixstr.endIndex.advancedBy(-1)))
            prefixes.append(pname)
        }
        return prefixes
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
    
    private func runRegularExpressionWithGroups(regex: NSRegularExpression, onString: String) -> [[String?]] {
        var results = [[String?]]()
        let nsstring = onString as NSString
        let matches = regex.matchesInString(onString, options: [], range: NSMakeRange(0, onString.characters.count)) as Array<NSTextCheckingResult>
        for match in matches {
            var groups = [String?]()
            for var index = 0; index < match.numberOfRanges; index++ {
                let range = match.rangeAtIndex(index)
                if range.location != NSNotFound {
                    let string = nsstring.substringWithRange(match.rangeAtIndex(index)) as String
                    groups.append(string)
                } else {
                    groups.append(nil)
                }
            }
            results.append(groups)
        }
        return results
    }
    
    private func createGrammar() {
        let PN_LOCAL_ESC = "\\\\[_~\\.\\-!\\$&'\\(\\)\\*\\+,;=/\\?#@%]"
        let HEX = "[0-9A-Fa-f]"
        let PERCENT = "%"+HEX+HEX
        let PLX = "(?:\(PERCENT))|(?:\(PN_LOCAL_ESC))"
        let PN_CHARS_BASE = "[A-Z]|[a-z]|[\\u00C0-\\u00D6]|[\\u00D8-\\u00F6]|[\\u00F8-\\u02FF]|[\\u0370-\\u037D]|[\\u037F-\\u1FFF]|[\\u200C-\\u200D]|[\\u2070-\\u218F]|[\\u2C00-\\u2FEF]|[\\u3001-\\uD7FF]|[\\uF900-\\uFDCF]|[\\uFDF0-\\uFFFD]|[\\U00010000-\\U000EFFFF]"
        let PN_CHARS_U = "(?:\(PN_CHARS_BASE)|_)"
        let PN_CHARS = "(?:\(PN_CHARS_U)|\\-|[0-9]|\\u00B7|[\\u0300-\\u036F]|[\\u203F-\\u2040])"
        let PN_PREFIX = "(?:\(PN_CHARS_BASE))(?:(?:(?:\(PN_CHARS)|\\.)*\(PN_CHARS))?)"
        let PN_LOCAL = "(?:\(PN_CHARS_U)|:|[0-9]|\(PLX))(?:(?:\(PN_CHARS)|\\.|:|\(PLX))*(?:\(PN_CHARS)|:|\(PLX)))?"
        let PNAME_NS = "(?:\(PN_PREFIX))?:"
        let PNAME_LN = "\(PNAME_NS)\(PN_LOCAL)"
        let BLANK_NODE_LABEL = "_:(?:\(PN_CHARS_U)|[0-9])(?:(?:\(PN_CHARS)|\\.)*\(PN_CHARS))?"
        let LANGTAG = "@[a-zA-Z]+(?:-[a-zA-Z0-9]+)*"
        let INTEGER = "[+-]?[0-9]+"
        let DECIMAL = "[+-]?[0-9]*\\.[0-9]+"
        let EXPONENT = "(?:[eE][+-]?[0-9]+)"
        let DOUBLE = "(?:[+-]?(?:(?:[0-9]+\\.[0-9]*\(EXPONENT))|(?:\\.[0-9]+\(EXPONENT))|(?:[0-9]+\(EXPONENT))))"
        let ECHAR = "\\\\[\\t\\n\\r\\f\\\"\\'\\\\]" // misses \b (backspace)
        let UCHAR = "(?:\\\\U\(HEX)\(HEX)\(HEX)\(HEX)\(HEX)\(HEX)\(HEX)\(HEX))|(?:\\\\u\(HEX)\(HEX)\(HEX)\(HEX))"
        let STRING_LITERAL_QUOTE = "\"(?:[^\\u0022\\u005C\\u000A\\u000D]|\(ECHAR)|\(UCHAR))*\"" /* #x22=" #x5C=\ #xA=new line #xD=carriage return */
        let STRING_LITERAL_SINGLE_QUOTE = "'(?:[^\\u0027\\u005C\\u000A\\u000D]|\(ECHAR)|\(UCHAR))*'" /* #x27=' #x5C=\ #xA=new line #xD=carriage return */
        let STRING_LITERAL_LONG_SINGLE_QUOTE = "'''(?:(?:'|'')?(?:[^'\\\\]|\(ECHAR)|\(UCHAR)))*'''"
        let STRING_LITERAL_LONG_QUOTE = "\"\"\"(?:(?:\"|\"\")?(?:[^\"\\\\]|\(ECHAR)|\(UCHAR)))*\"\"\""
        let ANON = "\\[\\s*\\]"
        let IRIREF = "<(?:[^\\u0000-\\u0020<>\"\\|\\^`\\\\]|\(UCHAR))*>\(PN_CHARS)?"
        
        let blankNode = "(?:\(BLANK_NODE_LABEL))|(?:\(ANON))"
        let blankNodeGroup = "(\(BLANK_NODE_LABEL))|(\(ANON))"
        let prefixedName = "(?:\(PNAME_LN))|(?:\(PNAME_NS))"
        let iri = "(?:(?:\(IRIREF))|(?:\(prefixedName)))"
        let string = "(?:(?:\(STRING_LITERAL_LONG_SINGLE_QUOTE))|(?:\(STRING_LITERAL_LONG_QUOTE))|(?:\(STRING_LITERAL_QUOTE))|(?:\(STRING_LITERAL_SINGLE_QUOTE)))"
        let booleanLiteral = "true|false"
        let RDFLiteral = "(?:(?:\(string))(?:(?:\(LANGTAG))|(?:\\^\\^\(iri)))?)"
        let numericalLiteral = "(?:(?:\(DOUBLE))|(?:\(DECIMAL))|(?:\(INTEGER)))"
        let literal = "(?:(?:\(RDFLiteral))|(?:\(numericalLiteral))|(?:\(booleanLiteral)))"
        let predicate = iri
        let collectionPlaceholder = "(?:\\((?>\\P{M}\\p{M}*)*\\))" // If matches on collection placeholder - test further with collection pattern
        let blankNodePropertyListPlaceholder = "(?:\\[(?>\\P{M}\\p{M}*)*\\])" // If matches on blanknode property list placeholder - test further with blanknode property list pattern
        let object = "(?:(?:\(iri))|(?:\(blankNode))|(?:\(literal))|(?:\(collectionPlaceholder))|(?:\(blankNodePropertyListPlaceholder)))"
        let objectGroups = "(?:(\(iri))|(\(blankNode))|(\(literal))|(\(collectionPlaceholder))|(\(blankNodePropertyListPlaceholder)))"
        let collection = "\\(\(object)*\\)"
        let objectList = "(?:\(object)(?:\\s*,\\s*\(object))*)"
        let objectListGroups = "(\(object)(?:\\s*,\\s*\(object))*)"
        let objectListParsingGroups = "(?:(\(object))((?:\\s*,\\s*\(object))*))"
        let verb = "(?:\(predicate)|a)"
        let verbGroups = "(\(predicate)|a)"
        let predicateObjectList = "(?:\(verb)\\s*\(objectList)(?:\\s*;\\s*(?:\(verb)\\s*\(objectList))?)*)"
        //let predicateObjectListGroups = "(?:\(verbGroups)\\s*\(objectListGroups)(?:\\s*;\\s*(\(verb)\\s*\(objectList))?)*)"
        let predicateObjectListGroups = "(?:\(verbGroups)\\s*\(objectListGroups)((?:\\s*;\\s*\(verb)\\s*\(objectList)?)*))"
        let blankNodePropertyList = "(?:\\[\\s*\(predicateObjectList)\\s*\\])"
        let blankNodePropertyListGroups = "(?:\\[\\s*(\(predicateObjectList))\\s*\\])"
        let subject = "(?:\(iri)|\(blankNode)|\(collection))"
        let subjectGroups = "(\(iri)|\(blankNode)|\(collection))"
        let subjectParsingGroups = "(\(iri))|(\(blankNodeGroup))|(\(collection))"
        let triples = "(?:(?:\(subject)\\s*\(predicateObjectList))|(?:\(blankNodePropertyList)\\s*\(predicateObjectList)?))"
        let triplesGroups = "(?:(?:\(subjectGroups)\\s*(\(predicateObjectList)))|(?:(\(blankNodePropertyList))\\s*(\(predicateObjectList)?)))"
        let sparqlPrefix = "(?:(?i)PREFIX(?-i)\\s*\(PNAME_NS)\\s*\(IRIREF))" // prefix should be case insensitive
        let sparqlBase = "(?:(?i)BASE(?-i)\\s*\(IRIREF))" // base should be case insensitive
        let prefixID = "(?:@prefix\\s*\(PNAME_NS)\\s*\(IRIREF)\\s*\\.)"
        let base = "(?:@base\\s*\(IRIREF)\\s*\\.)"
        let directive = "(?:(?:\(prefixID))|(?:\(base))|(?:\(sparqlPrefix))|(?:\(sparqlBase)))"
        let statement = "(?:(?:(?:\(directive))\\s*)|(?:(?:\(triples))\\s*\\.\\s*))"
        let turtleDoc = "\(statement)*"
        let comment = "^(?:[^<>'\"]|(?:<[^<>]*>)|(?:\"[^\"]*\"\\s*)|(?:'[^']*'\\s*)|(?:\"\"\".*\"\"\"\\s*)|(?:'''.*'''\\s*))*(#.*)$"
        
        grammar = [String : NSRegularExpression]()
        grammar!["turtleDoc"] = self.createGrammarRegEx("^\(turtleDoc)$")!
        grammar!["statement"] = self.createGrammarRegEx(statement)!
        grammar!["directive"] = self.createGrammarRegEx("\(directive)")!
        grammar!["triples"] = self.createGrammarRegEx("^\(triples)$")!
        grammar!["bases"] = self.createGrammarRegEx("^(?:(?:\(base))|(?:\(sparqlBase)))$")!
        grammar!["prefixes"] = self.createGrammarRegEx("^(?:(?:\(prefixID))|(?:\(sparqlPrefix)))$")!
        grammar!["IRIREF"] = self.createGrammarRegEx("\(IRIREF)")!
        grammar!["PNAME_NS"] = self.createGrammarRegEx("\(PNAME_NS)")!
        grammar!["triplesGroups"] = self.createGrammarRegEx("\(triplesGroups)")!
        grammar!["subjectParsingGroups"] = self.createGrammarRegEx("\(subjectParsingGroups)")!
        grammar!["predicateObjectListGroups"] = self.createGrammarRegEx("\(predicateObjectListGroups)")!
        grammar!["objectListParsingGroups"] = self.createGrammarRegEx("\(objectListParsingGroups)")!
        grammar!["objectGroups"] = self.createGrammarRegEx("\(objectGroups)")!
        grammar!["comment"] = self.createGrammarRegEx("\(comment)")!
        grammar!["blankNodePropertyListGroups"] = self.createGrammarRegEx("\(blankNodePropertyListGroups)")!
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
