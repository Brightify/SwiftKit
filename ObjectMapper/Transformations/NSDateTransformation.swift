//
//  NSDateTransform.swift
//  Pods
//
//  Created by Tadeas Kriz on 03/08/15.
//
//

import SwiftyJSON

public struct NSDateTransformation: Transformation {
    
    public init() { }
    
    public func transformFromJSON(json: JSON) -> NSDate? {
        if let timeInt = json.double {
            return NSDate(timeIntervalSince1970: NSTimeInterval())
        }
        return nil
    }
    
    public func transformToJSON(object: NSDate?) -> JSON {
        return JSON(object?.timeIntervalSince1970 ?? NSNull())
    }
    
}