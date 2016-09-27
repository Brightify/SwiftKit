//
// Created by Tadeas Kriz on 18/07/15.
//

import SwiftyJSON

public struct DoubleTransformation: Transformation {

    public init() { }
    
    public func transformFromJSON(_ json: JSON) -> Double? {
        return json.double
    }

    public func transformToJSON(_ object: Double?) -> JSON {
        return JSON(object.map(NSNumber.init(value:)) ?? NSNull())
    }
}
