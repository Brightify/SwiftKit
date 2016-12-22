//
//  BaseUrlRequestEnhancer.swift
//  SwiftKit
//
//  Created by Filip Dolnik on 21.12.16.
//  Copyright © 2016 Brightify. All rights reserved.
//

import Foundation

public struct BaseUrlRequestEnhancer: RequestEnhancer {
    
    public let priority = RequestEnhancerPriority.max
    
    private let baseUrl: URL
    
    public init(baseUrl: String) {
        guard let url = URL(string: baseUrl) else {
            preconditionFailure("\(baseUrl) doesn`t resolve to valid url.")
        }
        self.baseUrl = url
    }
    
    public func enhance(request: inout Request) {
        if let url = request.url {
            request.url = baseUrl.appendingPathComponentWithoutSlash(url.relativeString)
        }
    }
}

fileprivate extension URL {
    
    fileprivate func appendingPathComponentWithoutSlash(_ pathComponent: String) -> URL {
        guard !pathComponent.isEmpty else { return self }
        
        var component = pathComponent
        if component[component.startIndex] == "/" {
            component = component.substring(from: component.index(after: component.startIndex))
            
        }
        return appendingPathComponent(component)
    }
}
