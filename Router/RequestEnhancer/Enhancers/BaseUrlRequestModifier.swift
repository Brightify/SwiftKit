//
//  BaseUrlRequestModifier.swift
//  SwiftKit
//
//  Created by Filip Dolnik on 22.12.16.
//  Copyright © 2016 Brightify. All rights reserved.
//

import Foundation

public struct BaseUrlRequestModifier: RequestModifier {

    public static let Ignore = BaseUrlRequestModifier(baseUrl: nil, priority: .max)
    
    internal let baseUrl: String?
    internal let priority: RequestEnhancerPriority
    
    public init(baseUrl: String?, priority: RequestEnhancerPriority = .normal) {
        self.baseUrl = baseUrl
        self.priority = priority
    }
}

