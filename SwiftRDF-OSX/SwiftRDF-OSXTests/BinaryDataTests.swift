//
//  BinaryDataTests.swift
//  SwiftRDF-OSX
//
//  Created by Don Willems on 16/12/15.
//  Copyright © 2015 lapsedpacifist. All rights reserved.
//

import Foundation

import XCTest
@testable import SwiftRDFOSX

class BinaryDataTests : XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testHexDecimalData() {
        var string = "greenland"
        var plainData = (string as NSString).dataUsingEncoding(NSUTF8StringEncoding)!
        var hexdatastring = plainData.hexadecimalString()
        var decodeddata = hexdatastring.dataFromHexadecimalString()
        var decodedstring = NSString(data: decodeddata!, encoding: NSUTF8StringEncoding) as! String
        XCTAssertEqual(string, decodedstring)
        
        string = "34435kSDasdk ^^éfdsfkk^sadøfrefgkkd"
        plainData = (string as NSString).dataUsingEncoding(NSUTF8StringEncoding)!
        hexdatastring = plainData.hexadecimalString()
        decodeddata = hexdatastring.dataFromHexadecimalString()
        decodedstring = NSString(data: decodeddata!, encoding: NSUTF8StringEncoding) as! String
        XCTAssertEqual(string, decodedstring)
    }
    
    func testBase64BinaryData() {
        var string = "greenland"
        var plainData = (string as NSString).dataUsingEncoding(NSUTF8StringEncoding)!
        var hexdatastring = plainData.base64String()
        var decodeddata = hexdatastring.dataFromBase64BinaryString()
        var decodedstring = NSString(data: decodeddata!, encoding: NSUTF8StringEncoding) as! String
        XCTAssertEqual(string, decodedstring)
        
        string = "34435kSDasdk ^^éfdsfkk^sadøfrefgkkd"
        plainData = (string as NSString).dataUsingEncoding(NSUTF8StringEncoding)!
        hexdatastring = plainData.base64String()
        decodeddata = hexdatastring.dataFromBase64BinaryString()
        decodedstring = NSString(data: decodeddata!, encoding: NSUTF8StringEncoding) as! String
        XCTAssertEqual(string, decodedstring)
    }
    
}
