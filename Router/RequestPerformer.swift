//
//  RequestPerformer.swift
//  SwiftKit
//
//  Created by Tadeas Kriz on 28/07/15.
//  Copyright © 2015 Brightify. All rights reserved.
//

import Foundation

public protocol RequestPerformer {
    
    var implicitEnchancers: [RequestEnhancer] { get }
    
    var implicitModifiers: [RequestModifier] { get }
    
    var inputEncoder: InputEncoder { get }
    
    func perform(request: Request, completion: @escaping (Response<SupportedType>) -> ()) -> Cancellable
}

extension RequestPerformer {
    
    public var implicitEnchancers: [RequestEnhancer] {
        return []
    }
    
    public var implicitModifiers: [RequestModifier] {
        return []
    }
}
