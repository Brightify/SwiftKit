//
// Created by Tadeas Kriz on 18/07/15.
//

import SwiftyJSON

public struct StringTransformation: Transformation {
    public func transformFromJSON(json: JSON) -> String? {
        return json.string
    }

    public func transformToJSON(object: String?) -> JSON {
        return JSON(object ?? NSNull())
    }
}