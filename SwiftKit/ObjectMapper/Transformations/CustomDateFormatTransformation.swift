//
//  CustomDateFormatTransformation.swift
//  Pods
//
//  Created by Tadeas Kriz on 03/08/15.
//
//

import SwiftyJSON

open class CustomDateFormatTransformation: NSDateFormatterTransformation {
    
    public init(formatString: String) {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = formatString
        
        super.init(dateFormatter: formatter)
    }
    
}
