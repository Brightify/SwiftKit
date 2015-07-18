//
//  IntMappingOperators.swift
//  Pods
//
//  Created by Tadeas Kriz on 16/07/15.
//
//

import Foundation

infix operator <- {}

private let intTransformation = IntTransformation()

public func <- (inout field: Int, map: Map) {
    field <- map | intTransformation
}

public func <- (inout field: Int?, map: Map) {
    field <- map | intTransformation
}

public func <- (inout field: Int!, map: Map) {
    field <- map | intTransformation
}

public func <- (inout field: [Int], map: Map) {
    field <- map | intTransformation
}

public func <- (inout field: [Int]!, map: Map) {
    field <- map | intTransformation
}

public func <- (inout field: [Int]?, map: Map) {
    field <- map | intTransformation
}

public func <- (inout field: [String: Int], map: Map) {
    field <- map | intTransformation
}

public func <- (inout field: [String: Int]!, map: Map) {
    field <- map | intTransformation
}

public func <- (inout field: [String: Int]?, map: Map) {
    field <- map | intTransformation
}