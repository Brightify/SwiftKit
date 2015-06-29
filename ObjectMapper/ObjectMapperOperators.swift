//
//  ObjectMapperOperators.swift
//  Pods
//
//  Created by Tadeáš Kříž on 6/25/15.
//
//

infix operator <- {}

public func <- <T>(inout field: T, map: Map) {
    switch(map.direction) {
    case .FromJSON:
        map.assignValueTo(&field)
    case .ToJSON:
        map.setValue(field as? AnyObject)
    }
}

public func <- <T>(inout field: T?, map: Map) {
    switch(map.direction) {
    case .FromJSON:
        map.assignValueTo(&field)
    case .ToJSON:
        map.setValue(field as? AnyObject)
    }
}

public func <- <T>(inout field: T!, map: Map) {
    switch(map.direction) {
    case .FromJSON:
        map.assignValueTo(&field)
    case .ToJSON:
        map.setValue(field as? AnyObject)
    }
}


public func <- <T: Mappable>(inout field: T, map: Map) {
    switch(map.direction) {
    case .FromJSON:
        map.assignObjectTo(&field)
    case .ToJSON:
        map.setObject(field)
    }
}

public func <- <T: Mappable>(inout field: T?, map: Map) {
    switch(map.direction) {
    case .FromJSON:
        map.assignObjectTo(&field)
    case .ToJSON:
        map.setObject(field)
    }
}

public func <- <T: Mappable>(inout field: T!, map: Map) {
    switch(map.direction) {
    case .FromJSON:
        map.assignObjectTo(&field)
    case .ToJSON:
        map.setObject(field)
    }
}


public func <- <T: Mappable>(inout field: [T], map: Map) {
    switch(map.direction) {
    case .FromJSON:
        map.assignObjectArrayTo(&field)
    case .ToJSON:
        map.setObjectArray(field)
    }
}