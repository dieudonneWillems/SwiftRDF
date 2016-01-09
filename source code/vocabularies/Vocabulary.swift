//
//  Vocabulary.swift
//  
//
//  Created by Don Willems on 26/11/15.
//
//

import Foundation


/**
 This class defines a vocabulary, i.e. a set of URS's representing concepts in a vocabulary.
 Subclasses of this class contain sets of static variables.
 */
public class Vocabulary {
    
    /**
     Returns the namespace of the vocabulary.
     
     - returns: The namespace of the vocabulary.
     */
    public class func namespace() -> String {
        return ""
    }
    
    /**
     Returns the suggested prefix to be used for the vocabulary.
     
     - returns: The prefix for the vocabulary.
     */
    public class func prefix() -> String {
        return "ns"
    }
    
    /**
     Creates a new URI to be included in the vocabulary. This method is a convenience method
     to create URIs without the need to catch URI initialisation errors. It is imperative that
     the URIs created are valid URIs, otherwise a runtime error will occur.
     
     - parameter namespace: The namespace of the vocabulary.
     - parameter localName: The local name of the concept.
     - returns: The URI that was created.
     */
    public static func createURI(namespace: String, localName: String) -> URI {
        let uri = URI(namespace: namespace, localName: localName)
        return uri!
    }
}