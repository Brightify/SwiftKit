//
//  Transformation.swift
//  Pods
//
//  Created by Tadeas Kriz on 16/07/15.
//
//

import SwiftyJSON

public protocol Transformation {
    typealias Object

    func transformFromJSON(json: JSON) -> Object?
    func transformToJSON(object: Object?) -> JSON
}