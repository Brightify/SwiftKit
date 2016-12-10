//
//  SupportedTypeProtocol.swift
//  SwiftKit
//
//  Created by Filip Dolnik on 10.12.16.
//  Copyright © 2016 Brightify. All rights reserved.
//

/// Protocol used as generic constraint in extensions.
public protocol SupportedTypeProtocol {
    
    var supportedType: SupportedType { get }
}

extension SupportedType: SupportedTypeProtocol {
    
    public var supportedType: SupportedType {
        return self
    }
}
