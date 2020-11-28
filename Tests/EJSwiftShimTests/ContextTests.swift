//
//  ContextTests.swift
//  EJSwiftShimTests
//
//  Created by John on 2020/11/28.
//

import XCTest

class ContextTests: XCTestCase {

    private var context: Context!
    
    
    override func setUpWithError() throws {
        context = Context()
    }

    override func tearDownWithError() throws {
        context = nil
    }

    // MARK: - Given
    func GivenHasShims() {
        context.addShims([TestShimCreator.createClassShim(),
                          TestShimCreator.createInstanceShim()])
    }
    
    
    func testCreateContext() {
        XCTAssertNotNil(context)
    }

    
    func testAddShim() {
        let shim = TestShimCreator.createClassShim()
        
        
        context.addShim(shim)
        
        
        XCTAssertEqual(1, context.shims.count)
    }
    
    
    func testTwiceAddShim() {
        let shim = TestShimCreator.createClassShim()
        
        
        context.addShim(shim)
        context.addShim(shim)
        
        
        XCTAssertEqual(2, context.shims.count)
    }
    
    
    func testAddShims() {
        let staticShim = TestShimCreator.createClassShim()
        let instanceShim = TestShimCreator.createInstanceShim()
        
        
        context.addShims([staticShim, instanceShim])
        
        
        XCTAssertEqual(2, context.shims.count)
    }
    
    
    func testAddShims_WhenExistShim_ThenAddToLast() {
        GivenHasShims()
        
        
        context.addShims([TestShimCreator.createClassShim()])
        
        
        XCTAssertEqual(3, context.shims.count)
    }
    
    
    func testFirstItemRemoveShim() {
        GivenHasShims()
        let removeItem = context.shims[0]
        
        
        context.removeShim(removeItem)
        
        
        XCTAssertEqual(1, context.shims.count)
        XCTAssertTrue(removeItem !== context.shims[0])
    }
    
    
    func testLastItemRemoveShim() {
        GivenHasShims()
        let removeItem = context.shims[1]
        
        
        context.removeShim(removeItem)
        
        
        XCTAssertEqual(1, context.shims.count)
        XCTAssertTrue(removeItem !== context.shims[0])
    }
    
    
    func testRemoveAllShims() {
        GivenHasShims()
        
        
        context.removeAllShims()
        
        
        XCTAssertEqual(0, context.shims.count)
    }
    
    
    func thenWasCalledShimsOfContext(expectedWasCalled: String) {
        context.shims.forEach {
            XCTAssertEqual(expectedWasCalled, ($0 as! MockShim).wasCalled)
        }
    }
    
    
    func testRun_ThenReplaceMethodShims() {
        let expectedWasCalled = "called replaceMethod()"
        context.addShims([MockShim(), MockShim()])
        context.run {
            thenWasCalledShimsOfContext(expectedWasCalled: expectedWasCalled)
        }
    }
    
    
    func testAfterRun_ThenResetMethodShims() {
        let expectedWasCalled = "called resetMethod()"
        context.addShims([MockShim(), MockShim()])
        context.run {
            context.shims.forEach {
                ($0 as! MockShim).wasCalled = ""
            }
        }
        
        thenWasCalledShimsOfContext(expectedWasCalled: expectedWasCalled)
    }
}