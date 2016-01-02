//
//  DatatypeTest.swift
//  SwiftRDF-OSX
//
//  Created by Don Willems on 30/11/15.
//  Copyright © 2015 lapsedpacifist. All rights reserved.
//

import Foundation

import XCTest
@testable import SwiftRDFOSX

class DatatypeTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    
    func testXSDDatatypeURI() {
        XCTAssertEqual("http://www.w3.org/2001/XMLSchema#string", XSD.string.stringValue)
        XCTAssertEqual("http://www.w3.org/2001/XMLSchema#gDay", XSD.gDay.stringValue)
    }
    
    func testXSDDatatypeDerivation() {
        XCTAssertTrue(XSD.integer.isDerivedFromDatatype(XSD.decimal))
        XCTAssertTrue(XSD.unsignedByte.isDerivedFromDatatype(XSD.decimal))
    }
}