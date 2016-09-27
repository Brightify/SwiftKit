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
open class JSONBox {
    
    fileprivate let read: () -> JSON
    fileprivate let write: (JSON) -> ()
    
    public init(json: JSON) {
        var json = json
        read = {
            return json
        }
        write = {
            json = $0
        }
    }
    
//    public init(json: inout JSON) {
//        read = {
//            return json
//        }
//        write = {
//            json = $0
//        }
//    }

    public init(read: @escaping () -> JSON, write: @escaping (JSON) -> ()) {
        self.read = read
        self.write = write
    }
    
    open var unbox: JSON {
        get {
            return read()
        }
        set {
            write(newValue)
        }
    }
}

public enum MappingDirection {
    case fromJSON
    case toJSON
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
    
    func object<T: Deserializable>() -> T?
    
    func objectArray<T: Deserializable>() -> [T]?

    func objectDictionary<T: Deserializable>() -> [String: T]?

    func setValue<T: AnyObject>(_ value: T?)
    
    func setValue<T, Transform: Transformation>
            (_ value: T?, transformWith transformation: Transform) where Transform.Object == T
    
    func setValueArray<T, Transform: Transformation>
            (_ array: [T]?, transformWith transformation: Transform) where Transform.Object == T
    
    func setValueDictionary<T, Transform: Transformation>
            (_ dictionary: [String: T]?, transformWith transformation: Transform) where Transform.Object == T
    
    func setObject<T: Serializable>(_ object: T?)
    
    func setObjectArray<T: Serializable>(_ objectArray: [T]?)
    
    func setObjectDictionary<T: Serializable>(_ objectDictionary: [String: T]?)
    
    func assignValueTo<T>(_ field: inout T)
    
    func assignValueTo<T>(_ field: inout T!)
    
    func assignValueTo<T>(_ field: inout T?)
    
    func assignValueTo<T, Transform: Transformation>
            (_ field: inout T, transformWith transformation: Transform) where Transform.Object == T
    
    func assignValueTo<T, Transform: Transformation>
            (_ field: inout T!, transformWith transformation: Transform) where Transform.Object == T
    
    func assignValueTo<T, Transform: Transformation>
            (_ field: inout T?, transformWith transformation: Transform) where Transform.Object == T

    func assignValueArrayTo<T, Transform: Transformation>
            (_ field: inout [T], transformWith transformation: Transform) where Transform.Object == T

    func assignValueArrayTo<T, Transform: Transformation>
            (_ field: inout [T]!, transformWith transformation: Transform) where Transform.Object == T

    func assignValueArrayTo<T, Transform: Transformation>
            (_ field: inout [T]?, transformWith transformation: Transform) where Transform.Object == T

    func assignValueDictionaryTo<T, Transform: Transformation>
            (_ field: inout [String:T], transformWith transformation: Transform) where Transform.Object == T

    func assignValueDictionaryTo<T, Transform: Transformation>
            (_ field: inout [String:T]!, transformWith transformation: Transform) where Transform.Object == T

    func assignValueDictionaryTo<T, Transform: Transformation>
            (_ field: inout [String:T]?, transformWith transformation: Transform) where Transform.Object == T

    func assignObjectTo<T: Deserializable>(_ field: inout T)

    func assignObjectTo<T: Deserializable>(_ field: inout T!)
    
    func assignObjectTo<T: Deserializable>(_ field: inout T?)
    
    func assignObjectArrayTo<T: Deserializable>(_ field: inout [T])

    func assignObjectArrayTo<T: Deserializable>(_ field: inout [T]!)

    func assignObjectArrayTo<T: Deserializable>(_ field: inout [T]?)

    func assignObjectDictionaryTo<T: Deserializable>(_ field: inout [String: T])

    func assignObjectDictionaryTo<T: Deserializable>(_ field: inout [String: T]!)

    func assignObjectDictionaryTo<T: Deserializable>(_ field: inout [String: T]?)
}

open class BaseMap: Map {
    open let objectMapper: ObjectMapper
    open let direction: MappingDirection
    open let json: JSONBox
    
    public convenience init(objectMapper: ObjectMapper, mappingDirection: MappingDirection, json: JSON = [:]) {
        self.init(objectMapper: objectMapper, mappingDirection: mappingDirection, jsonBox: JSONBox(json: json))
    }
    
    public init(objectMapper: ObjectMapper, mappingDirection: MappingDirection, jsonBox: JSONBox) {
        self.objectMapper = objectMapper
        self.direction = mappingDirection
        self.json = jsonBox
    }
    
