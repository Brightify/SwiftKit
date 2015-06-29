//
//  Transformable.swift
//  Pods
//
//  Created by Tadeáš Kříž on 6/25/15.
//
//

public protocol Transformable {
    
    static func transformFromJSON(value: AnyObject?) -> Self?
    static func transformToJSON(value: Self?) -> AnyObject?
    
}