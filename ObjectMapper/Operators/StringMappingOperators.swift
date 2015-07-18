//
//  StringMappingOperators.swift
//  Pods
//
//  Created by Tadeas Kriz on 16/07/15.
//
//

import Foundation

infix operator <- {}

private let stringTransformation = StringTransformation()

public func <- (inout field: String, map: Map) {
    field <- map | stringTransformation
}

public func <- (inout field: String?, map: Map) {
    field <- map | stringTransformation
}

public func <- (inout field: String!, map: Map) {
    field <- map | stringTransformation
}

public func <- (inout field: [String], map: Map) {
    field <- map | stringTransformation
}

public func <- (inout field: [String]!, map: Map) {
    field <- map | stringTransformation
}

public func <- (inout field: [String]?, map: Map) {
    field <- map | stringTransformation
}

public func <- (inout field: [String: String], map: Map) {
    field <- map | stringTransformation
}

public func <- (inout field: [String: String]!, map: Map) {
    field <- map | stringTransformation
}

public func <- (inout field: [String: String]?, map: Map) {
    field <- map | stringTransformation
}