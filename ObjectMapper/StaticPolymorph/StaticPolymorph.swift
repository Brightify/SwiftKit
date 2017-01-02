//
//  StaticPolymorph.swift
//  SwiftKit
//
//  Created by Filip Dolnik on 28.10.16.
//  Copyright © 2016 Brightify. All rights reserved.
//

public final class StaticPolymorph: Polymorph {
    
    private let dataProvider = PolymorphDataProvider()
    
    public init() {
    }
    
    public func polymorphType<T>(for type: T.Type, in supportedType: SupportedType) -> T.Type {
        if let type = type as? Polymorphic.Type {
            for key in dataProvider.keys(of: type) {
                if let value = supportedType.dictionary?[key]?.string,
                    let polymorphType = dataProvider.polymorphType(of: type, named: value, forKey: key) as? T.Type {
                    return polymorphType
                }
            }
        }
        return type
    }
    
    public func writeTypeInfo<T>(to supportedType: inout SupportedType, of type: T.Type) {
        if let type = type as? Polymorphic.Type {
            let nameAndKey = dataProvider.nameAndKey(of: type)
            supportedType.addToDictionary(key: nameAndKey.key, value: .string(nameAndKey.name))
        }
    }
}
