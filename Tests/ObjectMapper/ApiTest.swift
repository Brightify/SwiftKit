//
//  ProtocolApiTest.swift
//  SwiftKit
//
//  Created by Filip Dolnik on 24.12.16.
//  Copyright © 2016 Brightify. All rights reserved.
//

import Foundation
import SwiftKit

private struct PolymorphInstance: Polymorph {
    
    func polymorphType<T>(for type: T.Type, in supportedType: SupportedType) -> T.Type {
        return type
    }
    
    func writeTypeInfo<T>(to supportedType: inout SupportedType, of type: T.Type) {
    }
}

private struct SerializerInstance: Serializer {
    
    func serialize(_ supportedType: SupportedType) -> Data {
        return Data()
    }
    
    func deserialize(_ data: Data) -> SupportedType {
        return .null
    }
}

private struct TypedSerializerInstance: TypedSerializer {
    
    typealias DataType = Int
    
    func serialize(_ supportedType: SupportedType) -> Data {
        return Data()
    }
    
    func deserialize(_ data: Data) -> SupportedType {
        return .null
    }
    
    func typedSerialize(_ supportedType: SupportedType) -> Int {
        return 0
    }
    
    func typedDeserialize(_ data: Int) -> SupportedType {
        return .null
    }
}

private struct MappableDataInstance: MappableData {
    
    subscript(path: [String]) -> MappableData {
        get {
            return self
        }
        set {
        }
    }
    
    subscript(path: String...) -> MappableData {
        get {
            return self[path]
        }
        set {
        }
    }
    
    mutating func map<T: Mappable>(_ value: inout T?) {
    }
    
    mutating func map<T: Mappable>(_ value: inout T, or: T) {
    }
    
    mutating func map<T: Mappable>(_ value: inout T) throws {
    }
    
    mutating func map<T: Mappable>(_ array: inout [T]?) {
    }
    
    mutating func map<T: Mappable>(_ array: inout [T], or: [T]) {
    }
    
    mutating func map<T: Mappable>(_ array: inout [T]) throws {
    }
    
    mutating func map<T: Mappable>(_ array: inout [T?]?) {
    }
    
    mutating func map<T: Mappable>(_ array: inout [T?], or: [T?]) {
    }
    
    mutating func map<T: Mappable>(_ array: inout [T?]) throws {
    }
    
    mutating func map<T: Mappable>(_ dictionary: inout [String: T]?) {
    }
    
    mutating func map<T: Mappable>(_ dictionary: inout [String: T], or: [String: T]) {
    }
    
    mutating func map<T: Mappable>(_ dictionary: inout [String: T]) throws {
    }
    
    mutating func map<T: Mappable>(_ dictionary: inout [String: T?]?) {
    }
    
    mutating func map<T: Mappable>(_ dictionary: inout [String: T?], or: [String: T?]) {
    }
    
    mutating func map<T: Mappable>(_ dictionary: inout [String: T?]) throws {
    }
    
    mutating func map<T, R: Transformation>(_ value: inout T?, using transformation: R) where R.Object == T {
    }
    
    mutating func map<T, R: Transformation>(_ value: inout T, using transformation: R, or: T) where R.Object == T {
    }
    
    mutating func map<T, R: Transformation>(_ value: inout T, using transformation: R) throws where R.Object == T {
    }
    
    mutating func map<T, R: Transformation>(_ array: inout [T]?, using transformation: R) where R.Object == T {
    }
    
    mutating func map<T, R: Transformation>(_ array: inout [T], using transformation: R, or: [T]) where R.Object == T {
    }
    
    mutating func map<T, R: Transformation>(_ array: inout [T], using transformation: R) throws where R.Object == T {
    }
    
    mutating func map<T, R: Transformation>(_ array: inout [T?]?, using transformation: R) where R.Object == T {
    }
    
    mutating func map<T, R: Transformation>(_ array: inout [T?], using transformation: R, or: [T?]) where R.Object == T {
    }
    
    mutating func map<T, R: Transformation>(_ array: inout [T?], using transformation: R) throws where R.Object == T {
    }
    
    mutating func map<T, R: Transformation>(_ dictionary: inout [String: T]?, using transformation: R) where R.Object == T {
    }
    
    mutating func map<T, R: Transformation>(_ dictionary: inout [String: T], using transformation: R, or: [String: T]) where R.Object == T {
    }
    
    mutating func map<T, R: Transformation>(_ dictionary: inout [String: T], using transformation: R) throws where R.Object == T {
    }
    
    mutating func map<T, R: Transformation>(_ dictionary: inout [String: T?]?, using transformation: R) where R.Object == T {
    }
    
    mutating func map<T, R: Transformation>(_ dictionary: inout [String: T?], using transformation: R, or: [String: T?]) where R.Object == T {
    }
    
    mutating func map<T, R: Transformation>(_ dictionary: inout [String: T?], using transformation: R) throws where R.Object == T {
    }
}

