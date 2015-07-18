//
// Created by Tadeas Kriz on 18/07/15.
//

import SwiftyJSON

public struct IntTransformation: Transformation {
    public func transformFromJSON(json: JSON) -> Int? {
        return json.int
    }

    public func transformToJSON(object: Int?) -> JSON {
        return JSON(object ?? NSNull())
    }
}

