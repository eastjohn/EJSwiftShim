//
//  ShimError.swift
//  EJSwiftShimTests
//
//  Created by John on 2020/11/28.
//

import Foundation

public enum ShimError : Error {
    case invalidStaticSelector
    case invalidInstanceSelector
    case invalidBlock
}
