//
//  Serializer.swift
//  SwiftKit
//
//  Created by Filip Dolnik on 28.10.16.
//  Copyright © 2016 Brightify. All rights reserved.
//

public protocol Serializer {
    
    func serialize(_ supportedType: SupportedType) -> NSData
    
    func deserialize(_ data: NSData) -> SupportedType
}
