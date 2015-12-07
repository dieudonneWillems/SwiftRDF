//
//  TimeLiteralTests.swift
//  SwiftRDF-OSX
//
//  Created by Don Willems on 07/12/15.
//  Copyright © 2015 lapsedpacifist. All rights reserved.
//

import Foundation

import XCTest
@testable import SwiftRDFOSX

class TimeLiteralTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    
    func testDurationLiteral() {
        let lit1 = Literal(durationValue: Duration(positive: true, years: 12, months: 23, days: 14, hours: 0, minutes: 0, seconds: 0))
        XCTAssertEqual("P12Y23M14D", lit1.stringValue)
        XCTAssertEqual("\"P12Y23M14D\"^^xsd:duration", lit1.sparql)
        XCTAssertTrue(lit1.dataType! == XSD.duration)
        XCTAssertNil(lit1.language)
        XCTAssertNil(lit1.longValue)
        let lit2 = Literal(durationValue: Duration(positive: false, years: 12, months: 23, days: 14, hours: 15, minutes: 2, seconds: 0.93))
        XCTAssertEqual("-P12Y23M14DT15H2M0.93S", lit2.stringValue)
        XCTAssertEqual("\"-P12Y23M14DT15H2M0.93S\"^^xsd:duration", lit2.sparql)
        XCTAssertTrue(lit2.dataType! == XSD.duration)
        XCTAssertNil(lit2.language)
        XCTAssertNil(lit2.longValue)
    }
    
    func testDurationLiteralFromString() {
        let lit1 = Literal(stringValue: "P12Y23M14D", dataType: XSD.duration)!
        XCTAssertEqual("P12Y23M14D", lit1.stringValue)
        XCTAssertEqual("\"P12Y23M14D\"^^xsd:duration", lit1.sparql)
        XCTAssertTrue(lit1.dataType! == XSD.duration)
        XCTAssertNil(lit1.language)
        XCTAssertNil(lit1.longValue)
        let lit2 = Literal(stringValue: "-P12Y23M14DT15H2M0.93S", dataType: XSD.duration)!
        XCTAssertEqual("-P12Y23M14DT15H2M0.93S", lit2.stringValue)
        XCTAssertEqual("\"-P12Y23M14DT15H2M0.93S\"^^xsd:duration", lit2.sparql)
        XCTAssertTrue(lit2.dataType! == XSD.duration)
        XCTAssertNil(lit2.language)
        XCTAssertNil(lit2.longValue)
        
    }
}
