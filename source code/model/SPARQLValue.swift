//
//  SPARQLValue.swift
//  
//
//  Created by Don Willems on 25/11/15.
//
//

import Foundation

/**
 This proptocal defines a computed property that creates the SPARQL representation of a `Value`,
 `Statement` or other entities that can be used in a SPARQL query.
 */
public protocol SPARQLValue {
    
    /**
     The representation of a value (or variable) as used in a SPARQL query. For instance, in SPARQL a URI needs 
     to be enclosed in angle brackets, e.g. `<http://example.org/Person>`.
     */
    var sparql : String{get}
}