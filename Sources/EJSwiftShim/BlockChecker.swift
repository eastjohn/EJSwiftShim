//
//  BlockChecker.swift
//  EJSwiftShimTests
//
//  Created by John on 2020/11/28.
//

import Foundation

struct BlockChecker {
    static func isBlock(target: Any) -> Bool {
        return String("\(type(of: target))").contains("@convention(block)")
    }
}
