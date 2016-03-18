//
//  Map.swift
//  Pods
//
//  Created by Tadeáš Kříž on 6/26/15.
//
//

import Foundation
import SwiftyJSON

public typealias SubscriptType = JSONSubscriptType

// Needed because of: http://stackoverflow.com/questions/31127786/compilation-fails-with-valid-code-when-fastest-o-optimizations-are-set/31127787#31127787
public class JSONBox {
    
    private let read: () -> JSON
    private let write: JSON -> ()
    
    public init(var json: JSON) {
        read = {
            return json
        }
        write = {
            json = $0
        }
    }
    
    public init(inout json: JSON) {
        read = {
            return json
        }
        write = {
            json = $0
        }
    }
    
    public init(read: () -> JSON, write: JSON -> ()) {
        self.read = read
        self.write = write
    }
    
    public var unbox: JSON {
        get {
            return read()
        }
        set {
            write(newValue)
        }
    }
}

public enum MappingDirection {
    case FromJSON
    case ToJSON
}

public protocol Map: class {
    var objectMapper: ObjectMapper { get }
    var direction: MappingDirection { get }
    var json: JSONBox { get }
    
    subscript(path: [SubscriptType]) -> Map { get }
    subscript(path: SubscriptType...) -> Map { get }
    
    func value<T>() -> T?
    
    func value<T: Transformation>(transformWith transformation: T) -> T.Object?
    
    func valueArray<T: Transformation>(transformWith transformation: T) -> [T.Object]
    
    func valueArray<T: Transformation>(transformWith transformation: T, defaultValue: [T.Object]) -> [T.Object]
    
    func valueDictionary<T: Transformation>(transformWith transformation: T) -> [String: T.Object]
    
    func valueDictionary<T: Transformation>(transformWith transformation: T, defaultValue: [String: T.Object]) -> [String: T.Object]
    
    func object<T: Mappable>() -> T?
    
    func objectArray<T: Mappable>() -> [T]?

    func objectDictionary<T: Mappable>() -> [String: T]?

    func setValue<T: AnyObject>(value: T?)
    
    func setValue<T, Transform: Transformation where Transform.Object == T>
            (value: T?, transformWith transformation: Transform)
    
    func setValueArray<T, Transform: Transformation where Transform.Object == T>
            (array: [T]?, transformWith transformation: Transform)
    
    func setValueDictionary<T, Transform: Transformation where Transform.Object == T>
            (dictionary: [String: T]?, transformWith transformation: Transform)
    
    func setObject<T: Mappable>(object: T?)
    
    func setObjectArray<T: Mappable>(objectArray: [T]?)
    
    func setObjectDictionary<T: Mappable>(objectDictionary: [String: T]?)
    
    func assignValueTo<T>(inout field: T)
    
    func assignValueTo<T>(inout field: T!)
    
    func assignValueTo<T>(inout field: T?)
    
    func assignValueTo<T, Transform: Transformation where Transform.Object == T>
            (inout field: T, transformWith transformation: Transform)
    
    func assignValueTo<T, Transform: Transformation where Transform.Object == T>
            (inout field: T!, transformWith transformation: Transform)
    
    func assignValueTo<T, Transform: Transformation where Transform.Object == T>
            (inout field: T?, transformWith transformation: Transform)

    func assignValueArrayTo<T, Transform: Transformation where Transform.Object == T>
            (inout field: [T], transformWith transformation: Transform)

    func assignValueArrayTo<T, Transform: Transformation where Transform.Object == T>
            (inout field: [T]!, transformWith transformation: Transform)

    func assignValueArrayTo<T, Transform: Transformation where Transform.Object == T>
            (inout field: [T]?, transformWith transformation: Transform)

    func assignValueDictionaryTo<T, Transform: Transformation where Transform.Object == T>
            (inout field: [String:T], transformWith transformation: Transform)

    func assignValueDictionaryTo<T, Transform: Transformation where Transform.Object == T>
            (inout field: [String:T]!, transformWith transformation: Transform)

    func assignValueDictionaryTo<T, Transform: Transformation where Transform.Object == T>
            (inout field: [String:T]?, transformWith transformation: Transform)

    func assignObjectTo<T: Mappable>(inout field: T)

    func assignObjectTo<T: Mappable>(inout field: T!)
    
    func assignObjectTo<T: Mappable>(inout field: T?)
    
    func assignObjectArrayTo<T: Mappable>(inout field: [T])

    func assignObjectArrayTo<T: Mappable>(inout field: [T]!)

    func assignObjectArrayTo<T: Mappable>(inout field: [T]?)

    func assignObjectDictionaryTo<T: Mappable>(inout field: [String: T])

