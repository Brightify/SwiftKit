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
    
    public func transformFromJSON(_ json: JSON) -> URL? {
        return json.URL
    }
    
    public func transformToJSON(_ object: URL?) -> JSON {
        if let url = object {
            return JSON(url)
        } else {
            return JSON(NSNull())
        }
    }
    
}
