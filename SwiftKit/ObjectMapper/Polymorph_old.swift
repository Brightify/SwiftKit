//
//  Polymorph.swift
//  Pods
//
//  Created by Tadeáš Kříž on 6/29/15.
//
//

import Foundation

class Polymorph {
    
    fileprivate var cacheMap: [ObjectIdentifier: PolymorphCache] = [:]
    
    func getCache(_ annotationType: PolymorphicMappable.Type) -> PolymorphCache? {
        let identifier = ObjectIdentifier(annotationType)
        
        return cacheMap[identifier]
    }
    
    func wipeCache(_ annotationType: PolymorphicMappable.Type) {
        let identifier = ObjectIdentifier(annotationType)
        
        cacheMap.removeValue(forKey: identifier)
    }
    
    func isCached(_ annotationType: PolymorphicMappable.Type) -> Bool {
        return getCache(annotationType) != nil
    }
    
    func cache(_ annotatedType: PolymorphicMappable.Type, force: Bool = false) -> PolymorphCache {
        if let oldCache = getCache(annotatedType) {
            if (force) {
                wipeCache(annotatedType)
            } else {
                return oldCache
            }
        }
        
        let cache = PolymorphCache()
        
        let registeredTypes = Polymorph.collectAllRegisteredTypes(annotatedType)
        
        for type in registeredTypes {
            switch (type.use) {
            case .class(let property, let className):
                cache.register(property, propertyValue: className, type: type.type)
            case .name(let property, let value):
                cache.register(property, propertyValue: value, type: type.type)
            }
        }
        
        let identifier = ObjectIdentifier(annotatedType)
        cacheMap[identifier] = cache
        return cache
    }
    
    func concreteTypeFor<M: Deserializable>(_ type: M.Type, inMap map: Map) -> M.Type {
        if let annotatedType = type as? PolymorphicMappable.Type {
            let cache = self.cache(annotatedType)
            
            for (propertyName, valueToType) in cache.deserializationMap {
                if let value: String = map[propertyName].value(), let type = valueToType[value] as? M.Type {
                    return type
                }
            }
        }
        
        return type
    }
    
    func writeTypeInfoToMap<M: Serializable>(_ map: Map, ofType type: M.Type, forObject object: M) {
        if let annotatedType = type as? PolymorphicMappable.Type {
            let identifier = ObjectIdentifier(type(of: object))
            let cache = self.cache(annotatedType)
            
            if let property = cache.serializationMap[identifier] {
                map[property.name].setValue(NSString(string: property.value))
            }
        }
        
    }
    
    fileprivate class func collectAllRegisteredTypes(_ type: PolymorphicMappable.Type) -> [PolymorphicType] {
        return type.jsonTypeInfo().registeredTypes.flatMap {
            self.collectChildRegisteredTypes(parentBaseType: type, type: $0)
        }
    }
    
    fileprivate class func collectChildRegisteredTypes(parentBaseType: PolymorphicMappable.Type, type: PolymorphicType) -> [PolymorphicType] {
        var output = [type]
        
        let typeInfo = type.type.jsonTypeInfo()
        if(ObjectIdentifier(typeInfo.baseType) != ObjectIdentifier(parentBaseType)) {
            output += typeInfo.registeredTypes.flatMap {
                self.collectChildRegisteredTypes(parentBaseType: typeInfo.baseType, type: $0)
            }
        }
        
        return output
    }
}
