//
// Created by Tadeas Kriz on 18/07/15.
//

import SwiftyJSON

public struct DoubleTransformation: Transformation {

    public init() { }
    
    public func transformFromJSON(json: JSON) -> Double? {
        return json.double
    }

    public func transformToJSON(object: Double?) -> JSON {
        return JSON(object ?? NSNull())
    }
}
