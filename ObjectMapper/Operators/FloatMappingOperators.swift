//
//  FloatMappingOperators.swift
//  Pods
//
//  Created by Tadeas Kriz on 16/07/15.
//
//

import Foundation

infix operator <- {}

private let floatTransformation = FloatTransformation()

public func <- (inout field: Float, map: Map) {
    field <- map | floatTransformation
}

public func <- (inout field: Float?, map: Map) {
    field <- map | floatTransformation
}

public func <- (inout field: Float!, map: Map) {
    field <- map | floatTransformation
}

public func <- (inout field: [Float], map: Map) {
    field <- map | floatTransformation
}

public func <- (inout field: [Float]!, map: Map) {
    field <- map | floatTransformation
}

public func <- (inout field: [Float]?, map: Map) {
    field <- map | floatTransformation
}

public func <- (inout field: [String: Float], map: Map) {
    field <- map | floatTransformation
}

public func <- (inout field: [String: Float]!, map: Map) {
    field <- map | floatTransformation
}

public func <- (inout field: [String: Float]?, map: Map) {
    field <- map | floatTransformation
}