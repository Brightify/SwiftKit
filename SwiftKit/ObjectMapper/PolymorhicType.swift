//
//  PolymorhicType.swift
//  Pods
//
//  Created by Tadeáš Kříž on 6/29/15.
//
//

public typealias PolymorphicMappable = Mappable & JsonTypeInfoAnnotation

public struct PolymorphicType {
    public let type: PolymorphicMappable.Type
    public let use: JsonTypeInfo.Id
}
