//
//  Map.swift
//  Pods
//
//  Created by Tadeáš Kříž on 6/26/15.
//
//

import Foundation
import SwiftyJSON

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
    
    public func object<T: Mappable>() -> T? {
        return objectMapper.map(json.unbox)
    }
    
    public func objectArray<T: Mappable>() -> [T]? {
        return objectMapper.mapArray(json.unbox)
    }
    
    public func setValue<T: AnyObject>(value: T?) {
        json.unbox.object = value ?? NSNull()
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

    public init(parentMap: Map, path: [SubscriptType] = []) {
        self.parentMap = parentMap
        self.path = path
        
        let jsonBox = JSONBox(read: { parentMap.json.unbox[path] },
            write: { parentMap.json.unbox[path].object = $0.object })
        
        super.init(objectMapper: parentMap.objectMapper, mappingDirection: parentMap.direction, jsonBox: jsonBox)
    }
}