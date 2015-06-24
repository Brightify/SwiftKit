//
//  Transformable.swift
//  Pods
//
//  Created by Tadeáš Kříž on 6/25/15.
//
//

import ObjectMapper

public protocol Transformable {
    
    static func transformFromJSON(value: AnyObject?) -> Self?
    static func transformToJSON(value: Self?) -> AnyObject?
    
}