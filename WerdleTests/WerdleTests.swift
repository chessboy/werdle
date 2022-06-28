//
//  WerdleTests.swift
//  WerdleTests
//
//  Created by Robert Silverman on 4/4/20.
//  Copyright © 2022 Robert Silverman. All rights reserved.
//

import XCTest
@testable import Werdle

class WerdleTests: XCTestCase {
	
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
		
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

	func testPadding() throws {
		XCTAssert("4".padding(leftTo: 3, withPad: "0") == "004")
		XCTAssert("4".padding(rightTo: 3, withPad: "0") == "400")
		XCTAssert("4".padding(sidesTo: 3, withPad: "0") == "040")
	}
	
    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
