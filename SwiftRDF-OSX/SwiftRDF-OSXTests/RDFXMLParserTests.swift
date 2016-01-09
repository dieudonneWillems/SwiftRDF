//
//  RDFXMLParserTests.swift
//  SwiftRDF-OSX
//
//  Created by Don Willems on 09/01/16.
//  Copyright © 2016 lapsedpacifist. All rights reserved.
//


import XCTest
@testable import SwiftRDFOSX

import Foundation

class RDFXMLParserTests : XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testRDFXMLParserOnGeonames() {
        
        do{
            let uri = URI(string: "http://sws.geonames.org/6058560/about.rdf")!
            let parser = RDFXMLParser(uri: uri)
            
            var graph = parser?.parse()
        }catch {
            
        }
    }
}