private struct DeserializableInstance: Deserializable {
    
    init(_ data: DeserializableData) throws {
    }
}

private struct MappableInstance: Mappable {
    
    init(_ data: DeserializableData) throws {
    }
    
    mutating func mapping(_ data: inout MappableData) throws {
    }
}

private struct SerializableInstance: Serializable {
    
    func serialize(to data: inout SerializableData) {
    }
}

private struct PolymorphicInfoInstance: PolymorphicInfo {
    
    var type: Polymorphic.Type = PolymorphicInfoInstance.self as! Polymorphic.Type
    
    var name: String = ""
    
    var registeredSubtypes: [Polymorphic.Type] = []
}

private struct PolymorphicInstance: Polymorphic {
    
    static var polymorphicKey: String = ""
    
    static var polymorphicInfo: PolymorphicInfo = PolymorphicInfoInstance()
}

private struct PolymorphicDeserializableInstance: PolymorphicDeserializable {
    
    static var polymorphicKey: String = ""
    
    static var polymorphicInfo: PolymorphicInfo = PolymorphicInfoInstance()
    
    init(_ data: DeserializableData) throws {
    }
}

private struct PolymorphicMappableInstance: PolymorphicMappable {
    
    static var polymorphicKey: String = ""
    
    static var polymorphicInfo: PolymorphicInfo = PolymorphicInfoInstance()
    
    init(_ data: DeserializableData) throws {
    }
    
    mutating func mapping(_ data: inout MappableData) throws {
    }
}

private struct PolymorphicSerializableInstance: PolymorphicSerializable {
    
    static var polymorphicKey: String = ""
    
    static var polymorphicInfo: PolymorphicInfo = PolymorphicInfoInstance()
    
    func serialize(to data: inout SerializableData) {
    }
}

private struct CompositeTransformationInstance: CompositeTransformation {
    
    typealias Object = String
    
    typealias TransitiveObject = Int
    
    var transformationDelegate = IntTransformation().typeErased()
    
    func convert(object: String?) -> Int? {
        return nil
    }
    
    func convert(from value: Int?) -> String? {
        return nil
    }
}

private struct DelegatedTransformationInstance: DelegatedTransformation {
    
    typealias Object = Int
    
    var transformationDelegate = IntTransformation().typeErased()
}

private struct SupportedTypeConvertibleInstance: SupportedTypeConvertible {

    static var defaultTransformation: AnyTransformation<SupportedTypeConvertibleInstance> {
        return AnyTransformation(transformFrom: { _ in nil }, transformObject: { _ in .null })
    }
}

private struct TransformationInstance: Transformation {
    
    typealias Object = Int
    
    func transform(object: Int?) -> SupportedType {
        return .null
    }
    
    func transform(from value: SupportedType) -> Int? {
        return nil
    }
}

private struct CompositeDeserializableTransformationInstance: CompositeDeserializableTransformation {
    
    typealias Object = String
    
    typealias TransitiveObject = Int
    
    var deserializableTransformationDelegate: AnyDeserializableTransformation<Int> = IntTransformation().typeErased()
    
    func convert(from value: Int?) -> String? {
        return nil
    }
}

private struct DelegatedDeserializableTransformationInstance: DelegatedDeserializableTransformation {
    
    typealias Object = Int
    
    var deserializableTransformationDelegate: AnyDeserializableTransformation<Int> = IntTransformation().typeErased()
}

private struct DeserializableSupportedTypeConvertibleInstance: DeserializableSupportedTypeConvertible {
    
    static var defaultDeserializableTransformation: AnyDeserializableTransformation<DeserializableSupportedTypeConvertibleInstance> {
        return AnyDeserializableTransformation(transformFrom: { _ in nil })
    }
}

private struct DeserializableTransformationInstance: DeserializableTransformation {
    
    typealias Object = Int
    
    func transform(from value: SupportedType) -> Int? {
        return nil
    }
}

private struct CompositeSerializableTransformationInstance: CompositeSerializableTransformation {
    
    typealias Object = String
    
    typealias TransitiveObject = Int
    
    var serializableTransformationDelegate: AnySerializableTransformation<Int> = IntTransformation().typeErased()
    
    func convert(object: String?) -> Int? {
        return nil
    }
}

private struct DelegatedSerializableTransformationInstance: DelegatedSerializableTransformation {
    
    typealias Object = Int
    
    var serializableTransformationDelegate: AnySerializableTransformation<Int> = IntTransformation().typeErased()
}

private struct SerializableSupportedTypeConvertibleInstance: SerializableSupportedTypeConvertible {
    
    static var defaultSerializableTransformation: AnySerializableTransformation<SerializableSupportedTypeConvertibleInstance> {
        return AnySerializableTransformation(transformObject: { _ in .null })
    }
}

private struct SerializableTransformationInstance: SerializableTransformation {
    
    typealias Object = Int
    
    func transform(object: Int?) -> SupportedType {
        return .null
    }
}
