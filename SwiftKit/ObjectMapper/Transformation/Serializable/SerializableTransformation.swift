//
//  SerializableTransformation.swift
//  SwiftKit
//
//  Created by Filip Dolnik on 23.10.16.
//  Copyright © 2016 Brightify. All rights reserved.
//

public protocol SerializableTransformation {
    
    associatedtype Object
    
    func transform(object: Object?) -> SupportedType
}
