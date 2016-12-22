//
//  BaseUrlRequestEnhancer.swift
//  SwiftKit
//
//  Created by Filip Dolnik on 21.12.16.
//  Copyright © 2016 Brightify. All rights reserved.
//

import Foundation

internal struct BaseUrlRequestEnhancer: RequestEnhancer {
    
    internal let priority = RequestEnhancerPriority.max
    
    internal func enhance(request: inout Request) {
        let modifier = request.modifiers.flatMap { $0 as? BaseUrlRequestModifier }.sorted { $0.priority.value > $1.priority.value }.first
        if let url = request.url, var baseUrl = modifier?.baseUrl {

            var component = url.absoluteString
            if component[component.startIndex] == "/" {
                component = component.substring(from: component.index(after: component.startIndex))
            }
            
            if baseUrl[baseUrl.index(before: baseUrl.endIndex)] == "/" {
                baseUrl = baseUrl.substring(to: baseUrl.index(before: baseUrl.endIndex))
            }
            
            request.url = URL(string: baseUrl + "/" + component)
        }
    }
}
