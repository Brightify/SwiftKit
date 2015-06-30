//
//  JsonTypeInfo.swift
//  Pods
//
//  Created by Tadeáš Kříž on 6/29/15.
//
//

import Foundation

@objc
public class JsonTypeInfo {
    public let baseType: PolymorphicMappable.Type
    public let registeredTypes: [PolymorphicType]
    
    private init(
        baseType: PolymorphicMappable.Type,
        registeredTypes: [PolymorphicType]) {
            self.baseType = baseType
            self.registeredTypes = registeredTypes
    }
    
    public enum Id {
        case Class(property: String, className: String)
        case Name(property: String, value: String)
    }
    
}

public class JsonTypeInfoBuilder<T: PolymorphicMappable> {
    private var registeredTypes: [PolymorphicType] = []
    
    public init() {
    }
    
    public func registerSubtype(type: T.Type, named name: String, property: String = "@type") {
        let id = JsonTypeInfo.Id.Name(property: property, value: name)
        let polymorphicType = PolymorphicType(type: type, use: id)
        
        registeredTypes.append(polymorphicType)
    }
    
    public func registerSubtype(type: T.Type, property: String = "@class") {
        let className = reflect(type).summary
        let id = JsonTypeInfo.Id.Class(property: property, className: className)
        let polymorphicType = PolymorphicType(type: type, use: id)
        
        registeredTypes.append(polymorphicType)
    }
    
    public func build() -> JsonTypeInfo {
        return JsonTypeInfo(
            baseType: T.self,
            registeredTypes: registeredTypes)
    }
}