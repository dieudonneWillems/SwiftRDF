//
//  RDFFormatterOptions.swift
//  
//
//  Created by Don Willems on 23/02/16.
//
//

import Foundation

/**
 `RDFFormatterSortingOption` is used to specify the order in which statements are ordered in the output of 
 a formatter.
 */
public enum RDFFormatterSortingOption {
    
    /**
     Statements are ordered alphabetically on their subject.
     */
    case sortAlphabeticallyOnSubject
    
    /**
     Statements are ordered alphabetically on the type of the instance 
     specified by the subject, when available, or on their subject when the
     type is not available.
     */
    case sortAlphabeticallyOnType
    
    /**
     Statements are ordered alphabetically on their predicate.
     */
    case sortAlphabeticallyOnPredicate
}