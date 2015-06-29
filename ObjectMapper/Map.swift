//
//  Map.swift
//  Pods
//
//  Created by Tadeáš Kříž on 6/26/15.
//
//

import Foundation
import SwiftyJSON

public enum MappingDirection {
    case FromJSON
    case ToJSON
}

public protocol Map: class {
    var objectMapper: ObjectMapper { get }
    var direction: MappingDirection { get }
    var json: JSON { get set }
    
    subscript(path: [SubscriptType]) -> Map { get }
    subscript(path: SubscriptType...) -> Map { get }
    
    func value<T>() -> T?
    
    func object<T: Mappable>() -> T?
    
    func objectArray<T: Mappable>() -> [T]?
    
    func setValue<T: AnyObject>(value: T?)
    
    func setObject<T: Mappable>(object: T?)
    
    func setObjectArray<T: Mappable>(objectArray: [T]?)
    
    func assignValueTo<T>(inout field: T)
    
    func assignValueTo<T>(inout field: T!)
    
    func assignValueTo<T>(inout field: T?)
    
    func assignObjectTo<T: Mappable>(inout field: T)
    
    func assignObjectTo<T: Mappable>(inout field: T!)
    
    func assignObjectTo<T: Mappable>(inout field: T?)
    
    func assignObjectArrayTo<T: Mappable>(inout field: [T])
}

public class BaseMap: Map {
    public let objectMapper: ObjectMapper
    public let direction: MappingDirection
    public var json: JSON
    
    public init(objectMapper: ObjectMapper, mappingDirection: MappingDirection, json: JSON = [:]) {
        self.objectMapper = objectMapper
        self.direction = mappingDirection
        self.json = json
    }
    
    public subscript(path: [SubscriptType]) -> Map {
        return ChildMap(parentMap: self, path: path)
    }
    
    public subscript(path: SubscriptType...) -> Map {
        return self[path]
    }
    
    public func value<T>() -> T? {
        return json.object as? T
    }
    
    public func object<T: Mappable>() -> T? {
        return objectMapper.map(json)
    }
    
    public func objectArray<T: Mappable>() -> [T]? {
        return objectMapper.mapArray(json)
    }
    
    public func setValue<T: AnyObject>(value: T?) {
        json.object = value ?? NSNull()
    }
    
    public func setObject<T: Mappable>(object: T?) {
        if let unwrappedObject = object {
            json.object = objectMapper.toJSON(unwrappedObject).object
        } else {
            json.object = NSNull()
        }
    }
    
    public func setObjectArray<T: Mappable>(objectArray: [T]?) {
        if let unwrappedObjectArray = objectArray {
            json.object = objectMapper.toJSONArray(unwrappedObjectArray).object
        } else {
            json.object = NSNull()
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
}

public class ChildMap: BaseMap {
    public let parentMap: Map
    public let path: [SubscriptType]
    
    public override var json: JSON {
        get {
            return parentMap.json[path]
        }
        set {
            parentMap.json[path].object = newValue.object
        }
    }
    
    public init(parentMap: Map, path: [SubscriptType] = []) {
        self.parentMap = parentMap
        self.path = path
        
        super.init(objectMapper: parentMap.objectMapper, mappingDirection: parentMap.direction)
    }
}