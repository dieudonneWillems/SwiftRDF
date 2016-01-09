//
//  SwiftRDF_OSXTests.swift
//  SwiftRDF-OSXTests
//
//  Created by Don Willems on 20/11/15.
//  Copyright © 2015 lapsedpacifist. All rights reserved.
//

import XCTest
@testable import SwiftRDFOSX

class URITests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testNamespaceAndLocalName(){
        var localname = "localname"
        var namespace = "http://example.com/my/file#"
        var uri = URI(namespace: namespace, localName: localname)!
        XCTAssertEqual(localname, uri.localName)
        XCTAssertEqual(namespace, uri.namespace)
        
        localname = "localname2"
        namespace = "http://example.com/my/file/"
        uri = URI(namespace: namespace, localName: localname)!
        XCTAssertEqual(localname, uri.localName)
        XCTAssertEqual(namespace, uri.namespace)
    }
    
    func testURIEquality() {
        let uri = URI(string : "http://www.w3.org/1999/02/22-rdf-syntax-ns#Bag")!
        XCTAssertTrue(RDF.Bag == uri)
    }
    
    
    func testURIwithURL() {
        let uri = URI(string : "http://example.com/my/file#anchor")!
        XCTAssertEqual("http://example.com/my/file#anchor", uri.stringValue)
        XCTAssertEqual("http", uri.scheme)
        XCTAssertEqual("example.com/my/file", uri.hierarchicalPart)
        XCTAssertEqual("example.com", uri.authorityPart)
        XCTAssertEqual("example.com", uri.host)
        XCTAssertEqual("/my/file", uri.path)
        XCTAssertEqual("anchor", uri.fragment)
    }
    
    func testURIwithURLWithPort() {
        let uri = URI(string : "http://example.com:8080/my/file#anchor")!
        XCTAssertEqual("http://example.com:8080/my/file#anchor", uri.stringValue)
        XCTAssertEqual("http", uri.scheme)
        XCTAssertEqual("example.com:8080/my/file", uri.hierarchicalPart)
        XCTAssertEqual("example.com:8080", uri.authorityPart)
        XCTAssertEqual("example.com", uri.host)
        XCTAssertEqual("/my/file", uri.path)
        XCTAssertEqual("anchor", uri.fragment)
    }
    
    func testURIwithURLWithUsernameAndPasswordPortAndFragment() {
        let uri = URI(string : "http://me:mYpAssword&^%%6@www.example-site.com:8080/my/file?query=bla#anchor")! 
        XCTAssertEqual("http://me:mYpAssword&^%%6@www.example-site.com:8080/my/file?query=bla#anchor", uri.stringValue)
        XCTAssertEqual("http", uri.scheme)
        XCTAssertEqual("me", uri.userName)
        XCTAssertEqual("mYpAssword&^%%6", uri.password)
        XCTAssertEqual("me:mYpAssword&^%%6@www.example-site.com:8080/my/file", uri.hierarchicalPart)
        XCTAssertEqual("me:mYpAssword&^%%6@www.example-site.com:8080", uri.authorityPart)
        XCTAssertEqual("www.example-site.com", uri.host)
        XCTAssertEqual("/my/file", uri.path)
        XCTAssertEqual("query=bla", uri.query)
        XCTAssertEqual("anchor", uri.fragment)
    }
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock {
            // Put the code you want to measure the time of here.
        }
    }
    
}
