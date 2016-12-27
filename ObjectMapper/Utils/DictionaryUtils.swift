//
//  DictionaryUtils.swift
//  SwiftKit
//
//  Created by Filip Dolnik on 28.10.16.
//  Copyright © 2016 Brightify. All rights reserved.
//

extension Dictionary {
    
    public func mapValue<V>(_ transform: (Value) -> V) -> [Key: V] {
        var output: [Key: V] = [:]
        for (key, value) in self {
            output[key] = transform(value)
        }
        return output
    }
}
