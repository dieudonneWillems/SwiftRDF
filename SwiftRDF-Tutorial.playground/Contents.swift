//: Playground - noun: a place where people can play

import Cocoa
import SwiftRDFOSX

var str = "Hello, playground"
var literal = Literal(stringValue: str, language: "en")

do{
    var uri = try URI(string: "http://example.org/resources/greeting")
    var statement = Statement(subject: uri, predicate: RDFS.label, object: literal!)
}catch {
    
}
