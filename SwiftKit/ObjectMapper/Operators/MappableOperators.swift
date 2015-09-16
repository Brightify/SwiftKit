//
//  MappableOperators.swift
//  Pods
//
//  Created by Tadeas Kriz on 16/07/15.
//
//

import Foundation

infix operator <- { }

public func <- <T: Mappable>(inout field: T, map: Map) {
    switch(map.direction) {
    case .FromJSON:
        map.assignObjectTo(&field)
    case .ToJSON:
        map.setObject(field)
    }
}

public func <- <T: Mappable>(inout field: T?, map: Map) {
    switch(map.direction) {
    case .FromJSON:
        map.assignObjectTo(&field)
    case .ToJSON:
        map.setObject(field)
    }
}

public func <- <T: Mappable>(inout field: T!, map: Map) {
    switch(map.direction) {
    case .FromJSON:
        map.assignObjectTo(&field)
    case .ToJSON:
        map.setObject(field)
    }
}

public func <- <T: Mappable>(inout field: [T], map: Map) {
    switch(map.direction) {
    case .FromJSON:
        map.assignObjectArrayTo(&field)
    case .ToJSON:
        map.setObjectArray(field)
    }
}

public func <- <T: Mappable>(inout field: [T]!, map: Map) {
    switch(map.direction) {
    case .FromJSON:
        map.assignObjectArrayTo(&field)
    case .ToJSON:
        map.setObjectArray(field)
    }
}

public func <- <T: Mappable>(inout field: [T]?, map: Map) {
    switch(map.direction) {
    case .FromJSON:
        map.assignObjectArrayTo(&field)
    case .ToJSON:
        map.setObjectArray(field)
    }
}

public func <- <T: Mappable>(inout field: [String: T], map: Map) {
    switch(map.direction) {
    case .FromJSON:
        map.assignObjectDictionaryTo(&field)
    case .ToJSON:
        map.setObjectDictionary(field)
    }
}

public func <- <T: Mappable>(inout field: [String: T]!, map: Map) {
    switch(map.direction) {
    case .FromJSON:
        map.assignObjectDictionaryTo(&field)
    case .ToJSON:
        map.setObjectDictionary(field)
    }
}

public func <- <T: Mappable>(inout field: [String: T]?, map: Map) {
    switch(map.direction) {
    case .FromJSON:
        map.assignObjectDictionaryTo(&field)
    case .ToJSON:
        map.setObjectDictionary(field)
    }
}