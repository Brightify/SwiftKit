//
//  URL+appendingPathComponentWithoutSlash.swift
//  SwiftKit
//
//  Created by Tadeas Kriz on 27/07/15.
//  Copyright © 2015 Brightify. All rights reserved.
//

import Foundation

extension URL {
    
    public func appendingPathComponentWithoutSlash(_ pathComponent: String) -> URL {
        guard !pathComponent.isEmpty else { return self }
        
        var component = pathComponent
        if component[component.startIndex] == "/" {
            component = component.substring(from: component.index(after: component.startIndex))
            
        }
        return appendingPathComponent(component)
    }
}
