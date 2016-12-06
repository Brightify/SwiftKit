//
//  URLTransformation.swift
//  SwiftKit
//
//  Created by Tadeas Kriz on 16/07/15.
//  Copyright © 2016 Brightify. All rights reserved.
//

import Foundation

public struct URLTransformation: Transformation {
    
    private let useRelative: Bool
    
    public init(useRelative: Bool = false) {
        self.useRelative = useRelative
    }
    
    public func transform(from value: SupportedType) -> URL? {
        return value.string.flatMap(URL.init(string:))
    }
    
    public func transform(object: URL?) -> SupportedType {
        let path = useRelative ? object?.relativePath : object?.absoluteURL.path
        return path.map(SupportedType.string) ?? .null
    }
}
