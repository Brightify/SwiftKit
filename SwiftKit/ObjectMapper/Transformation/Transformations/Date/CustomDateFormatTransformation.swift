//
//  CustomDateFormatTransformation.swift
//  SwiftKit
//
//  Created by Tadeas Kriz on 16/07/15.
//  Copyright © 2016 Tadeas Kriz. All rights reserved.
//

public struct CustomDateFormatTransformation: DelegatedTransformation {

    public typealias Object = Date
    
    public let delegate: AnyTransformation<Date>
    
    public init(formatString: String) {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = formatString
        
        delegate = DateFormatterTransformation(dateFormatter: formatter).typeErased()
    }
}
