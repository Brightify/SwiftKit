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
    
    func canEnhance(request: Request, modifier: RequestModifier) -> Bool
    
    func enhanceRequest(inout request: Request, modifier: RequestModifier)
    
    func deenhanceResponse(response: Response<NSData?>, modifier: RequestModifier) -> Response<NSData?>
    
}