//
//  AcceptanceTests.swift
//  EJSwiftShimTests
//
//  Created by John on 2020/11/28.
//

import XCTest
import CoreMotion
@testable import EJSwiftShim

class AcceptanceTests: XCTestCase {
    private var context: Context!
    
    override func setUpWithError() throws {
        context = Context()
    }

    
    override func tearDownWithError() throws {
        context = nil
    }

    
    func testReplaceStaticPropertyOfTestClass() throws {
        let expected = 300
        let shim = try Shim.createClassTypeShim(target: TestClass.self,
                                                targetSelector: #selector(getter: TestClass.staticIntProperty),
                                                replacingBlock: {
                                                    _ in
                                                    return expected
                                                } as @convention(block) (Any)->Int)
        
        
        context.addShim(shim)
        context.run {
            XCTAssertEqual(expected, TestClass.staticIntProperty)
        }
        
        
        XCTAssertEqual(20, TestClass.staticIntProperty)
    }

    
    func testReplaceStaticMethodOfTestClass() throws {
        let number = 100
        let shim = try Shim.createClassTypeShim(target: TestClass.self,
                                                targetSelector: #selector(TestClass.intToString(number:)),
                                                replacingBlock: {
                                                    _, number in
                                                    return "Test \(number)"
                                                } as @convention(block) (Any, Int)->String)
        
        
        context.addShim(shim)
        context.run {
            XCTAssertEqual("Test \(number)", TestClass.intToString(number: number))
        }
        
        
        XCTAssertEqual("\(number)", TestClass.intToString(number: number))
    }
    
    
    func testReplaceInstancePropertyOfTestClass() throws {
        let expected = 100.0
        let shim = try Shim.createInstanceTypeShim(target: TestClass.self,
                                                   targetSelector: #selector(getter: TestClass.instanceDoubleProperty),
                                                   replacingBlock: {
                                                    _ in
                                                    return expected
                                                   } as @convention(block) (Any)->Double)
        
        let testClass = TestClass()
        
        context.addShim(shim)
        context.run {
            XCTAssertEqual(expected, testClass.instanceDoubleProperty)
        }
        
        
        XCTAssertEqual(50, testClass.instanceDoubleProperty)
    }

    
    func testReplaceInstanceMethodOfTestClass() throws {
        let expected = 300
        let shim = try Shim.createInstanceTypeShim(target: TestClass.self,
                                                targetSelector: #selector(TestClass.stringToInt(aString:)),
                                                replacingBlock: {
                                                    _, aString in
                                                    return expected
                                                } as @convention(block) (Any, String)->Int)
        
        
        let testClass = TestClass()
        context.addShim(shim)
        context.run {
            XCTAssertEqual(expected, testClass.stringToInt(aString: "100"))
        }
        
        
        XCTAssertEqual(100, testClass.stringToInt(aString: "100"))
    }
    
    
    func testReplaceClassPropertyOfNSDate() throws {
        let expected = 100.0
        let shim = try Shim.createClassTypeShim(target: NSDate.self,
                                                targetSelector: #selector(getter: NSDate.timeIntervalSinceReferenceDate),
                                            replacingBlock: {
                                                _ in
                                                return expected
                                            } as @convention(block) (Any)->Double )
        
        context.addShim(shim)
        context.run {
            XCTAssertEqual(expected, NSDate.timeIntervalSinceReferenceDate)
        }
        
        XCTAssertNotEqual(expected, NSDate.timeIntervalSinceReferenceDate)
    }
    
    
    func testReplaceInstancePropertyOfNSDate() throws {
        let expected = 100.0
        let date = NSDate()
        let shim = try Shim.createInstanceTypeShim(target: type(of: date),
                                                   targetSelector: #selector(getter: NSDate.timeIntervalSinceReferenceDate),
                                                   replacingBlock: {
                                                    _ in
                                                    return expected
                                                   } as @convention(block) (Any)->Double )
        
        context.addShim(shim)
        context.run {
            XCTAssertEqual(expected, date.timeIntervalSinceReferenceDate)
        }
        
        XCTAssertNotEqual(expected, date.timeIntervalSinceReferenceDate)
    }
    
    
    func testReplaceInstanceMethodOfCMMotionManager() throws {
        let expectedError = NSError(domain: "test", code: 10, userInfo: nil)
        let motion = CMMotionManager()
        let shim = try Shim.createInstanceTypeShim(target: type(of: motion),
                                                   targetSelector: #selector(CMMotionManager.startDeviceMotionUpdates(to:withHandler:)),
                                                   replacingBlock: {
                                                    (_, queue:OperationQueue, handler: CMDeviceMotionHandler) in
                                                    handler(nil, expectedError)
                                                   } as @convention(block) (Any, OperationQueue, CMDeviceMotionHandler)->() )
        
        context.addShim(shim)
        context.run {
            motion.startDeviceMotionUpdates(to: OperationQueue.current!) { (motion, error) in
                XCTAssertEqual(expectedError, error! as NSError)
            }
        }
    }
    
    
    func testAsyncReplaceInstanceMethodOfCMMotionManager() throws {
        let expectation = self.expectation(description: "test CMMotionManager")
        let expectedError = NSError(domain: "test", code: 10, userInfo: nil)
        let motion = CMMotionManager()
        let shim = try Shim.createInstanceTypeShim(target: type(of: motion),
                                                   targetSelector: #selector(CMMotionManager.startGyroUpdates(to:withHandler:)),
                                                   replacingBlock: { (_, queue:OperationQueue, handler: @escaping CMGyroHandler) in
                                                        DispatchQueue.global().async {
                                                            handler(nil, expectedError)
                                                        }
                                                   } as @convention(block) (Any, OperationQueue, @escaping CMGyroHandler)->() )
        
        context.addShim(shim)
        context.asyncRun { completed in
            motion.startGyroUpdates(to: OperationQueue.current!) { _, error in
                XCTAssertEqual(expectedError, error! as NSError)
                completed()
                expectation.fulfill()
            }
        }
        
        wait(for: [expectation], timeout: 1)
    }
}
