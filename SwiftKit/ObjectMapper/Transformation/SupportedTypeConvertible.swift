//
//  SupportedTypeConvertible.swift
//  SwiftKit
//
//  Created by Filip Dolnik on 21.10.16.
//  Copyright © 2016 Tadeas Kriz. All rights reserved.
//

public protocol SupportedTypeConvertible {
    
    static var defaultTransformation: AnyTransformation<Self> { get }
}
