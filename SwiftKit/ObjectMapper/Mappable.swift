//
//  Mappable.swift
//  Pods
//
//  Created by Tadeáš Kříž on 6/26/15.
//
//

import Foundation

public protocol Serializable {
    mutating func mapping(map: Map)
}

public protocol Deserializable {
    init?(_ map: Map)
}

public protocol Mappable: Serializable, Deserializable { }