//
//  JsonTypeInfo.swift
//  Pods
//
//  Created by Tadeáš Kříž on 6/29/15.
//
//

import Foundation

public struct JsonTypeInfo {
    public let baseType: PolymorphicMappable.Type
    public let registeredTypes: [PolymorphicType]
    
    fileprivate init(
        baseType: PolymorphicMappable.Type,
        registeredTypes: [PolymorphicType]) {
            self.baseType = baseType
            self.registeredTypes = registeredTypes
    }
    
    public enum Id {
        case `class`(property: String, className: String)
        case name(property: String, value: String)
    }
    
}

open class JsonTypeInfoBuilder<T: PolymorphicMappable> {
    fileprivate var registeredTypes: [PolymorphicType] = []
    
    public init() {
    }
    
    open func registerSubtype(_ type: T.Type, named name: String, property: String = "@type") {
        let id = JsonTypeInfo.Id.name(property: property, value: name)
        let polymorphicType = PolymorphicType(type: type, use: id)
        
        registeredTypes.append(polymorphicType)
    }
    
    open func registerSubtype(_ type: T.Type, property: String = "@class") {
        let className = Mirror(reflecting: type).description
        let id = JsonTypeInfo.Id.class(property: property, className: className)
        let polymorphicType = PolymorphicType(type: type, use: id)
        
        registeredTypes.append(polymorphicType)
    }
    
    open func build() -> JsonTypeInfo {
        return JsonTypeInfo(
            baseType: T.self,
            registeredTypes: registeredTypes)
    }
}
