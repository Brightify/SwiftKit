//
//  Polymorphic.swift
//  SwiftKit
//
//  Created by Filip Dolnik on 25.10.16.
//  Copyright © 2016 Brightify. All rights reserved.
//

public protocol Polymorphic {
    
    static var polymorphicKey: String { get }
    
    static var polymorphicInfo: PolymorphicInfo { get }
}

extension Polymorphic {
    
    internal static var defaultName: String {
        return String(describing: self)
    }
    
    public static func createPolymorphicInfo() -> GenericPolymorphicInfo<Self> {
        return GenericPolymorphicInfo(name: defaultName)
    }
    
    public static func createPolymorphicInfo(name: String) -> GenericPolymorphicInfo<Self> {
        return GenericPolymorphicInfo(name: name)
    }
}
