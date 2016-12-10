//
//  CompositeErrorHandler.swift
//  SwiftKit
//
//  Created by Filip Dolnik on 10.12.16.
//  Copyright © 2016 Brightify. All rights reserved.
//

public struct CompositeErrorHandler: ErrorHandler {
    
    private let handlers: [ErrorHandler]
    
    public init(handlers: [ErrorHandler]) {
        self.handlers = handlers
    }
    
    public init(handlers: ErrorHandler...) {
        self.init(handlers: handlers)
    }
    
    public func canResolveError(response: Response<SupportedType>) -> Bool {
        return handlers.reduce(false) { $0 || $1.canResolveError(response: response) }
    }
    
    public func resolveError(response: Response<SupportedType>, callback: (Response<SupportedType>) -> Void) {
        for handler in handlers {
            if handler.canResolveError(response: response) {
                handler.resolveError(response: response, callback: callback)
                return
            }
        }
    }
}
