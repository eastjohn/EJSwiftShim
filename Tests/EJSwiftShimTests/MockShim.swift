//
//  MockShim.swift
//  EJSwiftShimTests
//
//  Created by John on 2020/11/28.
//

import Foundation

class MockShim: Shimable, Replacable {
    var wasCalled = ""
    
    
    func replaceMethod() {
        wasCalled = "called \(#function)"
    }
    
    
    func resetMethod() {
        wasCalled = "called \(#function)"
    }
}
