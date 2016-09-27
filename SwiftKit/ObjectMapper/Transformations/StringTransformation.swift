//
// Created by Tadeas Kriz on 18/07/15.
//

import SwiftyJSON

public struct StringTransformation: Transformation {
    
    public init() { }
    
    public func transformFromJSON(_ json: JSON) -> String? {
        return json.string
    }

    public func transformToJSON(_ object: String?) -> JSON {
        return JSON(object.map { $0 as NSString } ?? NSNull())
    }
}
