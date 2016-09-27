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
    
    func enhance(request: inout Request)
    
    func deenhance(response: Response<Data?>) -> Response<Data?>
    
}
