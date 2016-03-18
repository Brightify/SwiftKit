//
//  Mappable.swift
//  Pods
//
//  Created by Tadeáš Kříž on 6/26/15.
//
//

import Foundation

public protocol Serializable {
    func serialize(to map: Map)
}

public protocol Deserializable {
    init?(_ map: Map)
}

public protocol Mappable: Serializable, Deserializable {
    mutating func mapping(map: Map)
}

extension Mappable {
    public func serialize(to map: Map) {
        var mutableSelf = self
        mutableSelf.mapping(map)
    }
}