    func assignObjectDictionaryTo<T: Mappable>(inout field: [String: T]!)

    func assignObjectDictionaryTo<T: Mappable>(inout field: [String: T]?)
}

public class BaseMap: Map {
    public let objectMapper: ObjectMapper
    public let direction: MappingDirection
    public let json: JSONBox
    
    public convenience init(objectMapper: ObjectMapper, mappingDirection: MappingDirection, json: JSON = [:]) {
        self.init(objectMapper: objectMapper, mappingDirection: mappingDirection, jsonBox: JSONBox(json: json))
    }
    
    public init(objectMapper: ObjectMapper, mappingDirection: MappingDirection, jsonBox: JSONBox) {
        self.objectMapper = objectMapper
        self.direction = mappingDirection
        self.json = jsonBox
    }
    
    public subscript(path: [SubscriptType]) -> Map {
        return ChildMap(parentMap: self, path: path)
    }
    
    public subscript(path: SubscriptType...) -> Map {
        return self[path]
    }
    
    public func value<T>() -> T? {
        return json.unbox.object as? T
    }
    
    public func value<T: Transformation>(transformWith transformation: T) -> T.Object? {
        return transformation.transformFromJSON(json.unbox)
    }
    
    public func valueArray<T: Transformation>(transformWith transformation: T) -> [T.Object] {
        return valueArray(transformWith: transformation, defaultValue: [])
    }
    
    public func valueArray<T: Transformation>(transformWith transformation: T, defaultValue: [T.Object]) -> [T.Object] {
        return transformArrayWith(transformation) ?? defaultValue
    }
    
    public func valueDictionary<T: Transformation>(transformWith transformation: T) -> [String: T.Object] {
        return valueDictionary(transformWith: transformation, defaultValue: [:])
    }
    
    public func valueDictionary<T: Transformation>(transformWith transformation: T, defaultValue: [String: T.Object]) -> [String: T.Object] {
        return transformDictionaryWith(transformation) ?? defaultValue
    }
    
    public func object<T: Mappable>() -> T? {
        return objectMapper.map(json.unbox)
    }
    
    public func objectArray<T: Mappable>() -> [T]? {
        return objectMapper.mapArray(json.unbox)
    }

    public func objectDictionary<T: Mappable>() -> [String: T]? {
        return objectMapper.mapDictionary(json.unbox)
    }
    
    public func setValue<T: AnyObject>(value: T?) {
        json.unbox.object = value ?? NSNull()
    }
    
    public func setValue<T, Transform: Transformation where Transform.Object == T>
            (value: T?, transformWith transformation: Transform) {
        json.unbox.object = transformation.transformToJSON(value).object
    }
    
    public func setValueArray<T, Transform: Transformation where Transform.Object == T>
            (array: [T]?, transformWith transformation: Transform) {
        json.unbox.object = array?.map {
            transformation.transformToJSON($0).object
        } ?? NSNull()
    }
    
    public func setValueDictionary<T, Transform: Transformation where Transform.Object == T>
            (dictionary: [String: T]?, transformWith transformation: Transform) {
        json.unbox.object = dictionary?.map {
            transformation.transformToJSON($0).object
        } ?? NSNull()
    }
    
    public func setObject<T: Mappable>(object: T?) {
        if let unwrappedObject = object {
            json.unbox.object = objectMapper.toJSON(unwrappedObject).object
        } else {
            json.unbox.object = NSNull()
        }
    }
    
    public func setObjectArray<T: Mappable>(objectArray: [T]?) {
        if let unwrappedObjectArray = objectArray {
            json.unbox.object = objectMapper.toJSONArray(unwrappedObjectArray).object
        } else {
            json.unbox.object = NSNull()
        }
    }
    
    public func setObjectDictionary<T : Mappable>(objectDictionary: [String : T]?) {
        if let unwrappedObjectDictionary = objectDictionary {
            json.unbox.object = objectMapper.toJSONDictionary(unwrappedObjectDictionary).object
        } else {
            json.unbox.object = NSNull()
        }
    }
    
    public func assignValueTo<T>(inout field: T) {
        if let value: T = value() {
            field = value
        }
    }
    
    public func assignValueTo<T>(inout field: T!) {
        if let value: T = value() {
            field = value
        }
    }
    
    public func assignValueTo<T>(inout field: T?) {
        if let value: T = value() {
            field = value
        }
    }
    
    public func assignValueTo<T, Transform: Transformation where Transform.Object == T>
            (inout field: T, transformWith transformation: Transform) {
        if let value: T = transformation.transformFromJSON(json.unbox) {
            field = value
        }
    }
    
