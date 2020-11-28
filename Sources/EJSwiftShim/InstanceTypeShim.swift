//
//  InstanceTypeShim.swift
//  EJSwiftShimTests
//
//  Created by John on 2020/11/28.
//

import Foundation

class InstanceTypeShim : Shim {
    
    init(target: AnyClass, targetSelector: Selector, replacingBlock: Any) throws {
        guard let method = class_getInstanceMethod(target, targetSelector) else { throw ShimError.invalidInstanceSelector }
        try super.init(target: target,
                       targetSelector: targetSelector,
                       targetMethod: method,
                       replacingBlock: replacingBlock)
    }
}
