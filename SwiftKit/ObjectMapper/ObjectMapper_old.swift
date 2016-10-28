import Foundation
import SwiftyJSON

open class ObjectMapper {
    
    fileprivate let polymorph = Polymorph()
    
    struct ClassType {
        let type: AnyObject
        let jsonTypeInfo: JsonTypeInfo
    }
    
    open func cacheTypeInfo<T: JsonTypeInfoAnnotation>(_ annotatedType: T.Type) where T: Mappable {
        _ = polymorph.cache(annotatedType)
    }
    
    public init() {
    }
    
    open func deserialize<M: Deserializable>(_ json: JSON) -> M? {
        if json.type == .null {
            return nil
        }
        
        let map = BaseMap(objectMapper: self, mappingDirection: .fromJSON, json: json)
        let type = polymorph.concreteTypeFor(M.self, inMap: map)
        return type.init(map)
    }
    
    @available(*, renamed: "deserialize")
    open func map<M: Deserializable>(_ json: JSON) -> M? {
        return deserialize(json)
    }
    
    open func map<M: Mappable>(_ json: JSON, to object: inout M) {
        if json.type == .null {
            return
        }
        
        let map = BaseMap(objectMapper: self, mappingDirection: .fromJSON, json: json)
        object.mapping(map)
    }
    
    open func mapArray<M: Deserializable>(_ json: JSON) -> [M]? {
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

    open func mapDictionary<M: Deserializable>(_ json: JSON) -> [String: M]? {
        if let jsonDictionary = json.dictionary {
            var objects: [String: M] = [:]
            for (key, item) in jsonDictionary {
                if let object: M = map(item) {
                    objects[key] = object
                }
            }
            return objects
        } else {
            return nil
        }
    }

    open func toJSON<M: Serializable>(_ object: M) -> JSON {
        let map = BaseMap(objectMapper: self, mappingDirection: .toJSON)
        
        polymorph.writeTypeInfoToMap(map, ofType: M.self, forObject: object)
        
        object.serialize(to: map)
        return map.json.unbox
    }
    
    open func toJSONArray<M: Serializable>(_ objects: [M]) -> JSON {
        var json: JSON = []
        json.arrayObject = objects.map { self.toJSON($0).object }
        return json
    }
    
    open func toJSONDictionary<M: Serializable>(_ dictionary: [String: M]) -> JSON {
        var json: JSON = [:]
        json.dictionaryObject = dictionary.map { self.toJSON($0).object }
        return json
    }

}



