//
// Created by Tadeas Kriz on 18/07/15.
//

import SwiftyJSON

public struct IntTransformation: Transformation {
    
    public init() { }
    
    public func transformFromJSON(_ json: JSON) -> Int? {
        return json.int
    }

    public func transformToJSON(_ object: Int?) -> JSON {
        return JSON(object.map(NSNumber.init(value:)) ?? NSNull())
    }
}

