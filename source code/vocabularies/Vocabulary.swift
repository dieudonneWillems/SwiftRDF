//
//  Vocabulary.swift
//  
//
//  Created by Don Willems on 26/11/15.
//
//

import Foundation

public class Vocabulary {
    
    internal static func createURI(namespace: String, localName: String) -> URI {
        var uri : URI? = nil
        do {
            uri = try URI(namespace: namespace, localName: localName)
        } catch {
            uri = nil
        }
        return uri!
    }
}