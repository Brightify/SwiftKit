//
//  SupportedType.swift
//  SwiftKit
//
//  Created by Filip Dolnik on 20.10.16.
//  Copyright © 2016 Brightify. All rights reserved.
//

public enum SupportedType {
    
    case null
    case string(String)
    case int(Int)
    case double(Double)
    case bool(Bool)
    indirect case array([SupportedType])
    indirect case dictionary([String: SupportedType])
}

extension SupportedType {
    
    public var isNull: Bool {
        if case .null = self {
            return true
        } else {
            return false
        }
    }
    
    public var string: String? {
        if case .string(let value) = self {
            return value
        } else {
            return nil
        }
    }
    
    public var int: Int? {
        if case .int(let value) = self {
            return value
        } else {
            return nil
        }
    }
    
    public var double: Double? {
        if case .double(let value) = self {
            return value
        } else {
            return nil
        }
    }
    
    public var bool: Bool? {
        if case .bool(let value) = self {
            return value
        } else {
            return nil
        }
    }
    
    public var array: [SupportedType]? {
        if case .array(let value) = self {
            return value
        } else {
            return nil
        }
    }
    
    public var dictionary: [String: SupportedType]? {
        if case .dictionary(let value) = self {
            return value
        } else {
            return nil
        }
    }
}

extension SupportedType {
    
    public mutating func addToDictionary(key: String, value: SupportedType) {
        var mutableDictionary = dictionary ?? [:]
        mutableDictionary[key] = value
        self = .dictionary(mutableDictionary)
    }
}
