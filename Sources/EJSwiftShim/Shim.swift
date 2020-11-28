//
//  Shim.swift
//  EJSwiftShimTests
//
//  Created by John on 2020/11/27.
//

import Foundation

public class Shim : Shimable, Replacable {
    
    let target: AnyClass
    let targetSelector: Selector
    let targetMethod: Method
    var replacingBlock: IMP
    var originalIMP: IMP?
    
    
    public static func createClassTypeShim(target: AnyClass,
                                           targetSelector: Selector,
                                           replacingBlock: Any) throws -> Shimable {
        return try ClassTypeShim(target: target, targetSelector: targetSelector, replacingBlock: replacingBlock)
    }
    
    
    public static func createInstanceTypeShim(target: AnyClass,
                                              targetSelector: Selector,
                                              replacingBlock: Any) throws -> Shimable {
        return try InstanceTypeShim(target: target, targetSelector: targetSelector, replacingBlock: replacingBlock)
    }
    
    
    init(target:AnyClass, targetSelector: Selector, targetMethod: Method, replacingBlock: Any) throws {
        self.target = target
        self.targetSelector = targetSelector
        self.targetMethod = targetMethod
        guard BlockChecker.isBlock(target: replacingBlock) else { throw ShimError.invalidBlock }
        self.replacingBlock = imp_implementationWithBlock(replacingBlock)
    }
    
    
    deinit {
        resetMethod()
    }
    
    
    func replaceMethod() {
        guard originalIMP == nil else { return }
        originalIMP = method_setImplementation(targetMethod, replacingBlock)
    }
    
    
    func resetMethod() {
        guard let unwrapped = originalIMP else { return }
        method_setImplementation(targetMethod, unwrapped)
        originalIMP = nil
    }
}
