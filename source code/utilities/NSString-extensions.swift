//
//  NSString-extensions.swift
//  
//
//  Created by Don Willems on 16/12/15.
//
//

import Foundation

/**
 These extensions to the String class provide transformations from data in base64 or hexadecimal
 strings into `NSData` objects.
 */
extension String {
    
    /**
     Creates a `NSData` instance from a hexadecimal string representation
     It takes a hexadecimal representation and creates an NSData object.
     Note, if the string has any spaces, those are removed. 
     Also if the string started with a '<' or ended with a '>', those are removed, too. 
     This does no validation of the string to ensure it's a valid hexadecimal string.
     
     Based on this [item on Stackoverflow](http://stackoverflow.com/questions/26501276/converting-hex-string-to-nsdata-in-swift).
    
     - returns: The NSData that is represented by this string or nil if the string contains characters
     outside the 0-9 and a-f range.
     */
    func dataFromHexadecimalString() -> NSData? {
        let trimmedString = self.stringByTrimmingCharactersInSet(NSCharacterSet(charactersInString: "<> ")).stringByReplacingOccurrencesOfString(" ", withString: "")
        
        // make sure the cleaned up string consists solely of hex digits, and that we have even number of them
        
        let regex = try! NSRegularExpression(pattern: "^[0-9a-f]*$", options: .CaseInsensitive)
        
        let found = regex.firstMatchInString(trimmedString, options: [], range: NSMakeRange(0, trimmedString.characters.count))
        if found == nil || found?.range.location == NSNotFound || trimmedString.characters.count % 2 != 0 {
            return nil
        }
        
        // everything ok, so now let's build NSData
        
        let data = NSMutableData(capacity: trimmedString.characters.count / 2)
        
        for var index = trimmedString.startIndex; index < trimmedString.endIndex; index = index.successor().successor() {
            let byteString = trimmedString.substringWithRange(Range<String.Index>(start: index, end: index.successor().successor()))
            let num = UInt8(byteString.withCString { strtoul($0, nil, 16) })
            data?.appendBytes([num] as [UInt8], length: 1)
        }
        
        return data
    }
    
    /**
     Creates a `NSData` instance from a base-64 binary string representation
     It takes a base-64 binary representation and creates an NSData object. 
     It ignores unknown non-Base-64 bytes, including line ending characters.
     
     Based on this [gist](https://gist.github.com/ericdke/1eaed835eef167b9f12c).
     
     - returns: The NSData that is represented by this string or nil if the string does not represent 
     base-64 formatted data.
     */
    func dataFromBase64BinaryString() -> NSData? {
        let decodedData = NSData(base64EncodedString: self, options: NSDataBase64DecodingOptions(rawValue: 0))
        return decodedData
    }
}