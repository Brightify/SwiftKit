//
//  MappableData.swift
//  SwiftKit
//
//  Created by Filip Dolnik on 21.10.16.
//  Copyright © 2016 Brightify. All rights reserved.
//

public protocol MappableData {
    
    subscript(path: [String]) -> MappableData { get set }
    
    subscript(path: String...) -> MappableData { get set }
    
    mutating func map<T: SupportedTypeConvertible>(_ value: inout T?)
    
    mutating func map<T: SupportedTypeConvertible>(_ value: inout T, or: T)
    
    mutating func map<T: SupportedTypeConvertible>(_ array: inout [T]?)
    
    mutating func map<T: SupportedTypeConvertible>(_ array: inout [T])
    
    mutating func map<T: SupportedTypeConvertible>(_ array: inout [T], or: [T])
    
    mutating func map<T: Mappable>(_ value: inout T?)
    
    mutating func map<T: Mappable>(_ value: inout T, or: T)
    
    mutating func map<T: Mappable>(_ array: inout [T]?)
    
    mutating func map<T: Mappable>(_ array: inout [T])
    
    mutating func map<T: Mappable>(_ array: inout [T], or: [T])
    
    mutating func map<T, R: Transformation>(_ value: inout T?, using transformation: R) where R.Object == T
    
    mutating func map<T, R: Transformation>(_ value: inout T, using transformation: R, or: T) where R.Object == T
    
    mutating func map<T, R: Transformation>(_ array: inout [T]?, using transformation: R) where R.Object == T
    
    mutating func map<T, R: Transformation>(_ array: inout [T], using transformation: R) where R.Object == T
    
    mutating func map<T, R: Transformation>(_ array: inout [T], using transformation: R, or: [T]) where R.Object == T
}
