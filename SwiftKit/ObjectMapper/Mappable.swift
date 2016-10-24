//
//  Mappable.swift
//  SwiftKit
//
//  Created by Filip Dolnik on 21.10.16.
//  Copyright © 2016 Brightify. All rights reserved.
//

public protocol Mappable: Serializable, Deserializable {
    
    mutating func mapping(_ data: MappableData)
}

extension Mappable {
    
    public func serialize(to data: SerializableData) {
        mapping(data)
    }
}

extension Mappable {
    
    public mutating func mapping(_ data: DeserializableData) {
        mapping(DeserializableMappableDataWrapper(delegate: data))
    }
    
    public func mapping(_ data: SerializableData) {
        var mutableSelf = self
        mutableSelf.mapping(SerializableMappableDataWrapper(delegate: data))
    }
}
