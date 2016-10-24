//
//  Serializable.swift
//  SwiftKit
//
//  Created by Filip Dolnik on 23.10.16.
//  Copyright © 2016 Brightify. All rights reserved.
//

public protocol Serializable {
    
    func serialize(to data: SerializableData)
}

extension Serializable {
    
    internal func serialized() -> SupportedType {
        var result = SupportedType.dictionary([:])
        serialize(to: SerializableData(data: &result))
        return result
    }
}
