//
//  TransformationOperators.swift
//  Pods
//
//  Created by Tadeas Kriz on 16/07/15.
//
//

import Foundation

infix operator <- { }

public func <- <T, Transform: Transformation where Transform.Object == T>(inout field: T, right: (Map, Transform)) {
    let map = right.0
    let transformation = right.1
    
    switch(map.direction) {
    case .FromJSON:
        map.assignValueTo(&field, transformWith: transformation)
    case .ToJSON:
        map.setValue(field, transformWith: transformation)
    }
}

public func <- <T, Transform: Transformation where Transform.Object == T>(inout field: T!, right: (Map, Transform)) {
    let map = right.0
    let transformation = right.1
    
    switch(map.direction) {
    case .FromJSON:
        map.assignValueTo(&field, transformWith: transformation)
    case .ToJSON:
        map.setValue(field, transformWith: transformation)
    }
}

public func <- <T, Transform: Transformation where Transform.Object == T>(inout field: T?, right: (Map, Transform)) {
    let map = right.0
    let transformation = right.1
    
    switch(map.direction) {
    case .FromJSON:
        map.assignValueTo(&field, transformWith: transformation)
    case .ToJSON:
        map.setValue(field, transformWith: transformation)
    }
}

public func <- <T, Transform: Transformation where Transform.Object == T>(inout field: [T], right: (Map, Transform)) {
    let map = right.0
    let transformation = right.1
    
    switch(map.direction) {
    case .FromJSON:
        map.assignValueArrayTo(&field, transformWith: transformation)
    case .ToJSON:
        map.setValueArray(field, transformWith: transformation)
    }
}

public func <- <T, Transform: Transformation where Transform.Object == T>(inout field: [T]!, right: (Map, Transform)) {
    let map = right.0
    let transformation = right.1
    
    switch(map.direction) {
    case .FromJSON:
        map.assignValueArrayTo(&field, transformWith: transformation)
    case .ToJSON:
        map.setValueArray(field, transformWith: transformation)
    }
}

public func <- <T, Transform: Transformation where Transform.Object == T>(inout field: [T]?, right: (Map, Transform)) {
    let map = right.0
    let transformation = right.1
    
    switch(map.direction) {
    case .FromJSON:
        map.assignValueArrayTo(&field, transformWith: transformation)
    case .ToJSON:
        map.setValueArray(field, transformWith: transformation)
    }
}

public func <- <T, Transform: Transformation where Transform.Object == T>(inout field: [String: T], right: (Map, Transform)) {
    let map = right.0
    let transformation = right.1
    
    switch(map.direction) {
    case .FromJSON:
        map.assignValueDictionaryTo(&field, transformWith: transformation)
    case .ToJSON:
        map.setValueDictionary(field, transformWith: transformation)
    }
}

public func <- <T, Transform: Transformation where Transform.Object == T>(inout field: [String: T]!, right: (Map, Transform)) {
    let map = right.0
    let transformation = right.1
    
    switch(map.direction) {
    case .FromJSON:
        map.assignValueDictionaryTo(&field, transformWith: transformation)
    case .ToJSON:
        map.setValueDictionary(field, transformWith: transformation)
    }
}

public func <- <T, Transform: Transformation where Transform.Object == T>(inout field: [String: T]?, right: (Map, Transform)) {
    let map = right.0
    let transformation = right.1
    
    switch(map.direction) {
    case .FromJSON:
        map.assignValueDictionaryTo(&field, transformWith: transformation)
    case .ToJSON:
        map.setValueDictionary(field, transformWith: transformation)
    }
}