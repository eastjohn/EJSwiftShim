//
//  InstanceTypeShimReplacableTests.swift
//  EJSwiftShimTests
//
//  Created by John on 2020/11/28.
//

import XCTest

class InstanceTypeShimReplacableTests: XCTestCase {
    private var shim: InstanceTypeShim!
    private var target: TestClass!
    
    override func setUpWithError() throws {
        shim = TestShimCreator.createInstanceShim() as? InstanceTypeShim
        target = TestClass()
    }

    override func tearDownWithError() throws {
        shim = nil
        target = nil
    }

    
    // MARK: - Given
    func givenRepaceMethod() {
        shim.replaceMethod()
    }
    
    
    func testAsReplacable_ThenReturnReplacalble() throws {
        XCTAssertTrue(shim === shim.asReplacable())
    }
    
    
    func testReplaceMethod_ThenMethodReplaced() throws {
        let expected = 100
        
        
        shim.replaceMethod()
        
        
        XCTAssertEqual(expected, target.stringToInt(aString: "890"))
    }
    
    
    func testReplaceMethod_ThenSetOriginalIMP() throws {
        shim.replaceMethod()
        
        
        XCTAssertNotNil(shim.originalIMP)
    }
    
    
    func testTwiceReplaceMethod_ThenMethodReplaced() throws {
        let expected = 100
        
        
        shim.replaceMethod()
        shim.replaceMethod()
        
        
        XCTAssertEqual(expected, target.stringToInt(aString: "890"))
    }
    
    
    func testTwiceReplaceMethod_ThenNotChangeOriginalIMP() throws {
        shim.replaceMethod()
        let originalIMP = shim.originalIMP
        
        
        shim.replaceMethod()
        
        
        XCTAssertEqual(originalIMP, shim.originalIMP)
    }
    
    
    func testResetMethod_ThenChangeToOriginalMethod() throws {
        givenRepaceMethod()
        let expected = 890
        
        
        shim.resetMethod()
        
        
        XCTAssertEqual(expected, target.stringToInt(aString: "\(expected)"))
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
        let expected = 890
        
        
        shim = nil
        
        
        XCTAssertEqual(expected, target.stringToInt(aString: "\(expected)"))
    }
    
    
    func testDeinit_ThenBlockImpIsReleased() throws {
        givenRepaceMethod()
        let blockIMP = shim.replacingBlock
        
        
        shim = nil
        
        
        XCTAssertNil(imp_getBlock(blockIMP))
    }
}
