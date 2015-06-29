import Foundation
import SwiftyJSON

public struct PolymorphicType {
    public let type: Mappable.Type
    public let use: JsonTypeInfo.Id
}

public class JsonTypeInfoBuilder<T: Mappable> {
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

@objc
public class JsonTypeInfo {
    public let baseType: Mappable.Type
    public let registeredTypes: [PolymorphicType]
    
    private init(
        baseType: Mappable.Type,
        registeredTypes: [PolymorphicType]) {
            self.baseType = baseType
            self.registeredTypes = registeredTypes
    }
    
    public enum Id {
        case Class(property: String, className: String)
        case Name(property: String, value: String)
    }

}

@objc
public protocol JsonTypeInfoAnnotation {
    static func jsonTypeInfo() -> JsonTypeInfo
}

public struct NamedType {
    public let type: Mappable.Type
    public let name: String
}

class PolymorphCache {
    var deserializationMap: [String: [String: Mappable.Type]] = [:]
    
    var serializationMap: [ObjectIdentifier: (name: String, value: String)] = [:]
    
    func register(propertyName: String, propertyValue: String, type: Mappable.Type) {
        var deserializationProperties = deserializationMap[propertyName] ?? [:]
        deserializationProperties[propertyValue] = type
        deserializationMap[propertyName] = deserializationProperties
        
        let identifier = ObjectIdentifier(type as! Any.Type)
        serializationMap[identifier] = (name: propertyName, value: propertyValue)
    }
}

class Polymorph {
 
    private var cacheMap: [ObjectIdentifier: PolymorphCache] = [:]
    
    func getCache(annotationType: JsonTypeInfoAnnotation.Type) -> PolymorphCache? {
        let identifier = ObjectIdentifier(annotationType)
        
        return cacheMap[identifier]
    }
    
    func wipeCache(annotationType: JsonTypeInfoAnnotation.Type) {
        let identifier = ObjectIdentifier(annotationType)
        
        cacheMap.removeValueForKey(identifier)
    }
    
    func isCached(annotationType: JsonTypeInfoAnnotation.Type) -> Bool {
        return getCache(annotationType) != nil
    }
    
    func cache(annotatedType: JsonTypeInfoAnnotation.Type, force: Bool = false) -> PolymorphCache {
        if let oldCache = getCache(annotatedType) {
            if (force) {
                wipeCache(annotatedType)
            } else {
                return oldCache
            }
        }
        
        let cache = PolymorphCache()

        let registeredTypes = Polymorph.collectAllRegisteredTypes(annotatedType as! Any.Type)
        
        for type in registeredTypes {
            switch (type.use) {
            case .Class(let property, let className):
                cache.register(property, propertyValue: className, type: type.type)
            case .Name(let property, let value):
                cache.register(property, propertyValue: value, type: type.type)
            }
        }
        
        let identifier = ObjectIdentifier(annotatedType)
        cacheMap[identifier] = cache
        return cache
    }
    
    func concreteTypeFor<M: Mappable>(type: M.Type, inMap map: Map) -> M.Type {
        if let annotatedType = type as? JsonTypeInfoAnnotation.Type {
            let cache = self.cache(annotatedType)
            
            for (propertyName, valueToType) in cache.deserializationMap {
                if let value: String = map[propertyName].value(), type = valueToType[value] as? M.Type {
                    return type
                }
            }
        }
        
        return type
    }
    
    func writeTypeInfoToMap<M: Mappable>(map: Map, ofType type: M.Type, forObject object: M) {
        if let annotatedType = type as? JsonTypeInfoAnnotation.Type {
            let identifier = ObjectIdentifier(object.dynamicType)
            let cache = self.cache(annotatedType)
            
            if let property = cache.serializationMap[identifier] {
                map[property.name].setValue(NSString(string: property.value))
            }
        }
        
    }
    
    private class func extractTypeInfo(type: Any) -> JsonTypeInfo? {
        // We cast the type to `AnyClass` so we can dynamically invoke the static method.
        // TODO When Swift' protocol class level access is implemented we should switch to it
        return (type as? AnyClass)?.jsonTypeInfo()
    }
    
    private class func collectAllRegisteredTypes(type: Any.Type) -> [PolymorphicType] {
        return extractTypeInfo(type)?.registeredTypes.flatMap(collectChildRegisteredTypes(type)) ?? []
    }

    private class func collectChildRegisteredTypes(parentBaseType: Any.Type) -> PolymorphicType -> [PolymorphicType] {
        return { type in
            var output = [type]
            
            if let typeInfo = self.extractTypeInfo(type.type), objcBaseType = typeInfo.baseType as? Any.Type {
                if(ObjectIdentifier(objcBaseType) != ObjectIdentifier(parentBaseType)) {
                    output += typeInfo.registeredTypes.flatMap(self.collectChildRegisteredTypes(objcBaseType))
                }
            }
            
            return output
        }
    }
}

/*
if let jsonTypeInfoAnnotation: AnyClass = M.self as? AnyClass,
    jsonTypeInfo = jsonTypeInfoAnnotation.jsonTypeInfo {
        if jsonTypeInfo.use != .None && jsonTypeInfo.namedTypes.count != 0 {
            if let typeName: String = map[jsonTypeInfo.property].value() {
                if let concreteType = jsonTypeInfo.namedTypes[typeName] as? M.Type {
                    return concreteType
                }
            }
        }
}

*/

public class ObjectMapper {
    
    private let polymorph = Polymorph()
    
    struct ClassType {
        let type: AnyObject
        let jsonTypeInfo: JsonTypeInfo
    }
    
    public func cacheTypeInfo<T: JsonTypeInfoAnnotation where T: Mappable>(annotatedType: T.Type) {
        polymorph.cache(annotatedType)
    }
    
    public init() {
    }
    
    public func map<M: Mappable>(json: JSON) -> M? {
        let map = BaseMap(objectMapper: self, mappingDirection: .FromJSON, json: json)
        let type = polymorph.concreteTypeFor(M.self, inMap: map)
        return type(map)
    }
    
    public func mapArray<M: Mappable>(json: JSON) -> [M]? {
        if let jsonArray = json.array {
            var objects: [M] = []
            for item in jsonArray {
                if let object: M = map(item) {
                    objects.append(object)
                }
            }
            return objects
        } else {
            return nil
        }
    }
 
    public func toJSON<M: Mappable>(var object: M) -> JSON {
        let map = BaseMap(objectMapper: self, mappingDirection: .ToJSON)
        
        polymorph.writeTypeInfoToMap(map, ofType: M.self, forObject: object)
        
        object.mapping(map)
        return map.json
    }
    
    public func toJSONArray<M: Mappable>(var objects: [M]) -> JSON {
        var json: JSON = []
        json.arrayObject = objects.map { self.toJSON($0).object }
        return json
    }

}


func recursive<T, U>(f: ((itself: (T -> U), input: T) -> U)) -> (T -> U) {
    var g: (T -> U)!
    g = { f(itself: g, input: $0) }
    return g
}