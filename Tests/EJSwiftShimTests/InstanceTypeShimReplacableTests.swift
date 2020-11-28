//
//  InstanceTypeShimReplacableTests.swift
//  EJSwiftShimTests
//
//  Created by John on 2020/11/28.
//

import XCTest

class InstanceTypeShimReplacableTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    
    func testAsReplacable_ThenReturnReplacalble() throws {
        let shim = TestShimCreator.createInstanceShim() as! InstanceTypeShim
        
        
        XCTAssertTrue(shim === shim.asReplacable())
    }
}
