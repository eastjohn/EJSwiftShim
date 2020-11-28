//
//  Shimable.swift
//  EJSwiftShimTests
//
//  Created by John on 2020/11/27.
//

import Foundation

public protocol Shimable: class {
    
}

extension Shimable {
    internal func asReplacable() -> Replacable {
        return self as! Replacable
    }
}


internal protocol Replacable: class {
    func replaceMethod()
    func resetMethod()
}
