//
//  HeaderRequestEnhancer.swift
//  SwiftKit
//
//  Created by Filip Dolnik on 04.12.16.
//  Copyright © 2016 Brightify. All rights reserved.
//

internal struct HeaderRequestEnhancer: RequestEnhancer {
    
    internal func enhance(request: inout Request) {
        request.modifiers.flatMap { $0 as? Header }.forEach { request.addHeader($0) }
    }
}
