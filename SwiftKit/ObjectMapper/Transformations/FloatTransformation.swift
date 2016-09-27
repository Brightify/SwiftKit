//
// Created by Tadeas Kriz on 18/07/15.
//

import SwiftyJSON

public struct FloatTransformation: Transformation {
    
    public init() { }
    
    public func transformFromJSON(_ json: JSON) -> Float? {
        return json.float
    }

    public func transformToJSON(_ object: Float?) -> JSON {
        return JSON(object.map(NSNumber.init(value:)) ?? NSNull())
    }
}
