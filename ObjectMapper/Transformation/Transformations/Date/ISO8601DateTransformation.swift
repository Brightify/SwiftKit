//
//  ISO8601DateTransformation.swift
//  SwiftKit
//
//  Created by Tadeas Kriz on 16/07/15.
//  Copyright © 2016 Brightify. All rights reserved.
//

import Foundation

public struct ISO8601DateTransformation: DelegatedTransformation {

    public typealias Object = Date
    
    public let transformationDelegate = CustomDateFormatTransformation(formatString: "yyyy-MM-dd'T'HH:mm:ssZZZZZ").typeErased()
    
    public init() {
    }
}
