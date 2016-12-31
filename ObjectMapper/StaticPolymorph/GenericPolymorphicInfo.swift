//
//  GenericPolymorphicInfo.swift
//  SwiftKit
//
//  Created by Filip Dolnik on 26.10.16.
//  Copyright © 2016 Brightify. All rights reserved.
//

public struct GenericPolymorphicInfo<T: Polymorphic>: PolymorphicInfo {
    
    public let type: Polymorphic.Type = T.self
    public let name: String
    public private(set) var registeredSubtypes: [Polymorphic.Type] = []
    
    internal init(name: String) {
        self.name = name
    }
    
    public mutating func register(subtype: T.Type) {
        register(subtypes: subtype)
    }
    
    public mutating func register(subtypes: T.Type...) {
        register(subtypes: subtypes)
    }
    
    public mutating func register(subtypes: [T.Type]) {
        for subtype in subtypes {
            precondition(subtype != T.self, "Cannot register self.")
            registeredSubtypes.append(subtype)
        }
    }
}

extension GenericPolymorphicInfo {
    
    public func with(subtype: T.Type) -> GenericPolymorphicInfo<T> {
        var mutableCopy = self
        mutableCopy.register(subtype: subtype)
        return mutableCopy
    }
    
    public func with(subtypes: T.Type...) -> GenericPolymorphicInfo<T> {
        var mutableCopy = self
        mutableCopy.register(subtypes: subtypes)
        return mutableCopy
    }
    
    public func with(subtypes: [T.Type]) -> GenericPolymorphicInfo<T> {
        var mutableCopy = self
        mutableCopy.register(subtypes: subtypes)
        return mutableCopy
    }
}
