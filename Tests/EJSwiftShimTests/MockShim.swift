//
//  MockShim.swift
//  EJSwiftShimTests
//
//  Created by John on 2020/11/28.
//

import Foundation
@testable import EJSwiftShim

class MockShim: Shimable, Replacable {
    var wasCalled = ""
    
    
    func replaceMethod() {
        wasCalled = "called \(#function)"
    }
    
    
    func resetMethod() {
        wasCalled = "called \(#function)"
    }
}
