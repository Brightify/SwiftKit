//
//  CustomDateFormatTransformation.swift
//  SwiftKit
//
//  Created by Tadeas Kriz on 16/07/15.
//  Copyright © 2016 Brightify. All rights reserved.
//

import Foundation

public struct CustomDateFormatTransformation: DelegatedTransformation {

    public typealias Object = Date
    
    public let transformationDelegate: AnyTransformation<Date>
    
    public init(formatString: String) {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = formatString
        
        transformationDelegate = DateFormatterTransformation(dateFormatter: formatter).typeErased()
    }
}
