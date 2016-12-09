//
//  ErrorHandler.swift
//  SwiftKit
//
//  Created by Filip Dolnik on 08.12.16.
//  Copyright © 2016 Brightify. All rights reserved.
//

import Foundation

open class ErrorHandler {
    
    public let responseVerifier: ResponseVerifier
    public let resolveError: (Response<SupportedType>) -> Bool
    
    public init(responseVerifier: ResponseVerifier = StatusCodeRangeVerifier(range: 200...299), resolveError: @escaping (Response<SupportedType>) -> Bool = ErrorHandler.resolveError) {
        self.responseVerifier = responseVerifier
        self.resolveError = resolveError
    }
    
    open func shouldCallCallback(response: Response<SupportedType>) -> Bool {
        if responseVerifier.verify(response: response) {
            return true
        } else {
            return resolveError(response)
        }
    }
    
    open static func resolveError(response: Response<SupportedType>) -> Bool {
        var failed = false
        response.retry(max: 3) {
            failed = true
        }
        // Do not call callback if retry will call everything again.
        return failed
    }
}
