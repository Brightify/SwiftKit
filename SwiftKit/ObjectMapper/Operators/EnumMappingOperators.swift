//
//  EnumMappingOperators.swift
//  Pods
//
//  Created by Tadeas Kriz on 16/07/15.
//
//

import Foundation

infix operator <- {}

public func <- <T: RawRepresentable>(inout field: T, map: Map) {
    field <- (map, EnumTransformation())
}

public func <- <T: RawRepresentable>(inout field: T?, map: Map) {
    field <- (map, EnumTransformation())
}

public func <- <T: RawRepresentable>(inout field: T!, map: Map) {
    field <- (map, EnumTransformation())
}

public func <- <T: RawRepresentable>(inout field: [T], map: Map) {
    field <- (map, EnumTransformation())
}

public func <- <T: RawRepresentable>(inout field: [T]?, map: Map) {
    field <- (map, EnumTransformation())
}

public func <- <T: RawRepresentable>(inout field: [T]!, map: Map) {
    field <- (map, EnumTransformation())
}

public func <- <T: RawRepresentable>(inout field: [String: T], map: Map) {
    field <- (map, EnumTransformation())
}

public func <- <T: RawRepresentable>(inout field: [String: T]?, map: Map) {
    field <- (map, EnumTransformation())
}

public func <- <T: RawRepresentable>(inout field: [String: T]!, map: Map) {
    field <- (map, EnumTransformation())
}