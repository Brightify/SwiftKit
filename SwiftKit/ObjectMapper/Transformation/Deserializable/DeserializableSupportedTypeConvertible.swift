//
//  DeserializableSupportedTypeConvertible.swift
//  SwiftKit
//
//  Created by Filip Dolnik on 21.10.16.
//  Copyright © 2016 Brightify. All rights reserved.
//

public protocol DeserializableSupportedTypeConvertible {
    
    static var defaultDeserializableTransformation: AnyDeserializableTransformation<Self> { get }
}
