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
    internal let xmlParser : NSXMLParser?
    private var xmlParserDelegate : NSXMLParserDelegate?
    
    /**
     Initialises a parser with the contents of the RDF file reference by the given
     URL.
     
     - parameter url: The URL of the RDF file to be parsed.
     - returns: An initialised RDF parser.
     */
    public required init(url : NSURL) {
        xmlParser = NSXMLParser(contentsOfURL: url)
        let intendedGraphName = URI(string: url.absoluteString)
        super.init()
        if xmlParser != nil && intendedGraphName != nil {
            xmlParserDelegate = XMLtoRDFParser(parser: self, name: intendedGraphName!)
            xmlParser!.delegate = xmlParserDelegate
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
     - parameter graphName: The name of the named graph, can be nil.
     - returns: An initialised RDF parser.
     */
    public required init(data : NSData, graphName : Resource?) {
        let intendedGraphName = graphName
        xmlParser = NSXMLParser(data: data)
        super.init()
        if xmlParser != nil && intendedGraphName != nil {
            xmlParserDelegate = XMLtoRDFParser(parser: self, name: intendedGraphName!)
            xmlParser!.delegate = xmlParserDelegate
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
            // TODO: when the parser failed.
        }
        print("** FINISHED PARSING RDF/XML **")
        return (xmlParserDelegate as! XMLtoRDFParser).graph
    }
    
}

internal class XMLtoRDFParser : NSObject, NSXMLParserDelegate {
    
    internal var rdfParser : RDFXMLParser;
    internal var graph : Graph?
    internal var graphName : Resource
    
    private static let rdfElements = [RDF.Description.stringValue,RDF.ROOT.stringValue]
    private static let rdfAttributes = [RDF.about.stringValue,RDF.datatype.stringValue,RDF.resource.stringValue,RDF.parseType.stringValue,"xml:lang"]
    
    private var currentElements = [(elementName: String, namespaceURI : String?, qualifiedName : String?, attributes : [String: String], text: String)]()
    private var currentSubjects = [Resource?]()
    private var currentPredicates = [URI?]()
    private var currentObjects = [Value?]()
    private var currentDatatype = [Datatype?]()
    private var currentLanguage = [String?]()
    private var inXMLLiteral = false
    private var XMLLiteralString : String? = nil
    private var textNodeString : String = ""
    private var XMLLiteralElementIsUnclosed = false
    
    /**
     The last subject parsed from the RDF/XML file at the current parse position.
     */
    private var lastSubject : Resource? {
        for var index = currentSubjects.count-1; index >= 0; index-- {
            if currentSubjects[index] != nil {
                return currentSubjects[index]
            }
        }
        return nil
    }
    
    /**
     The last predicate parsed from the RDF/XML file at the current parse position.
     */
    private var lastPredicate : URI? {
        for var index = currentPredicates.count-1; index >= 0; index-- {
            if currentPredicates[index] != nil {
                return currentPredicates[index]
            }
        }
        return nil
    }
    
    /**
     The last object parsed from the RDF/XML file at the current parse position.
     */
    private var lastObject : Value? {
        for var index = currentObjects.count-1; index >= 0; index-- {
            if currentObjects[index] != nil {
                return currentObjects[index]
            }
        }
        return nil
    }
    
    /**
     The last object parsed from the RDF/XML file at the current parse position.
     */
    private var lastDatatype : Datatype? {
        for var index = currentDatatype.count-1; index >= 0; index-- {
            if currentDatatype[index] != nil {
                return currentDatatype[index]
            }
        }
        return nil
    }
    
    /**
     The last object parsed from the RDF/XML file at the current parse position.
     */
    private var lastLanguage : String? {
        for var index = currentLanguage.count-1; index >= 0; index-- {
            if currentLanguage[index] != nil {
                return currentLanguage[index]
            }
        }
        return nil
    }
    
    // MARK: Namespace Properties
    private var currentNamespaces = [String : String]()
    private var namespaceMapping = [String : String]()
    private var prefixMapping = [String : String]()
    private var prefixesDefinedInXMLLiteral = [[String]?]()
    private var namespacePrefixesAddedBeforeElement = [String]()
    
    /**
     Creates a new XML to RDF parser which is an implementation of the `NSXMLParserDelegate` protocol.
     It is used to create a `Graph` from the contents of an RDF/XML file.
     
     - parameter parser: The RDF/XML parser.
     - parameter name: The name of the graph to be created.
     */
    internal init(parser : RDFXMLParser, name : Resource) {
        rdfParser = parser
        graphName = name
    }
    
    // MARK: XML parser delegate functions
    
    internal func parserDidStartDocument(parser: NSXMLParser) {
        print("Started XML document parsing.")
        currentElements.removeAll()
        currentSubjects.removeAll()
        currentPredicates.removeAll()
        currentObjects.removeAll()
        currentDatatype.removeAll()
        currentLanguage.removeAll()
        inXMLLiteral = false
        
        graph = Graph(name: graphName)
        if rdfParser.delegate != nil {
            rdfParser.delegate!.parserDidStartDocument(rdfParser)
        }
    }
    
    internal func parserDidEndDocument(parser: NSXMLParser) {
        print("Finished XML document parsing.")
        currentElements.removeAll()
        if rdfParser.delegate != nil {
            rdfParser.delegate!.parserDidEndDocument(rdfParser)
        }
    }
    
    internal func parser(parser: NSXMLParser,parseErrorOccurred parseError: NSError) {
        if rdfParser.delegate != nil && parseError.code != 512 {
            rdfParser.delegate!.parserErrorOccurred(rdfParser, error: RDFParserError.couldNotCreateRDFParser(message: parseError.description))
        }
        graph = nil
    }
    
    internal func parser(parser: NSXMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String]) {
        print("Started on element \(elementName) with attributes \(attributeDict).")
        currentElements.append((elementName,namespaceURI,qName,attributeDict,""))
        
        if !inXMLLiteral { // if in XML literal, do not process elements as RDF elements.
            prefixesDefinedInXMLLiteral.removeAll()
            var subject : Resource? = nil
            var predicate : URI? = nil
            var object : Value? = nil
            var datatype : Datatype? = nil
            var language : String? = nil
            
            // Find language attribute
            if attributeDict["xml:lang"] != nil {
                language = attributeDict["xml:lang"]
            }
            currentLanguage.append(language)
            
            // Find datatype attribute
            if attributesContainsAttributeName(attributeDict, nameURI: RDF.datatype) {
                let datatypeval = attributeValue(attributeDict, nameURI: RDF.datatype)
                if datatypeval != nil {
                    if datatypeval!.qualifiedNamePrefix == "xsd" {
                        datatype = Datatype(namespace: XSD.namespace(), localName: datatypeval!.qualifiedNameLocalPart!, derivedFromDatatype: nil, isListDataType: false)
                    } else {
                        let dturi = URIStringOrName(datatypeval!)
                        datatype = Datatype(uri: dturi, derivedFromDatatype: nil, isListDataType: false)
                    }
                }
            }
            currentDatatype.append(datatype)
            
            let elementURI = URIStringOrName(qName!)
            
            if elementURI != RDF.ROOT.stringValue { // ignore the rdf:RDF element
                
                let lastElements = self.lastElements()
                
                var elementResource : Resource? = nil
                
                if elementURI == RDF.Description.stringValue { // Handle rdf:Description elements
                    elementResource = self.handleRDFDescriptionElement(attributeDict)
                } else { // Type element
                    elementResource = URI(string: self.URIStringOrName(qName!)) // A predicate or the type of a subject
                }
                
                if !lastElements.subject && !lastElements.predicate && !lastElements.object { // no resources defined yet, this needs to be a subject
                    subject = elementResource
                } else if lastElements.predicate  { // needs to be an object
                    if elementResource != nil { // object is a resource ==> also a new subject
                        object = elementResource
                        subject = elementResource
                    }
                } else if lastElements.subject { // needs to be a predicate/property element
                    if ((elementResource as? URI) != nil) {
                        predicate = elementResource as? URI
                    }else{  // A predicate should be a URI
                        let error = RDFParserError.malformedRDFFormat(message: "The predicate at line:\(rdfParser.xmlParser?.lineNumber), column:\(rdfParser.xmlParser?.columnNumber) is not a valid URI.")
                        rdfParser.delegate?.parserErrorOccurred(rdfParser, error: error)
                        rdfParser.xmlParser?.abortParsing()
                    }
                }
            }
            
            currentObjects.append(object)
            
            if object != nil {
                self.createStatement()
            }
            
            currentSubjects.append(subject)
            currentPredicates.append(predicate)
            
            // empty property elements
            self.handleEmptyPropertyElement(subject, predicate: predicate)
            
            // property attributes
            self.handlePropertyAttributes(subject)
            
        }else { // XML Literal
            for prefixadded in namespacePrefixesAddedBeforeElement {
                // remove namespaces from graph that were added in the element containing the literal and are thus only valid for the XML literal
                graph!.deleteNamespace(prefixadded)
            }
            var qualifiedName = qName!
            var prefixDef = ""
            let nspf = qName?.qualifiedNamePrefix
            var definedPrefixesInElement : [String]?
            if nspf != nil {            // Add namespaces to XML literal when needed because used for the XML element
                let realprefix = prefixMapping[nspf!]
                if realprefix != nil {
                    if !prefixHasBeenDefinedInSuperElementOfXMLLiteral(realprefix!) {
                        prefixDef = prefixDef + " xmlns:\(realprefix!)=\"\(currentNamespaces[realprefix!]!)\""
                        if definedPrefixesInElement == nil {
                            definedPrefixesInElement = [String]()
                        }
                        definedPrefixesInElement!.append(realprefix!)
                    }
                    qualifiedName = "\(realprefix!):\(elementName)"
                }else{
                    let error = RDFParserError.malformedRDFFormat(message: "The XML literal element at line:\(rdfParser.xmlParser?.lineNumber), column:\(rdfParser.xmlParser?.columnNumber) uses a namespace prefix ('\(nspf!)') that has not (yet) been defined.")
                    rdfParser.delegate?.parserErrorOccurred(rdfParser, error: error)
                    rdfParser.xmlParser?.abortParsing()
                }
            }
            for attribute in attributeDict.keys {
                let anspf = attribute.qualifiedNamePrefix
                if anspf != nil {
                    let realprefix = prefixMapping[anspf!]
                    if realprefix != nil && !prefixHasBeenDefinedInSuperElementOfXMLLiteral(realprefix!) {
                        prefixDef = prefixDef + " xmlns:\(realprefix!)=\"\(currentNamespaces[realprefix!]!)\""
                        if definedPrefixesInElement == nil {
                            definedPrefixesInElement = [String]()
                        }
                        definedPrefixesInElement!.append(realprefix!)
                    }else{
                        let error = RDFParserError.malformedRDFFormat(message: "The XML property at line:\(rdfParser.xmlParser?.lineNumber), column:\(rdfParser.xmlParser?.columnNumber) uses a namespace prefix ('\(anspf!)') that has not (yet) been defined.")
                        rdfParser.delegate?.parserErrorOccurred(rdfParser, error: error)
                        rdfParser.xmlParser?.abortParsing()
                    }
                }
            }
            
            if XMLLiteralElementIsUnclosed {
                XMLLiteralString = XMLLiteralString! + "/>"
            }
            XMLLiteralString = XMLLiteralString! + textNodeString
            XMLLiteralString = XMLLiteralString! + "<\(qualifiedName)"
            for attrname in attributeDict.keys {
                let val = attributeDict[attrname]
                XMLLiteralString = XMLLiteralString! + " \(attrname)=\"\(val!)\""
            }
            XMLLiteralString = XMLLiteralString! + prefixDef
            XMLLiteralElementIsUnclosed = true
            prefixesDefinedInXMLLiteral.append(definedPrefixesInElement)
        }
        
        textNodeString = ""
        let parseType = attributeValue(attributeDict, nameURI: RDF.parseType)
        if parseType == "Literal" { // next child nodes are not RDF nodes but XML literal nodes.
            inXMLLiteral = true
            XMLLiteralString = ""
            print(" ** START XML Literal **")
            for prefixadded in namespacePrefixesAddedBeforeElement {
                // remove namespaces from graph that were added in the element containing the literal and are thus only valid for the XML literal
                graph!.deleteNamespace(prefixadded)
            }
        }
        namespacePrefixesAddedBeforeElement.removeAll()
    }
    
    internal func parser(parser: NSXMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        print("Finished on element \(elementName).")
        //print("elements: \(currentElements)")
        
        let attributeDict = currentElements.last!.attributes
        let parseType = attributeValue(attributeDict, nameURI: RDF.parseType)
        if parseType == "Literal" { // previous child nodes were not RDF nodes but XML literal nodes.
            inXMLLiteral = false
            print(" ** END XML Literal **")
            let subject = lastSubject
            let predicate = lastPredicate
            let literal = Literal(stringValue: XMLLiteralString!, dataType: RDF.XMLLiteral)
            if subject != nil && predicate != nil {
                self.createStatement(subject!, predicate: predicate!, object: literal!)
            }
            XMLLiteralString = nil
        }
        
        if !inXMLLiteral { // currently not in XML literal, elements are RDF elements
            
            let lastElements = self.lastElements()
            if lastElements.predicate && lastElements.literal {
                var litstring = currentElements.last!.text
                litstring = litstring.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
                let datatype = self.lastDatatype
                let language = self.lastLanguage
                var literal : Literal? = nil
                if language != nil && (datatype == nil || datatype! == XSD.string) {
                    literal = Literal(stringValue: litstring, language: language!)
                } else if datatype != nil {
                    literal = Literal(stringValue: litstring, dataType: datatype!)
                } else {
                    literal = Literal(stringValue: litstring)
                }
                let subject = lastSubject
                let predicate = lastPredicate
                if subject != nil && predicate != nil && literal != nil {
                    self.createStatement(subject!, predicate: predicate!, object: literal!)
                }
            }
            
            currentSubjects.removeLast()
            currentPredicates.removeLast()
            currentObjects.removeLast()
            currentDatatype.removeLast()
            currentLanguage.removeLast()
        } else { // currently in XML literal, elements are not RDF elements
            var qualifiedName = qName!
            let nspf = qName?.qualifiedNamePrefix
            if nspf != nil {
                let realprefix = prefixMapping[nspf!]
                if realprefix != nil {
                    qualifiedName = "\(realprefix!):\(elementName)"
                }
            }
            if XMLLiteralElementIsUnclosed {
                XMLLiteralString = XMLLiteralString! + "/>"
                XMLLiteralElementIsUnclosed = false
            }else{
                XMLLiteralString = XMLLiteralString! + textNodeString
                XMLLiteralString = XMLLiteralString! + "</\(qualifiedName)>"
                XMLLiteralElementIsUnclosed = false
            }
            prefixesDefinedInXMLLiteral.removeLast()
        }
        
        currentElements.removeLast()
        textNodeString = ""
    }
    
    internal func parser(parser: NSXMLParser, didStartMappingPrefix prefix: String, toURI namespaceURI: String) {
        let realprefix = graph!.addNamespace(prefix, namespaceURI: namespaceURI)
        if realprefix != nil {
            if rdfParser.delegate != nil {
                rdfParser.delegate!.namespaceAdded(rdfParser, graph: graph!, prefix: prefix, namespaceURI: namespaceURI)
            }
            prefixMapping[prefix] = realprefix!
            namespaceMapping[namespaceURI] = realprefix
            currentNamespaces[realprefix!] = namespaceURI
            namespacePrefixesAddedBeforeElement.append(realprefix!)
        }
    }
    
    internal func parser(parser: NSXMLParser, didEndMappingPrefix prefix: String) {
        print("Finished mapping prefix \(prefix).")
        let realprefix = prefixMapping[prefix]
        if realprefix != nil {
            let ns = currentNamespaces[realprefix!]
            prefixMapping.removeValueForKey(realprefix!)
            namespaceMapping.removeValueForKey(ns!)
            currentNamespaces.removeValueForKey(realprefix!)
        }
    }
    
    internal func parser(parser: NSXMLParser, foundCharacters string: String) {
        print("Found characters '\(string)'.")
        if currentElements.count > 0 {
            var lastelement = currentElements.last!
            lastelement.text = lastelement.text + string
            currentElements.removeLast()
            currentElements.append(lastelement)
        }
        textNodeString = textNodeString + string
        if XMLLiteralElementIsUnclosed {
            XMLLiteralString = XMLLiteralString! + ">"
        }
        XMLLiteralElementIsUnclosed = false
    }
    
    internal func parser(parser: NSXMLParser, foundIgnorableWhitespace whitespaceString: String){
        print("Found ignorable whitespace '\(whitespaceString)'.")
        textNodeString = textNodeString + whitespaceString
        if XMLLiteralElementIsUnclosed {
            XMLLiteralString = XMLLiteralString! + ">"
        }
        XMLLiteralElementIsUnclosed = false
    }
    
    internal func parser(parser: NSXMLParser, foundCDATA CDATABlock: NSData) {
        print("Found CDATA block '\(CDATABlock)'.")
    }
    
    /**
     Tests if a specific prefix has been defined in a super element of the current element in an XMLLiteral.
     
     - parameter prefix: The prefix to be tested.
     - returns: True when the prefix has been defined in the XML literal.
     */
    private func prefixHasBeenDefinedInSuperElementOfXMLLiteral(prefix : String) -> Bool {
        for prefixesdef in prefixesDefinedInXMLLiteral {
            if prefixesdef != nil {
                for prefixdef in prefixesdef! {
                    if prefix == prefixdef {
                        return true
                    }
                }
            }
        }
        return false
    }
    
    
    /**
     Tests if the current element contains property attributes and if so adds statements with the specified subject.
     
     - parameter subject: The subject of the statement if the element contains property attributes.
     */
    private func handlePropertyAttributes(subject: Resource?){
        if subject != nil {
            let attributeDict = currentElements.last!.attributes
            for attribute in attributeDict.keys {
                if !self.attributeIsRDFAttribute(attribute) {
                    let predicate = graph!.createURIFromQualifiedName(attribute)
                    if predicate != nil {
                        let stringValue = attributeDict[attribute]
                        var object : Literal? = nil
                        let datatype = self.lastDatatype
                        let language = self.lastLanguage
                        if language != nil {
                            object = Literal(stringValue: stringValue!, language: language!)
                        } else if datatype != nil {
                            object = Literal(stringValue: stringValue!, dataType: datatype!)
                        } else {
                            object = Literal(stringValue: stringValue!)
                        }
                        self.createStatement(subject!, predicate: predicate!, object: object!)
                    } else {
                        let error = RDFParserError.malformedRDFFormat(message: "The property attribute at line:\(rdfParser.xmlParser?.lineNumber), column:\(rdfParser.xmlParser?.columnNumber) is not a valid URI.")
                        rdfParser.delegate?.parserErrorOccurred(rdfParser, error: error)
                        rdfParser.xmlParser?.abortParsing()
                    }
                }
            }
        }
    }
    
    /**
     Tests if the current element is an empty property element and if so adds a statement with the specified subject and predicate.
     
     - parameter subject: The subject of the statement if the element is an empty property element.
     - parameter predicate: The predicate of the statement if the element is an empty property element.
     */
    private func handleEmptyPropertyElement(subject: Resource?, predicate: URI?){
        let attributeDict = currentElements.last!.attributes
        if predicate != nil && self.attributesContainsAttributeName(attributeDict, nameURI: RDF.resource) {
            let subject = lastSubject
            let predicate = lastPredicate
            let attrvalue = self.attributeValue(attributeDict, nameURI: RDF.resource)!
            let uriOrQName = self.URIStringOrName(attrvalue)
            let object = URI(string: uriOrQName)
            if object != nil {
                self.createStatement(subject!, predicate: predicate!, object: object!)
            } else {
                let error = RDFParserError.malformedRDFFormat(message: "The rdf:resource attribute at line:\(rdfParser.xmlParser?.lineNumber), column:\(rdfParser.xmlParser?.columnNumber) does not contain a valid URI.")
                rdfParser.delegate?.parserErrorOccurred(rdfParser, error: error)
                rdfParser.xmlParser?.abortParsing()
            }
        }
    }
    
    /**
     Returns a tuple containing four booleans each specifying whether the last element contains respectively a 
     subject, a predicate, an object, and a string literal (in a text node).
     
     - returns: The tuple containing four booleans.
     */
    private func lastElements() -> (subject : Bool, predicate : Bool, object : Bool, literal : Bool) {
        var lastNonNilIndex = currentSubjects.count-1
        while lastNonNilIndex >= 0 && currentSubjects[lastNonNilIndex] == nil &&
            currentPredicates[lastNonNilIndex] == nil && currentObjects[lastNonNilIndex] == nil {
                lastNonNilIndex--
        }
        if lastNonNilIndex < 0 {
            return (false,false,false,false)
        }
        var containsLiteral = false
        var litstring = currentElements[lastNonNilIndex].text
        litstring = litstring.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
        if litstring.lengthOfBytesUsingEncoding(NSUTF8StringEncoding) > 0 {
            containsLiteral = true
        }
        let lastElements : (Bool,Bool,Bool,Bool) = ((currentSubjects[lastNonNilIndex] != nil),(currentPredicates[lastNonNilIndex] != nil),(currentObjects[lastNonNilIndex] != nil),containsLiteral)
        return lastElements
    }
    
    /**
     Handles `rdf:Description` elements that are translated into a new resource.
     
     - parameters attributes: The XML attributes of a rdf:Description element.
     - returns: The resource defined by the rdf:Description element.
     */
    private func handleRDFDescriptionElement(attributes : [String : String]) -> Resource {
        var rdfabout = self.attributeValue(attributes, nameURI: RDF.about)
        let rdfnodeID = self.attributeValue(attributes, nameURI: RDF.nodeID)
        if rdfnodeID != nil && rdfabout != nil {
            let error = RDFParserError.malformedRDFFormat(message: "Only one of the rdf:about or rdf:nodeID attributes is allowed for a rdf:Description node (at line:\(rdfParser.xmlParser?.lineNumber), column:\(rdfParser.xmlParser?.columnNumber)).")
            rdfParser.delegate!.parserErrorOccurred(rdfParser, error: error)
            rdfParser.xmlParser?.abortParsing()
        }
        
        var resource : Resource?
        if rdfabout != nil {        // node with URI
            rdfabout = self.URIStringOrName(rdfabout!)
            resource = URI(string: rdfabout!)
            if resource == nil {         // node is not a valid URI -> error
                let error = RDFParserError.malformedRDFFormat(message: "The rdf:about attribute at line:\(rdfParser.xmlParser?.lineNumber), column:\(rdfParser.xmlParser?.columnNumber) does not contain a valid URI.")
                rdfParser.delegate!.parserErrorOccurred(rdfParser, error: error)
                rdfParser.xmlParser?.abortParsing()
            }
        } else if rdfnodeID != nil { // blank node with specified identifier
            resource = BlankNode(identifier: rdfnodeID!)
        } else { // blank node without identifier
            resource = BlankNode()
        }
        
        return resource!;
    }
    
    /**
     Creates a new statement from the last subject, predicate and object parsed from the XML tree.
     */
    private func createStatement() {
        let subject = lastSubject
        let predicate = lastPredicate
        let object = lastObject
        if subject != nil && predicate != nil && object != nil {
            self.createStatement(subject!, predicate: predicate!, object: object!)
        }else{
            if rdfParser.delegate != nil {
                var error : RDFParserError? = nil
                if subject != nil {
                    error = RDFParserError.malformedRDFFormat(message: "Could not create a statement as no subject could be parsed (at line:\(rdfParser.xmlParser?.lineNumber), column:\(rdfParser.xmlParser?.columnNumber)).")
                }else if predicate != nil {
                    error = RDFParserError.malformedRDFFormat(message: "Could not create a statement as no predicate could be parsed (at line:\(rdfParser.xmlParser?.lineNumber), column:\(rdfParser.xmlParser?.columnNumber)).")
                } else if object != nil {
                    error = RDFParserError.malformedRDFFormat(message: "Could not create a statement as no object could be parsed (at line:\(rdfParser.xmlParser?.lineNumber), column:\(rdfParser.xmlParser?.columnNumber)).")
                }
                rdfParser.delegate!.parserErrorOccurred(rdfParser, error: error!)
                rdfParser.xmlParser?.abortParsing()
            }
        }
    }
    
    /**
     Creates a new statement with the specified subject, predicate, and object in the graph.
     
     - parameter subject: The subject of the statement.
     - parameter predicate: The predicate of the statement.
     - parameter object: The object of the statement.
     */
    private func createStatement(subject: Resource, predicate : URI, object : Value){
        let statement = Statement(subject: subject, predicate: predicate, object: object)
        graph!.add(statement)
        if rdfParser.delegate != nil {
            rdfParser.delegate!.statementAdded(rdfParser, graph: graph!, statement: statement)
        }
    }
    
    /**
     Tests if the specfied name is a qualified name and if so returns the full URI for the qualified name.
     If the possible qualified name cannot be translated to a URI, this method returns the specifid name.
     
     - parameter possibleQName: The name that may be translated to a URI.
     - returns: The translated URI string or the specified name itself.
     */
    private func URIStringOrName(possibleQName : String) -> String {
        let uri = graph!.createURIFromQualifiedName(possibleQName)
        if uri != nil {
            return uri!.stringValue
        }
        return possibleQName
    }
    
    /**
     Tests if the specified attribute dictionary contains an attribute whose to a URI expanded name is a
     key in the dictionary. The keys in the dictionary (the attribute names) are translated to URIs if
     possible and then compared to the specified URI.
     
     - parameter attributes: The attribute dictionary.
     - nameURI: The URI of the attribute name.
     - returns: True if the attribute dictionary contains the URI as a name.
     */
    private func attributesContainsAttributeName(attributes : [String : String], nameURI : URI) -> Bool {
        let uristr = nameURI.stringValue
        for attributeName in attributes.keys {
            if uristr == URIStringOrName(attributeName) {
                return true
            }
        }
        return false
    }
    
    /**
     Returns the value of the specified attribute (using the URI of the name) in the specified attribute dictionary.
     The keys in the dictionary (the attribute names) are translated to URIs if
     possible and then compared to the specified URI.
     
     - parameter attributes: The attribute dictionary.
     - nameURI: The URI of the attribute name.
     - returns: The attribute value.
     */
    private func attributeValue(attributes : [String : String], nameURI : URI) -> String? {
        let uristr = nameURI.stringValue
        for attributeName in attributes.keys {
            if uristr == URIStringOrName(attributeName) {
                return attributes[attributeName]
            }
        }
        return nil
    }
    
    /**
     Tests whether the element with the specified qualified name or URI is an RDF Syntax element, e.g. rdf:Description.
     
     - parameter elementQNameOrURI: The qualified name of the element or the string value of an element URI.
     - returns: True when the element with the specified name is an RDF syntax element.
     */
    private func elementIsRDFElement(var elementQNameOrURI : String) -> Bool {
        elementQNameOrURI = URIStringOrName(elementQNameOrURI)
        for rdfElement in XMLtoRDFParser.rdfElements {
            if rdfElement == elementQNameOrURI {
                return true
            }
        }
        return false
    }
    
    /**
     Tests whether the attribute with the specified qualified name or URI is an RDF Syntax attribute, e.g. rdf:about.
     
     - parameter attributeQNameOrURI: The qualified name of the attribute or the string value of an attribute URI.
     - returns: True when the attribute with the specified name is an RDF syntax attribute.
     */
    private func attributeIsRDFAttribute(var attributeQNameOrURI : String) -> Bool {
        attributeQNameOrURI = URIStringOrName(attributeQNameOrURI)
        for rdfAttribute in XMLtoRDFParser.rdfAttributes {
            if rdfAttribute == attributeQNameOrURI {
                return true
            }
        }
        return false
    }
    
}