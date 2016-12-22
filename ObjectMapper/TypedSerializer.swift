//
//  TypedSerializer.swift
//  SwiftKit
//
//  Created by Filip Dolnik on 21.12.16.
//  Copyright © 2016 Brightify. All rights reserved.
//

public protocol TypedSerializer: Serializer {
    
    associatedtype DataType
    
    func typedSerialize(_ supportedType: SupportedType) -> DataType
    
    func typedDeserialize(_ data: DataType) -> SupportedType
}
