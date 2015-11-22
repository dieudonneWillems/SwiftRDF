//
//  Statement.swift
//  
//
//  Created by Don Willems on 20/11/15.
//
//

import Cocoa

public class Statement : NSObject {

    let subject: Resource
    let predicate: URI
    let object: Value
    var context: [Resource] = []
    
    override public var description: String {
        var contextstr = ""
        if context.count > 0 {
            contextstr  = "context: \(context)"
        }
        return "\(subject) - \(predicate) - \(object) \(contextstr)"
    }
    
    public init(subject: Resource, predicate: URI, object: Value){
        self.subject = subject
        self.predicate = predicate
        self.object = object
    }
    
    public init(subject: Resource, predicate: URI, object: Value, context: Resource...){
        self.subject = subject
        self.predicate = predicate
        self.object = object
        self.context.appendContentsOf(context)
    }
}


func == (left: Statement, right: Statement) -> Bool {
    if left.subject != right.subject {
        return false
    }
    if left.predicate != right.predicate {
        return false
    }
    if left.object != right.object {
        return false
    }
    return true
}

func != (left: Statement, right: Statement) -> Bool {
    return !(left == right)
}