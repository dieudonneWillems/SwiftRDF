//
//  Literal.swift
//  
//
//  Created by Don Willems on 20/11/15.
//
//

import Foundation

public class Literal: Value {
    
    // MARK: Properties
    
    public private(set) var dataType : URI?
    
    public private(set) var language : String?
    
    public private(set) var booleanValue : Bool?
    
    public private(set) var calendarValue : NSCalendar?
    
    public private(set) var dateValue : NSDate?
    
    public private(set) var doubleValue : Double?
    
    public private(set) var integerValue : Int?
    
    // MARK: SPARQL properties
    
    /**
    The representation of this Literal as used in a SPARQL query. The format depends on the datatype
    of the literal.
    */
    public override var sparql : String {
        get{
            return "\"\(self.stringValue)\""
        }
    }
    
    public override init(stringValue: String){
        super.init(stringValue: stringValue)
    }
    
    // MARK: Initialisers
    
    public init(stringValue: String, language: String){
        super.init(stringValue: stringValue)
        self.language = language
        // TODO: Set datatype to string
    }
    
    public init(stringValue: String, dataType: URI){
        super.init(stringValue: stringValue)
        self.dataType = dataType
        // TODO: Test datatypes and set the correct property, e.g. the booleanValue for the boolean datatype.
    }
}