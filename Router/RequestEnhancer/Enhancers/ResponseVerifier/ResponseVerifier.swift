//
//  ResponseVerifier.swift
//  SwiftKit
//
//  Created by Tadeas Kriz on 14/07/15.
//  Copyright © 2015 Brightify. All rights reserved.
//

public protocol ResponseVerifier: RequestEnhancer {

    func verify(response: Response<SupportedType>) -> RouterError?
}

extension ResponseVerifier {
    
    public var priority: RequestEnhancerPriority {
        return .max
    }
    
    public func deenhance(response: inout Response<SupportedType>) {
        if let error = verify(response: response) {
            response = response.flatMap { _ in .failure(error) }
        }
    }
}
