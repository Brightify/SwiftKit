//
//  BoolMappingOperators.swift
//  Pods
//
//  Created by Tadeas Kriz on 16/07/15.
//
//

import Foundation

// TODO Should we implement arrays and dictionaries with optional/implicitly unwrapped values?
// YES - Bool, Bool!, Bool?,

// YES - [Bool], [Bool]!, [Bool]?,
// NO - [Bool!], [Bool!]!, [Bool!]?,
// NO - [Bool?], [Bool?]!, [Bool?]?,

// YES - [String: Bool], [String: Bool]!, [String: Bool]?
// NO - [String: Bool!], [String: Bool!]!, [String: Bool!]?
// NO - [String: Bool?], [String: Bool?]!, [String: Bool?]?

infix operator <- {}

private let boolTransformation = BoolTransformation()

public func <- (inout field: Bool, map: Map) {
    field <- (map, boolTransformation)
}

public func <- (inout field: Bool?, map: Map) {
    field <- (map, boolTransformation)
}

public func <- (inout field: Bool!, map: Map) {
    field <- (map, boolTransformation)
}

public func <- (inout field: [Bool], map: Map) {
    field <- (map, boolTransformation)
}

public func <- (inout field: [Bool]!, map: Map) {
    field <- (map, boolTransformation)
}

public func <- (inout field: [Bool]?, map: Map) {
    field <- (map, boolTransformation)
}

public func <- (inout field: [String: Bool], map: Map) {
    field <- (map, boolTransformation)
}

public func <- (inout field: [String: Bool]!, map: Map) {
    field <- (map, boolTransformation)
}

public func <- (inout field: [String: Bool]?, map: Map) {
    field <- (map, boolTransformation)
}