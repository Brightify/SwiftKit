//
//  RequestTimeOutErrorHandler.swift
//  SwiftKit
//
//  Created by Filip Dolnik on 10.12.16.
//  Copyright © 2016 Brightify. All rights reserved.
//

import Foundation

public final class RequestTimeOutErrorHandler: BaseStatusCodeErrorHandler {
    
    private let maxRepetitions: Int
    private let delay: DispatchTimeInterval
    
    public init(maxRepetitions: Int = 3, delay: DispatchTimeInterval = .seconds(0)) {
        self.maxRepetitions = maxRepetitions
        self.delay = delay
        
        super.init(code: 408)
    }
    
    public override func resolveError(response: Response<SupportedType>, callback: (Response<SupportedType>) -> Void) {
        response.request.retry(max: maxRepetitions, delay: delay) { callback(response) }
    }
}
    
