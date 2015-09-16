//
//  CustomDateFormatTransformation.swift
//  Pods
//
//  Created by Tadeas Kriz on 03/08/15.
//
//

import SwiftyJSON

public class CustomDateFormatTransformation: NSDateFormatterTransformation {
    
    public init(formatString: String) {
        let formatter = NSDateFormatter()
        formatter.locale = NSLocale(localeIdentifier: "en_US_POSIX")
        formatter.dateFormat = formatString
        
        super.init(dateFormatter: formatter)
    }
    
}