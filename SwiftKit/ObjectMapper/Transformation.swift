//
//  Transformation.swift
//  Pods
//
//  Created by Tadeas Kriz on 16/07/15.
//
//

import SwiftyJSON

public protocol Transformation {
    associatedtype Object

    func transformFromJSON(_ json: JSON) -> Object?
    func transformToJSON(_ object: Object?) -> JSON
}
