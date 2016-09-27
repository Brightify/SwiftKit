//
//  NSDateTransform.swift
//  Pods
//
//  Created by Tadeas Kriz on 03/08/15.
//
//

import SwiftyJSON

public struct DateTransformation: Transformation {
    
    public init() { }
    
    public func transformFromJSON(_ json: JSON) -> Date? {
        if let timeInt = json.double {
            return Date(timeIntervalSince1970: TimeInterval(timeInt))
        }
        return nil
    }
    
    public func transformToJSON(_ object: Date?) -> JSON {
        return JSON(object.map { NSNumber(value: $0.timeIntervalSince1970) } ?? NSNull())
    }
    
}
