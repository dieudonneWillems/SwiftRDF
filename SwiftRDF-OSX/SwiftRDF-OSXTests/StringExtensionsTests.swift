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
}
