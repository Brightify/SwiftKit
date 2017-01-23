//
//  DeserializationError.swift
//  SwiftKit
//
//  Created by Filip Dolnik on 30.10.16.
//  Copyright © 2016 Brightify. All rights reserved.
//

public enum DeserializationError: Error {
    
    case wrongType(type: SupportedType)
}
