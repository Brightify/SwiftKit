//
//  DateFormatterTransformation.swift
//  Pods
//
//  Created by Tadeas Kriz on 03/08/15.
//
//

import SwiftyJSON

public class NSDateFormatterTransformation: Transformation {
    
    private let dateFormatter: NSDateFormatter
    
    public init(dateFormatter: NSDateFormatter) {
        self.dateFormatter = dateFormatter
    }
    
    public func transformFromJSON(json: JSON) -> NSDate? {
        if let dateString = json.string {
            return dateFormatter.dateFromString(dateString)
        }
        return nil
    }
    
    public func transformToJSON(object: NSDate?) -> JSON {
        if let date = object {
            return JSON(dateFormatter.stringFromDate(date))
        }
        return JSON(NSNull())
    }
    
}