    open subscript(path: [SubscriptType]) -> Map {
        return ChildMap(parentMap: self, path: path)
    }
    
    open subscript(path: SubscriptType...) -> Map {
        return self[path]
    }
    
    open func value<T>() -> T? {
        return json.unbox.object as? T
    }
    
    open func value<T: Transformation>(transformWith transformation: T) -> T.Object? {
        return transformation.transformFromJSON(json.unbox)
    }
    
    open func valueArray<T: Transformation>(transformWith transformation: T) -> [T.Object] {
        return valueArray(transformWith: transformation, defaultValue: [])
    }
    
    open func valueArray<T: Transformation>(transformWith transformation: T, defaultValue: [T.Object]) -> [T.Object] {
        return transformArrayWith(transformation) ?? defaultValue
    }
    
    open func valueDictionary<T: Transformation>(transformWith transformation: T) -> [String: T.Object] {
        return valueDictionary(transformWith: transformation, defaultValue: [:])
    }
    
    open func valueDictionary<T: Transformation>(transformWith transformation: T, defaultValue: [String: T.Object]) -> [String: T.Object] {
        return transformDictionaryWith(transformation) ?? defaultValue
    }
    
    open func object<T: Deserializable>() -> T? {
        return objectMapper.map(json.unbox)
    }
    
    open func objectArray<T: Deserializable>() -> [T]? {
        return objectMapper.mapArray(json.unbox)
    }

    open func objectDictionary<T: Deserializable>() -> [String: T]? {
        return objectMapper.mapDictionary(json.unbox)
    }
    
    open func setValue<T: AnyObject>(_ value: T?) {
        json.unbox.object = value ?? NSNull()
    }
    
    open func setValue<T, Transform: Transformation>
            (_ value: T?, transformWith transformation: Transform) where Transform.Object == T {
        json.unbox.object = transformation.transformToJSON(value).object
    }
    
    open func setValueArray<T, Transform: Transformation>
            (_ array: [T]?, transformWith transformation: Transform) where Transform.Object == T {
        json.unbox.object = array?.map {
            transformation.transformToJSON($0).object
        } ?? NSNull()
    }
    
    open func setValueDictionary<T, Transform: Transformation>
            (_ dictionary: [String: T]?, transformWith transformation: Transform) where Transform.Object == T {
        json.unbox.object = dictionary?.map {
            transformation.transformToJSON($0).object
        } ?? NSNull()
    }
    
    open func setObject<T: Serializable>(_ object: T?) {
        if let unwrappedObject = object {
            json.unbox.object = objectMapper.toJSON(unwrappedObject).object
        } else {
            json.unbox.object = NSNull()
        }
    }
    
    open func setObjectArray<T: Serializable>(_ objectArray: [T]?) {
        if let unwrappedObjectArray = objectArray {
            json.unbox.object = objectMapper.toJSONArray(unwrappedObjectArray).object
        } else {
            json.unbox.object = NSNull()
        }
    }
    
    open func setObjectDictionary<T : Serializable>(_ objectDictionary: [String : T]?) {
        if let unwrappedObjectDictionary = objectDictionary {
            json.unbox.object = objectMapper.toJSONDictionary(unwrappedObjectDictionary).object
        } else {
            json.unbox.object = NSNull()
        }
    }
    
    open func assignValueTo<T>(_ field: inout T) {
        if let value: T = value() {
            field = value
        }
    }
    
    open func assignValueTo<T>(_ field: inout T!) {
        if let value: T = value() {
            field = value
        }
    }
    
    open func assignValueTo<T>(_ field: inout T?) {
        if let value: T = value() {
            field = value
        }
    }
    
    open func assignValueTo<T, Transform: Transformation>
            (_ field: inout T, transformWith transformation: Transform) where Transform.Object == T {
        if let value: T = transformation.transformFromJSON(json.unbox) {
            field = value
        }
    }
    
    open func assignValueTo<T, Transform: Transformation>
            (_ field: inout T!, transformWith transformation: Transform) where Transform.Object == T {
        if let value: T = transformation.transformFromJSON(json.unbox) {
            field = value
        }
    }
    
    open func assignValueTo<T, Transform: Transformation>
            (_ field: inout T?, transformWith transformation: Transform) where Transform.Object == T {
        if let value: T = transformation.transformFromJSON(json.unbox) {
            field = value
        }
    }

    open func assignValueArrayTo<T, Transform:Transformation>
            (_ field: inout [T]?, transformWith transformation: Transform) where Transform.Object == T {
        if let array = transformArrayWith(transformation) {
            field = array
        }
    }

