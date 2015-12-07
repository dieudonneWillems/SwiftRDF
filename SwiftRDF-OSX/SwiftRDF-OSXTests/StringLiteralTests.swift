//
//  StringLiteralTests.swift
//  SwiftRDF-OSX
//
//  Created by Don Willems on 05/12/15.
//  Copyright © 2015 lapsedpacifist. All rights reserved.
//

import Foundation

import XCTest
@testable import SwiftRDFOSX

class StringLiteralTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    
    func testStringLiteral() {
        let lit1 = Literal(stringValue: "Hello World")
        XCTAssertEqual("Hello World", lit1.stringValue)
        XCTAssertEqual("\"Hello World\"", lit1.sparql)
        XCTAssertNil(lit1.dataType)
        XCTAssertNil(lit1.language)
        XCTAssertNil(lit1.longValue)
        let lit2 = Literal(stringValue: "Hello World", language: "en")
        XCTAssertEqual("Hello World", lit2.stringValue)
        XCTAssertEqual("\"Hello World\"@en", lit2.sparql)
        XCTAssertEqual("en", lit2.language)
        XCTAssertTrue(XSD.string == lit2.dataType!)
        XCTAssertNil(lit2.longValue)
    }
}
