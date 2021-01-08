//
//  ClassTypeShimReplacableTests.swift
//  EJSwiftShimTests
//
//  Created by John on 2020/11/28.
//

import XCTest
@testable import EJSwiftShim

class ClassTypeShimReplacableTests: XCTestCase {
    private var shim: ClassTypeShim!

    override func setUpWithError() throws {
        shim = TestShimCreator.createClassShim() as? ClassTypeShim
    }

    override func tearDownWithError() throws {
        shim = nil
    }

    
    // MARK: - Given
    func givenRepaceMethod() {
        shim.replaceMethod()
    }
    
    
    func testAsReplacable_ThenReturnReplacalble() throws {
        XCTAssertTrue(shim === shim.asReplacable())
    }
    
    
    func testReplaceMethod_ThenMethodReplaced() throws {
        let number = 100
        let expected = "Test \(number)"
        
        
        shim.replaceMethod()
        
        
        XCTAssertEqual(expected, TestClass.intToString(number: 100))
    }
    
    
    func testTwiceReplaceMethod_ThenMethodReplaced() throws {
        let number = 100
        let expected = "Test \(number)"
        
        
        shim.replaceMethod()
        shim.replaceMethod()
        
        
        XCTAssertEqual(expected, TestClass.intToString(number: 100))
    }
    
    
    func testTwiceReplaceMethod_ThenNotChangeOriginalIMP() throws {
        shim.replaceMethod()
        let originalIMP = shim.originalIMP
        
        
        shim.replaceMethod()
        
        
        XCTAssertEqual(originalIMP, shim.originalIMP)
    }
    
    
    func testResetMethod_ThenChangeToOriginalMethod() throws {
        givenRepaceMethod()
        let expected = 100
        
        
        shim.resetMethod()
        
        
        XCTAssertEqual("\(expected)", TestClass.intToString(number: 100))
    }
    
    
    func testResetMethod_ThenOrignalIMPIsNil() throws {
        givenRepaceMethod()
        
        
        shim.resetMethod()
        
        
        XCTAssertNil(shim.originalIMP)
    }
    
    
    func testTwiceResetMethod_ThenNotThrow() throws {
        givenRepaceMethod()
        
        shim.resetMethod()
        shim.resetMethod()
    }
    
    
    func testDeinit_ThenRestMethod() throws {
        givenRepaceMethod()
        let expected = 100
        
        
        shim = nil
        
        
        XCTAssertEqual("\(expected)", TestClass.intToString(number: expected))
    }
    
    
    func testDeinit_ThenBlockImpIsReleased() throws {
        givenRepaceMethod()
        let blockIMP = shim.replacingBlock
        
        
        shim = nil
        
        
        XCTAssertNil(imp_getBlock(blockIMP))
    }
}
