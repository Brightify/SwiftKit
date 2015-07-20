//
//  DoubleMappingOperators.swift
//  Pods
//
//  Created by Tadeas Kriz on 16/07/15.
//
//

import Foundation

infix operator <- {}

private let doubleTransformation = DoubleTransformation()

public func <- (inout field: Double, map: Map) {
    field <- (map, doubleTransformation)
}

public func <- (inout field: Double?, map: Map) {
    field <- (map, doubleTransformation)
}

public func <- (inout field: Double!, map: Map) {
    field <- (map, doubleTransformation)
}

public func <- (inout field: [Double], map: Map) {
    field <- (map, doubleTransformation)
}

public func <- (inout field: [Double]!, map: Map) {
    field <- (map, doubleTransformation)
}

public func <- (inout field: [Double]?, map: Map) {
    field <- (map, doubleTransformation)
}

public func <- (inout field: [String: Double], map: Map) {
    field <- (map, doubleTransformation)
}

public func <- (inout field: [String: Double]!, map: Map) {
    field <- (map, doubleTransformation)
}

public func <- (inout field: [String: Double]?, map: Map) {
    field <- (map, doubleTransformation)
}