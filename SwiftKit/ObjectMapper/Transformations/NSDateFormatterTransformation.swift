//
//  DateFormatterTransformation.swift
//  Pods
//
//  Created by Tadeas Kriz on 03/08/15.
//
//

import SwiftyJSON

open class NSDateFormatterTransformation: Transformation {
    
    fileprivate let dateFormatter: DateFormatter
    
    public init(dateFormatter: DateFormatter) {
        self.dateFormatter = dateFormatter
    }
    
    open func transformFromJSON(_ json: JSON) -> Date? {
        if let dateString = json.string {
            return dateFormatter.date(from: dateString)
        }
        return nil
    }
    
    open func transformToJSON(_ object: Date?) -> JSON {
        if let date = object {
            return JSON(dateFormatter.string(from: date))
        }
        return JSON(NSNull())
    }
    
}
