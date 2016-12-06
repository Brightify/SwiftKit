//
//  Serializer.swift
//  SwiftKit
//
//  Created by Filip Dolnik on 28.10.16.
//  Copyright © 2016 Brightify. All rights reserved.
//

import Foundation

public protocol Serializer {
    
    func serialize(_ supportedType: SupportedType) -> Data
    
    func deserialize(_ data: Data) -> SupportedType
}
