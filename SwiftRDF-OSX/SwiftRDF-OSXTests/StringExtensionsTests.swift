//
//  StringExtensionsTests.swift
//  SwiftRDF-OSX
//
//  Created by Don Willems on 19/12/15.
//  Copyright © 2015 lapsedpacifist. All rights reserved.
//

import Foundation

import XCTest
@testable import SwiftRDFOSX

class DatStringExtensionsTestseTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testNormalised(){
        var string = " Test case with normalised string.  "
        XCTAssertTrue(string.isNormalised)
        
        string = " Another       test case with a normalised string.  "
        XCTAssertTrue(string.isNormalised)
        
        string = " A Test case with an \nunnormalised string.  "
        XCTAssertFalse(string.isNormalised)
        
        string = " A Test case with an \tunnormalised string.  "
        XCTAssertFalse(string.isNormalised)
        
        string = " A Test case with an \runnormalised string.  "
        XCTAssertFalse(string.isNormalised)
        
        string = " A Test case \nwith an \runnormalised string.  "
        XCTAssertFalse(string.isNormalised)
    }
    
    func testTokenised(){
        var string = "Test case with normalised string."
        XCTAssertTrue(string.isTokenised)
        
        string = " Test case with normalised string."
        XCTAssertFalse(string.isTokenised)
        
        string = "Another  test case with a normalised string."
        XCTAssertFalse(string.isTokenised)
        
        string = "A Test case with an \nunnormalised string."
        XCTAssertFalse(string.isTokenised)
        
        string = "A Test case with an \tunnormalised string."
        XCTAssertFalse(string.isTokenised)
        
        string = "A Test case with an \runnormalised string."
        XCTAssertFalse(string.isTokenised)
        
        string = "A Test case \nwith an \runnormalised string."
        XCTAssertFalse(string.isTokenised)
    }
    
    func testIsLanguageIdentifier() {
        var string = "en"
        XCTAssertTrue(string.validLanguageIdentifier)
        
        string = "nl"
        XCTAssertTrue(string.validLanguageIdentifier)
        
        string = "en-US"
        XCTAssertTrue(string.validLanguageIdentifier)
        
        string = "abcdefgh"
        XCTAssertTrue(string.validLanguageIdentifier)
        
        string = "abcdefghi"
        XCTAssertFalse(string.validLanguageIdentifier)
        
        string = "12dsd"
        XCTAssertFalse(string.validLanguageIdentifier)
        
        string = "en-US-ok"
        XCTAssertTrue(string.validLanguageIdentifier)
        
        string = " en"
        XCTAssertFalse(string.validLanguageIdentifier)
    }
    
    func testIsValidName() {
        var string = "prefix:something"
        XCTAssertTrue(string.validName)
        
        string = "name"
        XCTAssertTrue(string.validName)
        
        string = "één:PrefIX"
        XCTAssertTrue(string.validName)
        
        string = "BOL:name"
        XCTAssertTrue(string.validName)
        
        string = "9number"
        XCTAssertFalse(string.validName)
        
        string = "name space"
        XCTAssertFalse(string.validName)
        
        string = "_:name_with:other-symbols"
        XCTAssertTrue(string.validName)
        
        string = " nottrimmed "
        XCTAssertFalse(string.validName)
    }
    
    func testIsValidNCName() {
        var string = "something"
        XCTAssertTrue(string.validNCName)
        
        string = "name"
        XCTAssertTrue(string.validNCName)
        
        string = "éénPrefIX"
        XCTAssertTrue(string.validNCName)
        
        string = "BOLname"
        XCTAssertTrue(string.validNCName)
        
        string = "prefix:something"
        XCTAssertFalse(string.validNCName)
        
        string = "name space"
        XCTAssertFalse(string.validNCName)
        
        string = "_:name_with:other-symbols"
        XCTAssertFalse(string.validNCName)
        
        string = " nottrimmed "
        XCTAssertFalse(string.validNCName)
    }
}
