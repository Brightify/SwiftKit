//
//  Mappable.swift
//  Pods
//
//  Created by Tadeáš Kříž on 6/26/15.
//
//

import Foundation

public protocol Mappable {
    init?(_ map: Map)
    
    mutating func mapping(map: Map)
}