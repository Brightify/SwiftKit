//
//  EnumTransformation.swift
//  SwiftKit
//
//  Created by Tadeas Kriz on 16/07/15.
//  Copyright © 2016 Brightify. All rights reserved.
//

public struct EnumTransformation<T: RawRepresentable>: Transformation {
    
    fileprivate let rawValueTransformation: AnyTransformation<T.RawValue>
    
    public init(rawValueTransformation: AnyTransformation<T.RawValue>) {
        self.rawValueTransformation = rawValueTransformation
    }
    
    public func transform(from value: SupportedType) -> T? {
        return rawValueTransformation.transform(from: value).flatMap(T.init(rawValue:))
    }
    
    public func transform(object: T?) -> SupportedType {
        return rawValueTransformation.transform(object: object?.rawValue)
    }
}

extension EnumTransformation where T.RawValue: SupportedTypeConvertible {
    
    public init() {
        rawValueTransformation = T.RawValue.defaultTransformation
    }
}