    open func assignValueArrayTo<T, Transform:Transformation>
            (_ field: inout [T]!, transformWith transformation: Transform) where Transform.Object == T {
        if let array = transformArrayWith(transformation) {
            field = array
        }
    }

    open func assignValueArrayTo<T, Transform:Transformation>
            (_ field: inout [T], transformWith transformation: Transform) where Transform.Object == T {
        if let array = transformArrayWith(transformation) {
            field = array
        }
    }

    open func assignValueDictionaryTo<T, Transform: Transformation>
            (_ field: inout [String:T]?, transformWith transformation: Transform) where Transform.Object == T {
        if let dictionary = transformDictionaryWith(transformation) {
            field = dictionary
        }
    }

    open func assignValueDictionaryTo<T, Transform:Transformation>
            (_ field: inout [String:T]!, transformWith transformation: Transform) where Transform.Object == T {
        if let dictionary = transformDictionaryWith(transformation) {
            field = dictionary
        }
    }

    open func assignValueDictionaryTo<T, Transform:Transformation>
            (_ field: inout [String:T], transformWith transformation: Transform) where Transform.Object == T {
        if let dictionary = transformDictionaryWith(transformation) {
            field = dictionary
        }
    }

    open func assignObjectTo<T: Deserializable>(_ field: inout T) {
        if let object: T = object() {
            field = object
        }
    }
    
    open func assignObjectTo<T: Deserializable>(_ field: inout T!) {
        if let object: T = object() {
            field = object
        }
    }
    
    open func assignObjectTo<T: Deserializable>(_ field: inout T?) {
        if let object: T = object() {
            field = object
        }
    }
    
    open func assignObjectArrayTo<T: Deserializable>(_ field: inout [T]) {
        if let objectArray: [T] = objectArray() {
            field = objectArray
        }
    }

    open func assignObjectArrayTo<T: Deserializable>(_ field: inout [T]!) {
        if let objectArray: [T] = objectArray() {
            field = objectArray
        }
    }

    open func assignObjectArrayTo<T: Deserializable>(_ field: inout [T]?) {
        if let objectArray: [T] = objectArray() {
            field = objectArray
        }
    }

    open func assignObjectDictionaryTo<T: Deserializable>(_ field: inout [String: T]) {
        if let objectDictionary: [String: T] = objectDictionary() {
            field = objectDictionary
        }
    }

    open func assignObjectDictionaryTo<T: Deserializable>(_ field: inout [String: T]!) {
        if let objectDictionary: [String: T] = objectDictionary() {
            field = objectDictionary
        }
    }

    open func assignObjectDictionaryTo<T: Deserializable>(_ field: inout [String: T]?) {
        if let objectDictionary: [String: T] = objectDictionary() {
            field = objectDictionary
        }
    }

