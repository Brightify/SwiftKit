//
// Created by Tadeas Kriz on 18/07/15.
//

import SwiftyJSON

public struct NSNumberTransformation: Transformation {
    
    public init() { }
    
    public func transformFromJSON(json: JSON) -> NSNumber? {
        return json.number
    }

    public func transformToJSON(object: NSNumber?) -> JSON {
        return JSON(object ?? NSNull())
    }
}