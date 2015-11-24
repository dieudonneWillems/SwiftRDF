//
//  URI.swift
//  
//
//  Created by Don Willems on 20/11/15.
//
//

import Foundation

public class URI : Resource {
    
    public private(set) var scheme : String
    
    public private(set) var authorityPart : String?
    
    public private(set) var hierarchicalPart : String?
    
    public private(set) var userName : String?
    
    public private(set) var password : String?
    
    public private(set) var host : String?
    
    public private(set) var port : Int?
    
    public private(set) var path : String?
    
    public private(set) var query : String?
    
    public private(set) var fragment : String?
    
    public init(string : String) throws {
        scheme = ""
        super.init(stringValue: string)
        try parseURI(string)
    }
    
    private func parseURI(uri : String) throws {
        let pattern = "^(([^:/?#]+):)?(//([^/?#]*))?([^?#]*)(\\?([^#]*))?(#(.*))?"
        do {
            let regex = try NSRegularExpression(pattern: pattern, options: [.CaseInsensitive])
            let matches = regex.matchesInString(uri, options: [], range: NSMakeRange(0, uri.characters.count)) as Array<NSTextCheckingResult>
            if matches.count <= 0 {
                throw MalformedURIError.MalformedURI(message: "The URI '\(uri) is malformed.", uri: uri)
            }
            let nsstring = uri as NSString
            for match in matches as [NSTextCheckingResult] {
                
                for index in 1...match.numberOfRanges-1 {
                    let range = match.rangeAtIndex(index)
                    if range.location != NSNotFound {
                        let substring = nsstring.substringWithRange(match.rangeAtIndex(index))
                        print("\(index): \(substring)")
                    }
                }
                
                if match.rangeAtIndex(2).location != NSNotFound {
                    scheme = nsstring.substringWithRange(match.rangeAtIndex(2)) as String
                } else {
                    throw MalformedURIError.URISchemeMissing(message: "The URI '\(uri) does not contain a scheme.", uri: uri)
                }
                if match.rangeAtIndex(4).location != NSNotFound {
                    authorityPart = nsstring.substringWithRange(match.rangeAtIndex(4)) as String
                }
                if match.rangeAtIndex(5).location != NSNotFound {
                    path = nsstring.substringWithRange(match.rangeAtIndex(5)) as String
                }
                if match.rangeAtIndex(7).location != NSNotFound {
                    query = nsstring.substringWithRange(match.rangeAtIndex(7)) as String
                }
                if match.rangeAtIndex(9).location != NSNotFound {
                    fragment = nsstring.substringWithRange(match.rangeAtIndex(9)) as String
                }
                if authorityPart != nil && path != nil {
                    hierarchicalPart = "\(authorityPart!)\(path!)"
                } else if authorityPart != nil {
                    hierarchicalPart = authorityPart!
                } else if path != nil {
                    hierarchicalPart = path!
                }
            }
        } catch {
            throw MalformedURIError.MalformedURI(message: "The URI '\(uri) is malformed.", uri: uri)
        }
    }
}