//
//  InputEncodingWithEncoder.swift
//  SwiftKit
//
//  Created by Filip Dolnik on 05.12.16.
//  Copyright © 2016 Brightify. All rights reserved.
//

public protocol InputEncodingWithEncoder: InputEncoding {
    
    func encode(input: SupportedType, to request: inout Request)
}
