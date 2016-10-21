//
//  URLTransformation.swift
//  SwiftKit
//
//  Created by Tadeas Kriz on 16/07/15.
//  Copyright © 2016 Tadeas Kriz. All rights reserved.
//

public struct URLTransformation: Transformation {
    
    public init() {
    }
    
    public func transform(from value: SupportedType) -> URL? {
        return value.string.flatMap(URL.init(string:))
    }
    
    public func transform(object: URL?) -> SupportedType {
        return (object?.relativePath).map(SupportedType.string) ?? .null
    }
}
