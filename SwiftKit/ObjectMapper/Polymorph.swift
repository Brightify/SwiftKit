//
//  Polymorph.swift
//  SwiftKit
//
//  Created by Filip Dolnik on 28.10.16.
//  Copyright © 2016 Brightify. All rights reserved.
//

public protocol Polymorph {
    
    func polymorphType<T: Deserializable>(for type: T.Type, in supportedType: SupportedType) -> T.Type
    
    func writeTypeInfo<T: Serializable>(to supportedType: inout SupportedType, of type: T.Type)
}
