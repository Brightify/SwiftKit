//
//  RequestEnhancer.swift
//  SwiftKit
//
//  Created by Tadeas Kriz on 27/07/15.
//  Copyright © 2015 Brightify. All rights reserved.
//

import Foundation

public protocol RequestEnhancer {

    var priority: RequestEnhancerPriority { get }
    
    func enhance(request: inout Request)
    
    func deenhance(response: Response<SupportedType>)
}

extension RequestEnhancer {
    
    public var priority: RequestEnhancerPriority {
        return .normal
    }
    
    public func enhance(request: inout Request) {
    }
    
    public func deenhance(response: Response<SupportedType>) {
    }
}
