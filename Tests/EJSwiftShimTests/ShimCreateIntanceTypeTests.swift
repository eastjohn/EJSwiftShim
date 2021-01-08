//
//  ShimCreateIntanceTypeTests.swift
//  EJSwiftShimTests
//
//  Created by John on 2020/11/28.
//

import XCTest
@testable import EJSwiftShim

class ShimCreateIntanceTypeTests: XCTestCase {
    
    func testCreateInstanceShim_ThenReturnClassTypeShim() throws {
        let shim = try Shim.createInstanceTypeShim(target: TestClass.self,
                                                   targetSelector: #selector(TestClass.stringToInt(aString:)),
                                                   replacingBlock: {
                                                    _, aString in
                                                    return 100
                                                   } as @convention(block) (Any, String)-> Int)
        
        
        XCTAssertTrue(shim is InstanceTypeShim)
    }
    
    
    func testCreateInstanceShim_ThenSetProperty() throws {
        let expectedSelector = #selector(TestClass.stringToInt(aString:))
        let expectedBlock: @convention(block) (Any, String) -> Int = { _, aString in
            return 100
        }
        
        
        let shim = try Shim.createInstanceTypeShim(target: TestClass.self,
                                            targetSelector: expectedSelector,
                                            replacingBlock: expectedBlock) as! InstanceTypeShim
        
        
        XCTAssertTrue(TestClass.self == shim.target)
        XCTAssertEqual(expectedSelector, shim.targetSelector)
        XCTAssertEqual(class_getInstanceMethod(TestClass.self, expectedSelector), shim.targetMethod)
        XCTAssertTrue(expectedBlock as AnyObject === imp_getBlock(shim.replacingBlock) as AnyObject)
    }
    
    
    func testCreateInstanceShim_WhenInvalidSelector_ThenThrowInvalidInstanceSelectorError() {
        do {
            _ = try Shim.createInstanceTypeShim(target: TestClass.self,
                                                targetSelector: #selector(TestClass.intToString(number:)),
                                                replacingBlock: {
                                                    _, number in
                                                    return "Test \(number)"
                                                } as @convention(block) (Any, Int)-> String)
            XCTFail()
        } catch ShimError.invalidInstanceSelector {
            // Success
        } catch {
            XCTFail()
        }
    }
    
    
    func testCreateInstanceShim_WhenBlockIsInvalid_ThenThrowInvalidBlockError() {
        do {
            _ = try Shim.createInstanceTypeShim(target: TestClass.self,
                                                targetSelector: #selector(TestClass.stringToInt(aString:)),
                                                replacingBlock: 1)
            XCTFail()
        } catch ShimError.invalidBlock {
            // Success
        } catch {
            XCTFail()
        }
    }
    
    
    func testCreateInstanceShim_WhenBlockIsClosure_ThenThrowInvalidBlockError() {
        do {
            _ = try Shim.createInstanceTypeShim(target: TestClass.self,
                                                targetSelector: #selector(TestClass.stringToInt(aString:)),
                                                replacingBlock: { (_: Any) in })
            XCTFail()
        } catch ShimError.invalidBlock {
            // Success
        } catch {
            XCTFail()
        }
    }
}
