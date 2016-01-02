//
//  NSData-extensions.swift
//  
//
//  Created by Don Willems on 16/12/15.
//
//

import Foundation


/**
 These extensions to the NSData class provide transformations from data into base64 or hexadecimal
 string representations.
 */
extension NSData {
    
    /**
     Creates a hexadecimal string representation of the `NSData` object.
    
     Based on this [item on Stackoverflow](http://stackoverflow.com/questions/26501276/converting-hex-string-to-nsdata-in-swift).
    
     - returns: The string representation of this `NSData` object.
     */
    func hexadecimalString() -> String {
        var string = ""
        var byte: UInt8 = 0
        
        for i in 0 ..< length {
            getBytes(&byte, range: NSMakeRange(i, 1))
            string += String(format: "%02x", byte)
        }
        
        return string
    }
    
    /**
     Creates a base-64 binary string representation from this `NSData` instance.
     It ignores unknown non-Base-64 bytes, including line ending characters.
     
     Based on this [gist](https://gist.github.com/ericdke/1eaed835eef167b9f12c).
     
     - returns: The NSData that is represented by this string or nil if the string does not represent
     base-64 formatted data.
     */
    func base64String() -> String {
        let datastr = self.base64EncodedStringWithOptions(NSDataBase64EncodingOptions(rawValue: 0))
        return datastr
    }
}