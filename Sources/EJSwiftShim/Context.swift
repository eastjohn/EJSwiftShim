//
//  Context.swift
//  EJSwiftShimTests
//
//  Created by John on 2020/11/28.
//

import Foundation


public struct Context {
    var shims = [Shimable]()
    
    public mutating func addShim(_ shim: Shimable) {
        shims.append(shim)
    }
    
    
    public mutating func addShims(_ shims: [Shimable]) {
        self.shims.append(contentsOf: shims)
    }
    
    
    public mutating func removeShim(_ shim: Shimable) {
        guard let removeIndex = shims.firstIndex(where: { $0 === shim }) else { return }
        shims.remove(at: removeIndex)
    }
    
    
    public mutating func removeAllShims() {
        shims.removeAll()
    }
    
    
    public func run(execute: ()->()) {
        shims.forEach { $0.asReplacable().replaceMethod() }
        execute()
        shims.forEach { $0.asReplacable().resetMethod() }
    }
}