    fileprivate func transformArrayWith<T: Transformation>(_ transformation: T) -> [T.Object]? {
        if (json.unbox.type == .array) {
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

    fileprivate func transformDictionaryWith<T: Transformation>(_ transformation: T) -> [String:T.Object]? {
        if (json.unbox.type == .dictionary) {
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

open class ChildMap: BaseMap {
    open let parentMap: Map
    open let path: [SubscriptType]

    public init(parentMap: Map, path: [SubscriptType] = []) {
        self.parentMap = parentMap
        self.path = path
        
        let jsonBox = JSONBox(read: { parentMap.json.unbox[path] },
            write: { parentMap.json.unbox[path].object = $0.object })
        
        super.init(objectMapper: parentMap.objectMapper, mappingDirection: parentMap.direction, jsonBox: jsonBox)
    }
}

extension Map {
    public func mapValueTo<T, Transform: Transformation>
        (field: inout T, transformWith transformation: Transform) where Transform.Object == T {
        switch direction {
        case .fromJSON:
            if let value = value(transformWith: transformation) {
                field = value
            }
        case .toJSON:
            setValue(field, transformWith: transformation)
        }
    }

    public func mapValueTo<T, Transform: Transformation>
        (field: inout T!, transformWith transformation: Transform) where Transform.Object == T {
        switch direction {
        case .fromJSON:
            if let value = value(transformWith: transformation) {
                field = value
            }
        case .toJSON:
            setValue(field, transformWith: transformation)
        }
    }

    public func mapValueTo<T, Transform: Transformation>
        (field: inout T?, transformWith transformation: Transform) where Transform.Object == T {
        switch direction {
        case .fromJSON:
            if let value = value(transformWith: transformation) {
                field = value
            }
        case .toJSON:
            setValue(field, transformWith: transformation)
        }
    }

    public func mapValueArrayTo<T, Transform: Transformation>
        (field: inout [T], transformWith transformation: Transform) where Transform.Object == T {
        switch direction {
        case .fromJSON:
            field = valueArray(transformWith: transformation)
        case .toJSON:
            setValueArray(field, transformWith: transformation)
        }
    }

    public func mapValueArrayTo<T, Transform: Transformation>
        (field: inout [T]!, transformWith transformation: Transform) where Transform.Object == T {
        switch direction {
        case .fromJSON:
            field = valueArray(transformWith: transformation)
        case .toJSON:
            setValueArray(field, transformWith: transformation)
        }
    }

    public func mapValueArrayTo<T, Transform: Transformation>
        (field: inout [T]?, transformWith transformation: Transform) where Transform.Object == T {
        switch direction {
        case .fromJSON:
            field = valueArray(transformWith: transformation)
        case .toJSON:
            setValueArray(field, transformWith: transformation)
        }
    }

    public func mapValueDictionaryTo<T, Transform: Transformation>
        (field: inout [String:T], transformWith transformation: Transform) where Transform.Object == T {
        switch direction {
        case .fromJSON:
            field = valueDictionary(transformWith: transformation)
        case .toJSON:
            setValueDictionary(field, transformWith: transformation)
        }
    }

    public func mapValueDictionaryTo<T, Transform: Transformation>
        (field: inout [String:T]!, transformWith transformation: Transform) where Transform.Object == T {
        switch direction {
        case .fromJSON:
            field = valueDictionary(transformWith: transformation)
        case .toJSON:
            setValueDictionary(field, transformWith: transformation)
        }
    }

    public func mapValueDictionaryTo<T, Transform: Transformation>
        (field: inout [String:T]?, transformWith transformation: Transform) where Transform.Object == T {
        switch direction {
        case .fromJSON:
            field = valueDictionary(transformWith: transformation)
        case .toJSON:
            setValueDictionary(field, transformWith: transformation)
        }
    }

    public func mapObjectTo<T: Mappable>(field: inout T) {
        switch direction {
        case .fromJSON:
            if let object: T = object() {
                field = object
            }
        case .toJSON:
            setObject(field)
        }
    }

    public func mapObjectTo<T: Mappable>(field: inout T!) {
        switch direction {
        case .fromJSON:
            if let object: T = object() {
                field = object
            }
        case .toJSON:
            setObject(field)
        }
    }

    public func mapObjectTo<T: Mappable>(field: inout T?) {
        switch direction {
        case .fromJSON:
            if let object: T = object() {
                field = object
            }
        case .toJSON:
            setObject(field)
        }
    }

    public func mapObjectArrayTo<T: Mappable>(field: inout [T]) {
        switch direction {
        case .fromJSON:
            if let objectArray: [T] = objectArray() {
                field = objectArray
            }
        case .toJSON:
            setObjectArray(field)
        }
    }

    public func mapObjectArrayTo<T: Mappable>(field: inout [T]!) {
        switch direction {
        case .fromJSON:
            if let objectArray: [T] = objectArray() {
                field = objectArray
            }
        case .toJSON:
            setObjectArray(field)
        }
    }

    public func mapObjectArrayTo<T: Mappable>(field: inout [T]?) {
        switch direction {
        case .fromJSON:
            if let objectArray: [T] = objectArray() {
                field = objectArray
            }
        case .toJSON:
            setObjectArray(field)
        }
    }

    public func mapObjectDictionaryTo<T: Mappable>(field: inout [String: T]) {
        switch direction {
        case .fromJSON:
            if let objectDictionary: [String: T] = objectDictionary() {
                field = objectDictionary
            }
        case .toJSON:
            setObjectDictionary(field)
        }
    }

    public func mapObjectDictionaryTo<T: Mappable>(field: inout [String: T]!) {
        switch direction {
        case .fromJSON:
            if let objectDictionary: [String: T] = objectDictionary() {
                field = objectDictionary
            }
        case .toJSON:
            setObjectDictionary(field)
        }
    }

    public func mapObjectDictionaryTo<T: Mappable>(field: inout [String: T]?) {
        switch direction {
        case .fromJSON:
            if let objectDictionary: [String: T] = objectDictionary() {
                field = objectDictionary
            }
        case .toJSON:
            setObjectDictionary(field)
        }
    }
    
}
