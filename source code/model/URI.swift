//
//  URI.swift
//  
//
//  Created by Don Willems on 20/11/15.
//
//

import Foundation

/**
 A Uniform Resource Indentifier (_URI_) is a string of characters used to identify a resource. This identifier can be used to identify
 (unambiguosly) a resource on a network such as the world wide web. In RDF, URIs are used to identify resources and link resources to
 data and to other resources. In RDF triples predicates are required to be URIs, while the subject and the object in the RDF triple are
 also often URIs, but are not required to be.
 
 
 ### URI Components
 A URI may consist of the following components:
 
 - **Scheme**: defines the syntax of the URI and the associated protocol.
 - **Two slashes**: are required by some schemes, if no authority component is included in the URI, double slashes are not allowed.
 - **Authority part**: (optional) consisting of:
  - **Authentication section**: (optional) containing a username and optionally a password separated by a colon (:). The authentication
                                section is followed by an '@' character.
  - **Host**: either a registered name (e.g. a host name) or an IP address.
  - **Port**: (optional) a port number.
 - **Path**: (optional) a pointer to the data (e.g. on a host). The path is usually (but not necessarily) in a hierarchical form where the
             path components are separated by slashes. If an authority part is present, the path has to start with a forward slash. The path may never
             start with a double forward slash.
 - **Query**: (optional) query parameters (often name-value pairs separated with an &). The query is separated from the previous part of the
              URI with a question mark (?).
 - **Fragment**: (optional) a pointer to a secondary resource such as a section in the document. The fragment is separated from the previous
                 part of the URI with a hash symbol (#).
 
 ### Initialisation
 A URI instance is not mutable, all information pertaining to the URI needs to be provided during construction. When a URI is constructed, 
 the URI is checked for consistency. If the URI is found to be not consistent (i.e. malformed) an `MalformedURIError` is thrown during
 initialisation.
 */
public class URI : Resource {
    
    // MARK: Properties
    
    /**
     The scheme of a URI defines the syntax of the URI and the associated protocol.
     Examples of popular schemes include _http_, _ftp_, _mailto_, _file_, and _data_.
     */
    public private(set) var scheme : String
    
    /**
     The authority part of the URI consists of an optional authentication, the host and an optional port number.
    */
    public private(set) var authorityPart : String?
    
    /**
     The hierarchical part of the URI consists of the authority part and the path of the URI.
    */
    public private(set) var hierarchicalPart : String?
    
    /**
     The username (optional) encoded within the URI.
    */
    public private(set) var userName : String?
    
    /**
     The password (optional) encoded within the URI.
     */
    public private(set) var password : String?
    
    /**
     The host is either a registered name (such as a hostname) or an IP address. IPv4 addresses use the dot decimal 
     notation, IPv6 addresses are enclosed in brackets.
    */
    public private(set) var host : String?
    
    /**
     The port number.
    */
    public private(set) var port : Int?
    
    /**
     The path contains the data, usually organised in hierarchical form with a forward slash as separator.
    */
    public private(set) var path : String?
    
    /**
     The query string containing non-hierarchical data, usually in the form of key-value pairs.
    */
    public private(set) var query : String?
    
    /**
     The fragment, i.e. a pointer to a secondary resource such as a section in the document.
    */
    public private(set) var fragment : String?
    
    // MARK: SPARQL properties
    
    /**
    The representation of this URI as used in a SPARQL query. The URI is enclosed within angle brackets.
    For instance: `<http://example.org/Person>`.
    */
    public override var sparql : String {
        get{
            return "<\(self.stringValue)>"
        }
    }
    
    // MARK: Initialisers
    
    /**
     Initialises the URI from the specified string representing the URI.
    
     - parameter string: The string representing the URI.
    
     - throws MalformedURIError.URIAuthorityPartIsMalformed: If the authority part of the URI represented
                                                             in the string is malformed.
     - throws MalformedURIError.URIHostMissingFromAuthorityPath: If the host is missing from the authority path.
     - throws MalformedURIError.URISchemeMissing: If the scheme is missing from the URI.
     - throws MalformedURIError.MalformedURI: When the URI was malformed.
    */
    public init(string : String) throws {
        scheme = ""
        super.init(stringValue: string)
        try parseURI(string)
    }
    
    
    /**
     Initialises the URI with the specified local name and in the specified namespace.
     
     - parameter namespace: The namespace to which the resource belongs.
     - parameter localName: The local name of the resource.
     
     - throws `MalformedURIError.URIAuthorityPartIsMalformed`: If the authority part of the URI represented
     in the string is malformed.
     - throws `MalformedURIError.URIHostMissingFromAuthorityPath`: If the host is missing from the authority path.
     - throws `MalformedURIError.URISchemeMissing`: If the scheme is missing from the URI.
     - throws `MalformedURIError.MalformedURI`: When the URI was malformed.
     */
    public init(namespace : String, localName : String) throws {
        scheme = ""
        let string = "\(namespace)\(localName)"
        super.init(stringValue: string)
        try parseURI(string)
    }
    
    
    // MARK: Methods for parsing URI strings into URIs.
    