    public func assignValueTo<T, Transform: Transformation where Transform.Object == T>
            (inout field: T!, transformWith transformation: Transform) {
        if let value: T = transformation.transformFromJSON(json.unbox) {
            field = value
        }
    }
    
    public func assignValueTo<T, Transform: Transformation where Transform.Object == T>
            (inout field: T?, transformWith transformation: Transform) {
        if let value: T = transformation.transformFromJSON(json.unbox) {
            field = value
        }
    }

    public func assignValueArrayTo<T, Transform:Transformation where Transform.Object == T>
            (inout field: [T]?, transformWith transformation: Transform) {
        if let array = transformArrayWith(transformation) {
            field = array
        }
    }

    public func assignValueArrayTo<T, Transform:Transformation where Transform.Object == T>
            (inout field: [T]!, transformWith transformation: Transform) {
        if let array = transformArrayWith(transformation) {
            field = array
        }
    }

    public func assignValueArrayTo<T, Transform:Transformation where Transform.Object == T>
            (inout field: [T], transformWith transformation: Transform) {
        if let array = transformArrayWith(transformation) {
            field = array
        }
    }

    public func assignValueDictionaryTo<T, Transform: Transformation where Transform.Object == T>
            (inout field: [String:T]?, transformWith transformation: Transform) {
        if let dictionary = transformDictionaryWith(transformation) {
            field = dictionary
        }
    }

    public func assignValueDictionaryTo<T, Transform:Transformation where Transform.Object == T>
            (inout field: [String:T]!, transformWith transformation: Transform) {
        if let dictionary = transformDictionaryWith(transformation) {
            field = dictionary
        }
    }

    public func assignValueDictionaryTo<T, Transform:Transformation where Transform.Object == T>
            (inout field: [String:T], transformWith transformation: Transform) {
        if let dictionary = transformDictionaryWith(transformation) {
            field = dictionary
        }
    }

    public func assignObjectTo<T: Mappable>(inout field: T) {
        if let object: T = object() {
            field = object
        }
    }
    
    public func assignObjectTo<T: Mappable>(inout field: T!) {
        if let object: T = object() {
            field = object
        }
    }
    
    public func assignObjectTo<T: Mappable>(inout field: T?) {
        if let object: T = object() {
            field = object
        }
    }
    
    public func assignObjectArrayTo<T: Mappable>(inout field: [T]) {
        if let objectArray: [T] = objectArray() {
            field = objectArray
        }
    }

    public func assignObjectArrayTo<T: Mappable>(inout field: [T]!) {
        if let objectArray: [T] = objectArray() {
            field = objectArray
        }
    }

    public func assignObjectArrayTo<T: Mappable>(inout field: [T]?) {
        if let objectArray: [T] = objectArray() {
            field = objectArray
        }
    }

    public func assignObjectDictionaryTo<T: Mappable>(inout field: [String: T]) {
        if let objectDictionary: [String: T] = objectDictionary() {
            field = objectDictionary
        }
    }

    public func assignObjectDictionaryTo<T: Mappable>(inout field: [String: T]!) {
        if let objectDictionary: [String: T] = objectDictionary() {
            field = objectDictionary
        }
    }

    public func assignObjectDictionaryTo<T: Mappable>(inout field: [String: T]?) {
        if let objectDictionary: [String: T] = objectDictionary() {
            field = objectDictionary
        }
    }

    private func transformArrayWith<T: Transformation>(transformation: T) -> [T.Object]? {
        if (json.unbox.type == .Array) {
            var array: [T.Object] = []
            json.unbox.forEach {
                if let value = transformation.transformFromJSON($1) {
                    array.append(value)
                }
            }
            return array
        } else {
            return nil
        }
    }

    private func transformDictionaryWith<T: Transformation>(transformation: T) -> [String:T.Object]? {
        if (json.unbox.type == .Dictionary) {
            var dictionary: [String: T.Object] = [:]
            for (key, jsonValue) in json.unbox {
                if let value = transformation.transformFromJSON(jsonValue) {
                    dictionary[key] = value
                }
            }
            return dictionary
        } else {
            return nil
        }
    }
}

public class ChildMap: BaseMap {
    public let parentMap: Map
    public let path: [SubscriptType]

    public init(parentMap: Map, path: [SubscriptType] = []) {
        self.parentMap = parentMap
        self.path = path
        
        let jsonBox = JSONBox(read: { parentMap.json.unbox[path] },
            write: { parentMap.json.unbox[path].object = $0.object })
        
        super.init(objectMapper: parentMap.objectMapper, mappingDirection: parentMap.direction, jsonBox: jsonBox)
    }
}