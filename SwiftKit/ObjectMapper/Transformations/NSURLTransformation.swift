//
//  NSURLTransformation.swift
//  Pods
//
//  Created by Tadeas Kriz on 03/08/15.
//
//

import SwiftyJSON

public struct NSURLTransformation: Transformation {
    
    public init() { }
    
    public func transformFromJSON(_ json: JSON) -> NSURL? {
        return json.URL
    }
    
    public func transformToJSON(_ object: NSURL?) -> JSON {
        return JSON(object ?? NSNull())
    }
    
}
