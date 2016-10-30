//
//  Deserializable.swift
//  SwiftKit
//
//  Created by Filip Dolnik on 23.10.16.
//  Copyright © 2016 Brightify. All rights reserved.
//

public protocol Deserializable {
    
    init(_ data: DeserializableData) throws
}
