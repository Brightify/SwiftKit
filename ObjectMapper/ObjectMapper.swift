import Foundation
import SwiftyJSON

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
        if (json.type == .Dictionary) {
            let map = BaseMap(objectMapper: self, mappingDirection: .FromJSON, json: json)
            let type = polymorph.concreteTypeFor(M.self, inMap: map)
            return type(map)
        } else {
            return nil
        }
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

    public func mapDictionary<M: Mappable>(json: JSON) -> [String: M]? {
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

    public func toJSON<M: Mappable>(var object: M) -> JSON {
        let map = BaseMap(objectMapper: self, mappingDirection: .ToJSON)
        
        polymorph.writeTypeInfoToMap(map, ofType: M.self, forObject: object)
        
        object.mapping(map)
        return map.json.unbox
    }
    
    public func toJSONArray<M: Mappable>(var objects: [M]) -> JSON {
        var json: JSON = []
        json.arrayObject = objects.map { self.toJSON($0).object }
        return json
    }
    
    public func toJSONDictionary<M: Mappable>(var dictionary: [String: M]) -> JSON {
        var json: JSON = [:]
        json.dictionaryObject = dictionary.map { self.toJSON($0).object }
        return json
    }

}