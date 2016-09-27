//
//  EnumTransformation.swift
//  Pods
//
//  Created by Tadeas Kriz on 17/07/15.
//
//

import Foundation
import SwiftyJSON

public struct EnumTransformation<T: RawRepresentable>: Transformation {
    
    public init() { }
    
    public func transformFromJSON(_ json: JSON) -> T? {
        if let rawValue = json.object as? T.RawValue {
            return T(rawValue: rawValue)
        }
        return nil
    }
    
    public func transformToJSON(_ object: T?) -> JSON {
        let value: AnyObject = object?.rawValue as? AnyObject ?? NSNull()
        return JSON(value)
    }
}
