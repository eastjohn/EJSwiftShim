//
//  ClassTypeShim.swift
//  EJSwiftShimTests
//
//  Created by John on 2020/11/27.
//

import Foundation


class ClassTypeShim : Shim {
    
    init(target: AnyClass, targetSelector: Selector, replacingBlock: Any) throws {
        guard let method = class_getClassMethod(target, targetSelector) else { throw ShimError.invalidStaticSelector }
        try super.init(target: target,
                       targetSelector: targetSelector,
                       targetMethod: method,
                       replacingBlock: replacingBlock)
    }
    
    
    override func replaceMethod() {
        guard originalIMP == nil else { return }
        originalIMP = method_setImplementation(targetMethod, replacingBlock)
    }
    
    
    override func resetMethod() {
        guard let unwrapped = originalIMP else { return }
        method_setImplementation(targetMethod, unwrapped)
        originalIMP = nil
    }
}
