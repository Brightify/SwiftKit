//
//  RequestEnhancer.swift
//  Pods
//
//  Created by Tadeas Kriz on 27/07/15.
//
//

import Foundation

public let DEFAULT_ENHANCER_PRIORITY: Int = 0

public protocol RequestEnhancer {

    var priority: Int { get }
    
    func canEnhance(request: Request) -> Bool
    
    func enhanceRequest(inout request: Request)
    
    func deenhanceResponse(response: Response<NSData?>) -> Response<NSData?>
    
}