//
//  TestClass.swift
//  EJSwiftShimTests
//
//  Created by John on 2020/11/27.
//

import Foundation


class TestClass {
    @objc dynamic static var staticIntProperty: Int {
        get {
            return 20
        }
    }
    
    
    @objc dynamic static func intToString(number: Int) -> String {
        return "\(number)"
    }
    
    
    @objc dynamic var instanceDoubleProperty: Double {
        get {
            return 50.0
        }
    }
    
    
    @objc dynamic func stringToInt(aString: String) -> Int {
        return Int(aString) ?? 0
    }
}


struct TestShimCreator {
    static func createClassShim() -> Shimable {
        return try! Shim.createClassTypeShim(target: TestClass.self,
                                             targetSelector: #selector(TestClass.intToString(number:)),
                                             replacingBlock: {
                                                _, number in
                                                return "Test \(number)"
                                             } as @convention(block) (Any, Int)-> String)
    }
    
    
    static func createInstanceShim() -> Shimable {
        return try! Shim.createInstanceTypeShim(target: TestClass.self,
                                                targetSelector: #selector(TestClass.stringToInt(aString:)),
                                                replacingBlock: {
                                                    _, aString in
                                                    return 100
                                                } as @convention(block) (Any, String)-> Int)
    }
}
