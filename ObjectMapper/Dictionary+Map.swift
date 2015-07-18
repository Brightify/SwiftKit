//
//  Dictionary+Map.swift
//  Pods
//
//  Created by Tadeas Kriz on 17/07/15.
//
//

extension Dictionary {
    func map<V>(transform: Value -> V) -> [Key: V] {
        var output: [Key: V] = [:]
        for (key, value) in self {
            var newValue = transform(value)
            output[key] = newValue
        }
        return output
    }

    func map<K: Hashable, V>(transform: (Key, Value) -> (K, V)) -> [K: V] {
        var output: [K: V] = [:]
        for (key, value) in self {
            var newElement = transform(key, value)
            output[newElement.0] = newElement.1
        }
        return output
    }
}