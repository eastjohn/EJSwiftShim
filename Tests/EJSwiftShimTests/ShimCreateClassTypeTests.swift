//
//  ShimCreateTests.swift
//  EJSwiftShimTests
//
//  Created by John on 2020/11/27.
//

import XCTest
@testable import EJSwiftShim

class ShimCreateClassTypeTests: XCTestCase {
    
    func testCreateClassShim_ThenReturnClassTypeShim() throws {
        let shim = try Shim.createClassTypeShim(target: TestClass.self,
                                                targetSelector: #selector(TestClass.intToString(number:)),
                                                replacingBlock: {
                                                    _, number in
                                                    return "Test \(number)"
                                                } as @convention(block) (Any, Int)-> String)
        
        
        XCTAssertTrue(shim is ClassTypeShim)
    }

    
    func testCreateClassShim_ThenSetProperty() throws {
        let expectedSelector = #selector(TestClass.intToString(number:))
        let expectedBlock: @convention(block) (Any, Int) -> String = { _, number in
            return "Test \(number)"
        }
        
        
        let shim = try Shim.createClassTypeShim(target: TestClass.self,
                                            targetSelector: expectedSelector,
                                            replacingBlock: expectedBlock) as! ClassTypeShim
        
        
        XCTAssertTrue(TestClass.self == shim.target)
        XCTAssertEqual(expectedSelector, shim.targetSelector)
        XCTAssertEqual(class_getClassMethod(TestClass.self, expectedSelector), shim.targetMethod)
        XCTAssertTrue(expectedBlock as AnyObject === imp_getBlock(shim.replacingBlock) as AnyObject)
    }
    
    
    func testCreateClassShim_WhenInvalidSelector_ThenThrowInvalidStaticSelectorError() {
        do {
            _ = try Shim.createClassTypeShim(target: TestClass.self,
                                             targetSelector: Selector(("InvalidSelector")),
                                             replacingBlock: {
                                                _, number in
                                                return "Test \(number)"
                                             } as @convention(block) (Any, Int)-> String)
            XCTFail()
        } catch ShimError.invalidStaticSelector {
            // Success
        } catch {
            XCTFail()
        }
    }
    
    
    func testCreateClassShim_WhenBlockIsInvalid_ThenThrowInvalidBlockError() {
        do {
            _ = try Shim.createClassTypeShim(target: TestClass.self,
                                                    targetSelector: #selector(TestClass.intToString(number:)),
                                                    replacingBlock: 1)
            XCTFail()
        } catch ShimError.invalidBlock {
            // Success
        } catch {
            XCTFail()
        }
    }
    
    
    func testCreateClassShim_WhenBlockIsClosure_ThenThrowInvalidBlockError() {
        do {
            _ = try Shim.createClassTypeShim(target: TestClass.self,
                                                    targetSelector: #selector(TestClass.intToString(number:)),
                                                    replacingBlock: { (_: Any) in })
            XCTFail()
        } catch ShimError.invalidBlock {
            // Success
        } catch {
            XCTFail()
        }
    }
}
