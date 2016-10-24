//
//  DeserializableTransformation.swift
//  SwiftKit
//
//  Created by Filip Dolnik on 23.10.16.
//  Copyright © 2016 Brightify. All rights reserved.
//

public protocol DeserializableTransformation {
    
    associatedtype Object
    
    func transform(from value: SupportedType) -> Object?
}
