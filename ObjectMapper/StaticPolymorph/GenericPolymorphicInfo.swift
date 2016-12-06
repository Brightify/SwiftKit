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
        precondition(subtype != T.self, "Cannot register self.")
        registeredSubtypes.append(subtype)
    }
}

extension GenericPolymorphicInfo {
    
    public func with(subtype: T.Type) -> GenericPolymorphicInfo<T> {
        var mutableCopy = self
        mutableCopy.register(subtype: subtype)
        return mutableCopy
    }
}
