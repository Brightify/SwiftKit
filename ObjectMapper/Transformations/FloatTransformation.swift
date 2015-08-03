//
// Created by Tadeas Kriz on 18/07/15.
//

import SwiftyJSON

public struct FloatTransformation: Transformation {
    
    public init() { }
    
    public func transformFromJSON(json: JSON) -> Float? {
        return json.float
    }

    public func transformToJSON(object: Float?) -> JSON {
        return JSON(object ?? NSNull())
    }
}
