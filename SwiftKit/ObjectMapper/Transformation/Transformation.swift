//
//  Transformation.swift
//  SwiftKit
//
//  Created by Tadeas Kriz on 16/07/15.
//  Copyright © 2016 Tadeas Kriz. All rights reserved.
//

public protocol Transformation {
    
    associatedtype Object

    func transform(from value: SupportedType) -> Object?
    
    func transform(object: Object?) -> SupportedType
}
