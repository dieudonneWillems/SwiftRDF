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
    
    private var currentSubject = [Resource?]()
    
    private var lastNonNillSubject : Resource? {
        for var index = currentSubject.count - 1; index >= 0 ; index-- {
            let value = currentSubject[index]
            if value != nil {
                return value
            }
        }
        return nil
    }
    
    private var currentProperty = [URI?]()
    
    private var lastNonNillProperty : URI? {
        for var index = currentProperty.count - 1; index >= 0 ; index-- {
            let value = currentProperty[index]
            if value != nil {
                return value
            }
        }
        return nil
    }
    
    private var currentText : String = ""
    private var currentObject : Value?
    
    private var currentDatatype = [Datatype?]()
    
    private var lastNonNillDatatype : Datatype? {
        for var index = currentDatatype.count - 1; index >= 0 ; index-- {
            let value = currentDatatype[index]
            if value != nil {
                return value
            }
        }
        return nil
    }
    
    private var currentLanguage = [String?]()
    
    private var lastNonNillLanguage : String? {
        for var index = currentLanguage.count - 1; index >= 0 ; index-- {
            let value = currentLanguage[index]
            if value != nil {
                return value
            }
        }
        return nil
    }
    
    private var currentNamespaces = [String : String]()
    private var namespaceMapping = [String : String]()
    
    private var currentGraph : Graph?
    
    private var intendedGraphName : Resource?
    
    /**
     Initialises a parser with the contents of the RDF file reference by the given
     URL.
     
     - parameter url: The URL of the RDF file to be parsed.
     - returns: An initialised RDF parser.
     */
    public required init(url : NSURL) {
        xmlParser = NSXMLParser(contentsOfURL: url)
        intendedGraphName = URI(string: url.absoluteString)
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
     - parameter graphName: The name of the named graph, can be nil.
     - returns: An initialised RDF parser.
     */
    public required init(data : NSData, graphName : Resource?) {
        intendedGraphName = graphName
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
        if intendedGraphName == nil {
            currentGraph = Graph()
        } else {
            currentGraph = Graph(name: intendedGraphName!)
        }
        currentDatatype.removeAll()
        currentLanguage.removeAll()
        currentProperty.removeAll()
        currentText = ""
        currentObject = nil
        currentNamespaces.removeAll()
        currentSubject.removeAll()
        namespaceMapping.removeAll()
        if xmlParser != nil {
            success = xmlParser!.parse()
        }
        if !success {
            if delegate != nil {
                delegate!.parserErrorOccurred(self, error: RDFParserError.couldNotCreateRDFParser(message: "Could not create the XML parser to parse the RDF/XML file."))
            }
        }
        print("** FINISHED PARSING RDF/XML **")
        return currentGraph
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
        
        var subject : Resource? = nil
        var property : URI? = nil
        var datatype : Datatype? = nil
        var language : String? = nil
        
        // Text content starts with empty string
        currentText = ""
        
        var elementURIstring = elementName
        if namespaceURI != nil {
            elementURIstring = namespaceURI! + elementURIstring
        }
        var attributes = [String : String]()
        for attrname in attributeDict.keys {
            if attrname.isQualifiedName {
                let uri = currentGraph!.createURIFromQualifiedName(attrname)
                if uri != nil {
                    attributes[uri!.stringValue] = attributeDict[attrname]
                }else {
                    attributes[attrname] = attributeDict[attrname]
                }
            } else {
                attributes[attrname] = attributeDict[attrname]
            }
        }
        
        print("\tElement URI: \(elementURIstring) with attributes: \(attributes).")
        
        let expectedItem = self.expectedItem()
        
        // Test for rdf:Description element which starts a new triple
        if elementURIstring == RDF.Description.stringValue {
            let about = attributes[RDF.about.stringValue]
            if about != nil {
                let aboutURI = URI(string: about!)
                if aboutURI != nil {
                    subject = aboutURI
                    print("\t\tsubject URI: \(aboutURI)")
                }
            }
        }
        
        // If the expected item is a predicate (expectedItem = 1) use the element as predicate
        if expectedItem == 1 {
            let predicateURI = URI(string: elementURIstring)
            if predicateURI != nil {
                property = predicateURI
            }
        }
        
        
        if attributes[RDF.datatype.stringValue] != nil {
            let dtstr = attributes[RDF.datatype.stringValue]!
            var uri : URI? = nil
            if dtstr.isQualifiedName {
                uri = currentGraph!.createURIFromQualifiedName(dtstr)
            }else {
                uri = URI(string: dtstr)
            }
            if uri != nil {
                datatype = Datatype(uri: uri!.stringValue, derivedFromDatatype: nil, isListDataType: false)
            }
        }
        
        if attributes["xml:lang"] != nil {
            language = attributes["xml:lang"]!
        }
        
        if (expectedItem == 0 && subject == nil) {
            let errormessage = "The RDF/XML parser expected a definition for the subject of a triple at line: \(parser.lineNumber), column: \(parser.columnNumber)."
            print("ERROR: \(errormessage)")
            delegate?.parserErrorOccurred(self, error: RDFParserError.malformedRDFFormat(message: errormessage))
            parser.abortParsing()
        }else if (expectedItem == 1 && property == nil) {
            let errormessage = "The RDF/XML parser expected a definition for the predicate of a triple at line: \(parser.lineNumber), column: \(parser.columnNumber)."
            print("ERROR: \(errormessage)")
            delegate?.parserErrorOccurred(self, error: RDFParserError.malformedRDFFormat(message: errormessage))
                parser.abortParsing()
        }
        
        currentSubject.append(subject)
        currentProperty.append(property)
        currentDatatype.append(datatype)
        currentLanguage.append(language)
        
        print("current Subjects: \(currentSubject)")
        print("current Properties: \(currentProperty)")
        print("current Datatypes: \(currentDatatype)")
        print("current Languages: \(currentLanguage)")
    }
    
    /**
     Returns 0 when the parser expects a subject, 1 when the parser expects a predicate, and 2 when the parser expects an object.
     When no subject, predicate, or object is expected, return -1.
     
     - returns: The expected item code.
     */
    private func expectedItem() -> Int {
        
        if currentSubject.count == 0 {
            return -1
        }
        
        let lastsubject = currentSubject.last!
        let lastproperty = currentProperty.last!
        
        if lastsubject == nil && lastproperty == nil {
            return 0 // expects subject
        }
        
        if lastsubject != nil && lastproperty == nil {
            return 1 // expects predicate
        }
        
        if lastproperty != nil && lastsubject == nil {
            return 2 // expects object
        }
        
        return -1
    }
    
    public func parser(parser: NSXMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        print("Finished on element \(elementName).")
        
        let trimmed = currentText.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
        
        // Test if an object is expected, if so we create a literal object value using the text content of the XML node
        let expectedItem = self.expectedItem()
        if expectedItem == 2 {
            let language = lastNonNillLanguage
            let datatype = lastNonNillDatatype
            
            if datatype != nil {
                currentObject = Literal(stringValue: trimmed, dataType: datatype!)
                createStatement()
            }else if language != nil {
                currentObject = Literal(stringValue: trimmed, language: language!)
                createStatement()
            }else {
                if trimmed.lengthOfBytesUsingEncoding(NSUTF8StringEncoding) > 0 {
                    currentObject = Literal(stringValue: trimmed)
                    createStatement()
                }
            }
        }
        currentSubject.removeLast()
        currentProperty.removeLast()
        currentDatatype.removeLast()
        currentLanguage.removeLast()
    }
    
    public func parser(parser: NSXMLParser, didStartMappingPrefix prefix: String, toURI namespaceURI: String) {
        let realprefix = currentGraph!.addNamespace(prefix, namespaceURI: namespaceURI)
        if realprefix != nil {
            namespaceMapping[prefix] = realprefix!
            currentNamespaces[realprefix!] = namespaceURI
        }
    }
    
    public func parser(parser: NSXMLParser, didEndMappingPrefix prefix: String) {
        print("Finished mapping prefix \(prefix).")
        let realprefix = namespaceMapping[prefix]
        if realprefix != nil {
            namespaceMapping.removeValueForKey(realprefix!)
            currentNamespaces.removeValueForKey(realprefix!)
        }
    }
    
    public func parser(parser: NSXMLParser, foundCharacters string: String) {
        print("Found characters '\(string)'.")
        
        currentText =  currentText + string
    }
    
    public func parser(parser: NSXMLParser, foundIgnorableWhitespace whitespaceString: String){
        print("Found ignorable whitespace '\(whitespaceString)'.")
    }
    
    public func parser(parser: NSXMLParser, foundCDATA CDATABlock: NSData) {
        print("Found CDATA block '\(CDATABlock)'.")
    }
    
    private func createStatement() {
        let subject = lastNonNillSubject
        let predicate = lastNonNillProperty
        let object = currentObject
        
        if subject == nil {
            let errormessage = "The RDF/XML parser could not create triple [\(subject) \(predicate) \(object)] because the subject was nil. - line: \(xmlParser!.lineNumber), column: \(xmlParser!.columnNumber)."
            print("ERROR: \(errormessage)")
            delegate?.parserErrorOccurred(self, error: RDFParserError.malformedRDFFormat(message: errormessage))
            xmlParser!.abortParsing()
            return
        }
        if predicate == nil {
            let errormessage = "The RDF/XML parser could not create triple [\(subject) \(predicate) \(object)] because the predicate was nil. - line: \(xmlParser!.lineNumber), column: \(xmlParser!.columnNumber)."
            print("ERROR: \(errormessage)")
            delegate?.parserErrorOccurred(self, error: RDFParserError.malformedRDFFormat(message: errormessage))
            xmlParser!.abortParsing()
            return
        }
        if object == nil {
            let errormessage = "The RDF/XML parser could not create triple [\(subject) \(predicate) \(object)] because the object was nil. - line: \(xmlParser!.lineNumber), column: \(xmlParser!.columnNumber)."
            print("ERROR: \(errormessage)")
            delegate?.parserErrorOccurred(self, error: RDFParserError.malformedRDFFormat(message: errormessage))
            xmlParser!.abortParsing()
            return
        }
        
        let statement = Statement(subject: subject!, predicate: predicate!, object: object!)
        currentGraph!.add(statement)
    }
}