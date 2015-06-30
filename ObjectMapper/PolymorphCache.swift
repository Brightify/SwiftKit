//
//  PolymorphCache.swift
//  Pods
//
//  Created by Tadeáš Kříž on 6/29/15.
//
//

import Foundation

class PolymorphCache {
    var deserializationMap: [String: [String: PolymorphicMappable.Type]] = [:]
    
    var serializationMap: [ObjectIdentifier: (name: String, value: String)] = [:]
    
    func register(propertyName: String, propertyValue: String, type: PolymorphicMappable.Type) {
        var deserializationProperties = deserializationMap[propertyName] ?? [:]
        deserializationProperties[propertyValue] = type
        deserializationMap[propertyName] = deserializationProperties
        
        let identifier = ObjectIdentifier(type as! Any.Type)
        serializationMap[identifier] = (name: propertyName, value: propertyValue)
    }
}
