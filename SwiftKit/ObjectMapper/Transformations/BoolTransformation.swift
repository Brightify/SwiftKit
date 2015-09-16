//
// Created by Tadeas Kriz on 18/07/15.
//

import SwiftyJSON

public struct BoolTransformation: Transformation {

    public init() { }
    
    public func transformFromJSON(json: JSON) -> Bool? {
        return json.bool
    }

    public func transformToJSON(object: Bool?) -> JSON {
        return JSON(object ?? NSNull())
    }

}
