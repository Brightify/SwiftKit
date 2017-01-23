//
//  DictionaryUtils.swift
//  SwiftKit
//
//  Created by Filip Dolnik on 28.10.16.
//  Copyright © 2016 Brightify. All rights reserved.
//

extension Dictionary {
    
    internal func mapValue<V>(_ transform: (Value) -> V) -> [Key: V] {
        var output: [Key: V] = [:]
        for (key, value) in self {
            output[key] = transform(value)
        }
        return output
    }
    
    internal func flatMapValue<V>(_ transform: (Value) -> V?) -> [Key: V] {
        var output: [Key: V] = [:]
        for (key, value) in self {
            if let newValue = transform(value) {
                output[key] = newValue
            }
        }
        return output
    }
}
