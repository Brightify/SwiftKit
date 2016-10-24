//
//  MappableData.swift
//  SwiftKit
//
//  Created by Filip Dolnik on 21.10.16.
//  Copyright © 2016 Brightify. All rights reserved.
//

public protocol MappableData {
    
    subscript(path: [String]) -> MappableData { get }
    
    subscript(path: String...) -> MappableData { get }
    
    func map<T: SupportedTypeConvertible>(_ value: inout T?)
    
    func map<T: SupportedTypeConvertible>(_ value: inout T, or: T)
    
    func map<T: SupportedTypeConvertible>(_ array: inout [T]?)
    
    func map<T: SupportedTypeConvertible>(_ array: inout [T])
    
    func map<T: SupportedTypeConvertible>(_ array: inout [T], or: [T])
    
    func map<T: Mappable>(_ value: inout T?)
    
    func map<T: Mappable>(_ value: inout T, or: T)
    
    func map<T: Mappable>(_ array: inout [T]?)
    
    func map<T: Mappable>(_ array: inout [T])
    
    func map<T: Mappable>(_ array: inout [T], or: [T])
    
    func map<T, R: Transformation>(_ value: inout T?, using transformation: R) where R.Object == T
    
    func map<T, R: Transformation>(_ value: inout T, using transformation: R, or: T) where R.Object == T
    
    func map<T, R: Transformation>(_ array: inout [T]?, using transformation: R) where R.Object == T
    
    func map<T, R: Transformation>(_ array: inout [T], using transformation: R) where R.Object == T
    
    func map<T, R: Transformation>(_ array: inout [T], using transformation: R, or: [T]) where R.Object == T
}
