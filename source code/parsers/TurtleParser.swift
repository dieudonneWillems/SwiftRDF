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
    
    /**
     The delegate that recieves progress events when parsing is in progress.
     */
    public var progressDelegate : ProgressDelegate?
    
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
     This function is called by the parser to update progress information to be presented to the user.
     This function calls the `ProgressDelegate.updateProgress` function on the main (GUI) thread with the same parameters.
     
     - parameter progressTitle: The main title that can be used by the user to identify the process whose progress is
     being presented. In most cases the title remains the same during one time-consuming task.
     - parameter progressSubtitle: A subtitle that can be used by the user to identify the process whose progress is
     being presented. The subtitle will be updated several times during a time-consuming taks. The subtitle may are
     may not be presented to the user.
     - parameter progress: A numerical representation of the progress. The maximum value would be equal to the
     `target` parameter, if it can be determined at all.
     - parameter target: The target value of the numerical representation of the progress. If this value is `nil`,
     the progress is indeterminate.
     */
    private func updateProgress(progressTitle : String, progressSubtitle : String, progress : Double, target : Double?) {
        if progressDelegate != nil {
            dispatch_async(dispatch_get_main_queue()) {
                self.progressDelegate?.updateProgress(progressTitle, progressSubtitle: progressSubtitle, progress: progress, target: target)
            }
        }
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
        self.updateProgress("Parsing Turtle RDF file", progressSubtitle: "", progress: 0, target: nil)
        contentString = self.removeComments(contentString)
        self.parseTurtle(contentString)
        self.updateProgress("Parsing Turtle RDF file", progressSubtitle: "Finished parsing", progress: 0, target: nil)
        if delegate != nil {
            delegate?.parserDidEndDocument(self)
        }
    }
    
    /**
     Removes comments from the full content string.
     Comments caused a problem as they were not defined in the Turtle grammer.
     This function removes the comments prior to parsing the turtle file.
     
     - parameter string: The content string.
     - returns: The content string without comments.
     */
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
    
    /**
     Parses the turtle string into a `Graph` containing statements and namespaces.
     
     - parameter contentString: The string containing the full content of a turtle file.
     - returns: True when the parsing was succesfull.
     */
    private func parseTurtle(contentString: String) -> Bool {
        // Separates statements from each other, turtle statements may contain directives (such as base URI or prefixes), or triples.
        let statements = self.statements(contentString)
        var count = 0.0
        let target = Double(statements.count)
        for statement in statements {
            self.updateProgress("Parsing Turtle RDF file", progressSubtitle: "Parsing statements", progress: count, target: target)
            print("\nParsing statement: \n\(statement)\n")
            var success = parseDirectiveFromStatement(statement) // true when the statement is a directive (and adds base URIs and prefixes to the current graph.
            if !success { // false when the statement is NOT a directive (and should therefore be a triple).
                success = parseTriplesFromStatement(statement)
            }
            if !success { // if the statement cannot be parsed as either a directive or triple >> is an error in the turtle file.
                return false
            }
            count++
        }
        self.updateProgress("Parsing Turtle RDF file", progressSubtitle: "Finished parsing", progress: target, target: target)
        return true
    }
    
    /**
     Parses the directive in the provided statement, a prefix definition or a base URI.
     If the statement does not contain a directive false will be returned. This is not automatically an error, as the statement may also contain a
     triple.
     
     - parameter statement: The statement to be parsed as a directive.
     - returns: True, when the statement contains a directive, false otherwise.
     */
    private func parseDirectiveFromStatement(statement : String) -> Bool {
        let directives = self.runRegularExpression(grammar!["directive"]!, onString: statement) // Returns the directives found in the statement (either 0 or 1 directive).
        for directive in directives {
            let flag = parsePrefix(directive) // Tries to parse the directive as a prefix definition.
            if !flag {
                parseBaseURI(directive)     // Tries to parse the directive as a base URI
            }
        }
        return directives.count > 0
    }
    
    /**
     Parses the triples in the provided statement. One statement may contain multiple triples.
     
     - parameter statement: The statement to be parsed for triples.
     - returns: True when one or more triples could be parsed from the statement, false otherwise.
     */
    private func parseTriplesFromStatement(statement : String) -> Bool {
        // Parses the string for triples using the 'triplesGroups' regular expression. -> results in a list of substrings each containing a subject-predicate-object statement.
        let subjecPredicateObjects = self.runRegularExpressionWithGroups(grammar!["triplesGroups"]!, onString: statement)
        for spos in subjecPredicateObjects {
            if spos.count == 5 { // should contain 5 groups from the regex.
                let subjectstr = spos[1] // subject should be contained in first regex group if the subject is not a blank node.
                if subjectstr != nil { //
                    let predicateObjectList = spos[2]  // predicate-object list should be contained in the second regex group.
                    if predicateObjectList == nil {
                        currentGraph = nil
                        delegate?.parserErrorOccurred(self, error: RDFParserError.malformedRDFFormat(message: "Could not extract predicate-object list from SubjectPredicateObject statement '\(statement)'."))
                        return false
                    }
                    currentSubject = self.parseSubject(subjectstr!)
                    if currentSubject == nil {
                        currentGraph = nil
                        delegate?.parserErrorOccurred(self, error: RDFParserError.malformedRDFFormat(message: "Could not extract subject from SubjectPredicateObject statement '\(statement)'."))
                        return false
                    }
                    let polSuccess = parsePredicateObjectLists(predicateObjectList!) // parses the predicate-object list which are combined with the subject to create triples.
                    if !polSuccess {
                        return false
                    }
                }else {     // The subject is a blank node property list
                    let predicateObjectList = spos[4] // predicate-object list should be contained in the fourth regex group if the subject is a blank node property list.
                    if predicateObjectList == nil {
                        currentGraph = nil
                        delegate?.parserErrorOccurred(self, error: RDFParserError.malformedRDFFormat(message: "Could not extract predicate-object list from SubjectPredicateObject statement '\(statement)'."))
                        return false
                    }
                    currentSubject = self.parseBlankNodePropertyList(spos[3]!)
                    if currentSubject == nil {
                        currentGraph = nil
                        delegate?.parserErrorOccurred(self, error: RDFParserError.malformedRDFFormat(message: "Could not extract subject from SubjectPredicateObject statement '\(statement)'."))
                        return false
                    }
                    let polSuccess = parsePredicateObjectLists(predicateObjectList!) // parses the predicate-object list which are combined with the subject to create triples.
                    if !polSuccess {
                        return false
                    }
                }
            }else if spos.count == 2 {
                currentGraph = nil
                delegate?.parserErrorOccurred(self, error: RDFParserError.malformedRDFFormat(message: "No Predicate and Object defined in SubjectPredicateObject statement '\(statement)'."))
                return false
            }else if spos.count <= 1 {
                currentGraph = nil
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
                return parseCollectionInSubject(string)
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
                    currentGraph = nil
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
                currentGraph = nil
                delegate?.parserErrorOccurred(self, error: RDFParserError.malformedRDFFormat(message: "No object list defined in PredicateObjectList statement '\(string)'."))
                return false
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
            currentGraph = nil
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
            currentGraph = nil
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
                    currentGraph = nil
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
                let col = ob[0][4]
                let tempSubject = currentSubject
                let success = self.parseCollection(col!)
                currentSubject = tempSubject
                return success
            }else if ob[0][5] != nil { // blanknode property list
                let bnpl = ob[0][5]
                let tempSubject = currentSubject
                let success = self.parseBlankNodePropertyList(bnpl!) != nil
                currentSubject = tempSubject
                return success
            }
            if object == nil {
                currentGraph = nil
                delegate?.parserErrorOccurred(self, error: RDFParserError.malformedRDFFormat(message: "Could not extract object from Object statement '\(string)'."))
                return false
            }
            if currentSubject == nil {
                currentGraph = nil
                delegate?.parserErrorOccurred(self, error: RDFParserError.malformedRDFFormat(message: "Object was correctly parsed but no subject was defined."))
                return false
            }
            if currentPredicate == nil {
                currentGraph = nil
                delegate?.parserErrorOccurred(self, error: RDFParserError.malformedRDFFormat(message: "Object was correctly parsed but no predicate was defined."))
                return false
            }
            self.addStatement(currentSubject!, predicate: currentPredicate!, object: object!, namedGraph: baseURI!)
            return true
        } else {
            currentGraph = nil
            delegate?.parserErrorOccurred(self, error: RDFParserError.malformedRDFFormat(message: "Could not extract object from Object statement '\(string)'."))
        }
        return false
    }
    
    private func parseCollectionInSubject(string : String) -> Resource? {
        let objectSet = self.runRegularExpressionWithGroups(grammar!["collectionWithObjectPlaceholderGroups"]!, onString: string)
        if objectSet.count > 0 {
            if objectSet[0].count == 2{
                let objectSetStr = objectSet[0][1]!
                let objectsInCollection = self.runRegularExpressionWithGroups(grammar!["objectGroups"]!, onString: objectSetStr)
                var tempSubject : Resource? = nil
                if objectsInCollection.count > 0 {
                    for objectre in objectsInCollection {
                        let colObject = BlankNode()
                        if tempSubject == nil {
                            tempSubject = colObject
                        }
                        if currentSubject != nil && currentPredicate != nil {
                            self.addStatement(currentSubject!, predicate: currentPredicate!, object: colObject, namedGraph: baseURI!)
                        }
                        currentSubject = colObject
                        currentPredicate = RDF.first
                        var success = false
                        success = self.parseObject(objectre[0]!)
                        if !success {
                            return nil
                        }
                        currentPredicate = RDF.rest
                    }
                    self.addStatement(currentSubject!, predicate: currentPredicate!, object: RDF.NIL, namedGraph: baseURI!)
                } else {
                    if tempSubject != nil && currentPredicate != nil {
                        self.addStatement(tempSubject!, predicate: currentPredicate!, object: RDF.NIL, namedGraph: baseURI!)
                    }
                }
                return tempSubject
            }
        }
        
        if delegate != nil {
            currentGraph = nil
            delegate?.parserErrorOccurred(self, error:RDFParserError.malformedRDFFormat(message: "Could not parse objects from collection because the collection '\(string)' was malformed."))
        }
        return nil
    }
    
    private func parseCollection(string : String) -> Bool {
        let objectSet = self.runRegularExpressionWithGroups(grammar!["collectionWithObjectPlaceholderGroups"]!, onString: string)
        if objectSet.count > 0 {
            if objectSet[0].count == 2{
                let objectSetStr = objectSet[0][1]!
                let objectsInCollection = self.runRegularExpressionWithGroups(grammar!["objectGroups"]!, onString: objectSetStr)
                let tempSubject = currentSubject
                let tempPredicate = currentPredicate
                if objectsInCollection.count > 0 {
                    for objectre in objectsInCollection {
                        let colObject = BlankNode()
                        self.addStatement(currentSubject!, predicate: currentPredicate!, object: colObject, namedGraph: baseURI!)
                        currentSubject = colObject
                        currentPredicate = RDF.first
                        var success = false
                        success = self.parseObject(objectre[0]!)
                        if !success {
                            return false
                        }
                        currentPredicate = RDF.rest
                    }
                    self.addStatement(currentSubject!, predicate: currentPredicate!, object: RDF.NIL, namedGraph: baseURI!)
                } else {
                    if tempSubject != nil && currentPredicate != nil {
                        self.addStatement(tempSubject!, predicate: currentPredicate!, object: RDF.NIL, namedGraph: baseURI!)
                    }
                }
                currentSubject = tempSubject
                currentPredicate = tempPredicate
                return true
            }
        }
        
        if delegate != nil {
            currentGraph = nil
            delegate?.parserErrorOccurred(self, error:RDFParserError.malformedRDFFormat(message: "Could not parse objects from collection because the collection '\(string)' was malformed."))
        }
        return false
    }
    
    private func addStatement(subject : Resource, predicate: URI, object : Value, namedGraph: Resource) {
        let statement = Statement(subject: subject, predicate: predicate, object: object, namedGraph: namedGraph)
        currentGraph?.add(statement)
        if delegate != nil {
            delegate?.statementAdded(self, graph: currentGraph!, statement: statement)
        }
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
        let ECHAR = "\\\\[tbnrf\"'\\\\]"
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
        let objectWithCollectionPlaceholder = "(?:(?:\(iri))|(?:\(blankNode))|(?:\(literal))|(?:\(collectionPlaceholder))|(?:\(blankNodePropertyListPlaceholder)))"
        let collectionWithObjectPlaceholder = "\\((?:\\s*\(objectWithCollectionPlaceholder))*\\s*\\)"
        let collectionWithObjectPlaceholderGroups = "\\(((?:\\s*\(objectWithCollectionPlaceholder))*\\s*)\\)"
        let object = "(?:(?:\(iri))|(?:\(blankNode))|(?:\(literal))|(?:\(collectionWithObjectPlaceholder))|(?:\(blankNodePropertyListPlaceholder)))"
        let objectGroups = "(?:(\(iri))|(\(blankNode))|(\(literal))|(\(collectionWithObjectPlaceholder))|(\(blankNodePropertyListPlaceholder)))"
        //let collection = "\\(\(object)*\\)"
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
        let subject = "(?:\(iri)|\(blankNode)|\(collectionWithObjectPlaceholder))"
        let subjectGroups = "(\(iri)|\(blankNode)|\(collectionWithObjectPlaceholder))"
        let subjectParsingGroups = "(\(iri))|(\(blankNodeGroup))|(\(collectionWithObjectPlaceholder))"
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
        grammar!["collectionWithObjectPlaceholderGroups"] = self.createGrammarRegEx("\(collectionWithObjectPlaceholderGroups)")!
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
