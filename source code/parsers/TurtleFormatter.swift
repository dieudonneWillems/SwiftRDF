//
//  TurtleFormatter.swift
//  
//
//  Created by Don Willems on 23/02/16.
//
//

import Foundation

public class TurtleFormatter : NSObject, RDFFormatter {
    
    /**
     Defines the way in which statements are ordered by the formatter in its output.
     */
    public var sortingOption : RDFFormatterSortingOption
    
    
    // MARK: Initialisers
    
    /**
    Initialises a new formatter with the default sorting order.
    */
    public override required init() {
        sortingOption = RDFFormatterSortingOption.sortAlphabeticallyOnSubject
    }
    
    /**
     Initialises a new formatter with the specified sorting option.
     
     - parameter sorting: The sorting order of the output created by the formatter.
     */
    public required convenience init(sorting: RDFFormatterSortingOption) {
        self.init()
        sortingOption = sorting
    }
    
    
    
    // MARK: Write functions
    
    /**
    Writes the contents of the specified `Graph` to the specified URL.
    If the file cannot be written to the specified URL, an error is thrown.
    
    - parameter graph: The graph whose contents should be written to the URL.
    - parameter toURL : The URL of the file where the contents of the `Graph` should
    be written to.
    - returns: True when the RDF data was succesfully writen to the URL.
    */
    public func write(graph : Graph, toURL : NSURL) -> Bool {
        let rdfdata = data(graph)
        return rdfdata.writeToURL(toURL, atomically: true)
    }
    
    
    // MARK: Format functions
    
    /**
    Formats the contents of the specified `Graph` and writes it to a data object.
    - parameter graph: The graph whose contents should be written into the data object.
    - returns: The data object.
    */
    public func data(graph : Graph) -> NSData {
        let contents = string(graph)
        let data = contents.dataUsingEncoding(NSUTF8StringEncoding)
        if data == nil {
            print("COULD NOT ENCODE Turtle STRING TO UTF-8!")
        }
        return data!
    }
    
    /**
     Formats the contents of the specified `Graph` and writes it to a string object.
     - parameter graph: The graph whose contents should be written into the string object.
     - returns: The string object.
     */
    public func string(graph : Graph) -> String {
        var contents : String = ""
        let baseURI = graph.baseURI
        if baseURI != nil {
            contents = "@base <\(baseURI!)> .\n"
        }
        let namespaces = graph.namespaces
        for prefix in namespaces.keys {
            let uristr = namespaces[prefix]!
            contents = contents + "@prefix \(prefix):<\(uristr)> .\n"
        }
        contents = contents + "\n"
        
        let sps = statementsBySubjectPredicate(graph)
        for subject in sps.keys {
            contents = contents + "\(subject) "
            let par = sps[subject]
            var i = 0
            for predicate in par!.keys {
                if i > 0 {
                    contents = contents + ";\n\t\t"
                }
                contents = contents + "\(predicate) "
                let oar = par![predicate]
                var j=0
                for object in oar! {
                    contents = contents + "\(object)"
                    j++
                    if j < oar!.count {
                        contents = contents + ", "
                    }
                }
                i++
            }
            contents = contents + ".\n"
        }
        
        return contents
    }
    
    private func statementsBySubjectPredicate(graph : Graph) -> [String : [String : [String]]] {
        let statements = graph.statements
        var sps = [String : [String : [String]]]()
        for statement in statements {
            let subjectStr = qualifiedNameOrStringValue(statement.subject, graph: graph)
            let predicateStr = qualifiedNameOrStringValue(statement.predicate, graph: graph)
            let objectStr = qualifiedNameOrStringValue(statement.object, graph: graph)
            var par = sps[subjectStr]
            if par == nil {
                par = [String : [String]]()
            }
            var oar = par![predicateStr]
            if oar == nil {
                oar = [String]()
            }
            oar!.append(objectStr)
            
            par![predicateStr] = oar
            sps[subjectStr] = par
        }
        return sps
    }
    
    
    private func qualifiedNameOrStringValue(value : Value, graph : Graph) -> String {
        var strvalue = value.sparql
        if let uri = value as? URI {
            let qname = graph.qualifiedName(uri)
            if qname != nil {
                strvalue = qname!
            }
        }
        return strvalue
    }
}