    /**
        This method parses the authority part of a URI string (determined in the method parseURI)
        and extracts the host, the port (when present), and the username and password when present from the URI.
        
        This method uses Regular expressions to extract the different elements of the authority part.
        Pattern for authorisation part:
        ^(([\w\.]+)(:([\S\.]+))?@)?([-\w\.]*)(:([\d]*))?$
          12        34             5         6 7
          2: user
          4: password
          5: host
          7: port
    */
    private func parseAuthorityPart(authorityPart : String) throws {
        // TODO: Determine what to do when passwords include characters like @
        // TODO: Determine if the pattern works with IP addresses IPv4 and IPv6 (between brackets)
        let pattern = "^(([\\w\\.]+)(:([\\S\\.]+))?@)?([-\\w\\.]*)(:([\\d]*))?$"
        do {
            let regex = try NSRegularExpression(pattern: pattern, options: [.CaseInsensitive])
            let matches = regex.matchesInString(authorityPart, options: [], range: NSMakeRange(0, authorityPart.characters.count)) as Array<NSTextCheckingResult>
            if matches.count <= 0 {
                throw MalformedURIError.URIAuthorityPartIsMalformed(message: "The URI has a malformed authority part: '\(authorityPart)'.")
            }
            let nsstring = authorityPart as NSString
            for match in matches as [NSTextCheckingResult] {
                
                for index in 1...match.numberOfRanges-1 {
                    let range = match.rangeAtIndex(index)
                    if range.location != NSNotFound {
                        let substring = nsstring.substringWithRange(match.rangeAtIndex(index))
                        print("authoritypart: \(index): \(substring)")
                    }
                }
                
                if match.rangeAtIndex(5).location != NSNotFound {
                    host = nsstring.substringWithRange(match.rangeAtIndex(5)) as String
                } else {
                    throw MalformedURIError.URIHostMissingFromAuthorityPath(message: "The host is missing from the authority part '\(authorityPart)' of the URI.")
                }
                if match.rangeAtIndex(7).location != NSNotFound {
                    let portstr = nsstring.substringWithRange(match.rangeAtIndex(7)) as String
                    port = Int(portstr)
                }
                if match.rangeAtIndex(2).location != NSNotFound {
                    userName = nsstring.substringWithRange(match.rangeAtIndex(2)) as String
                }
                if match.rangeAtIndex(4).location != NSNotFound {
                    password = nsstring.substringWithRange(match.rangeAtIndex(4)) as String
                }
            }
            
            
        } catch {
            throw MalformedURIError.URIAuthorityPartIsMalformed(message: "The URI has a malformed authority part: '\(authorityPart)'.")
        }
    }
    
    private func parseURI(uri : String) throws {
        let pattern = "^(([^:/?#]+):)?(//([^/?#]*))?([^?#]*)(\\?([^#]*))?(#(.*))?"
        do {
            let regex = try NSRegularExpression(pattern: pattern, options: [.CaseInsensitive])
            let matches = regex.matchesInString(uri, options: [], range: NSMakeRange(0, uri.characters.count)) as Array<NSTextCheckingResult>
            if matches.count <= 0 {
                throw MalformedURIError.MalformedURI(message: "The URI '\(uri)' is malformed.", uri: uri)
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
                    throw MalformedURIError.URISchemeMissing(message: "The URI '\(uri)' does not contain a scheme.", uri: uri)
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
                if authorityPart != nil {
                    try parseAuthorityPart(authorityPart!)
                }
            }
        } catch {
            throw MalformedURIError.MalformedURI(message: "The URI '\(uri)' is malformed.", uri: uri)
        }
    }
}

public func == (left: URI, right: URI) -> Bool {
    return left.stringValue == right.stringValue
}