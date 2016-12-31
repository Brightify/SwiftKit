//
//  JsonSerializer.swift
//  SwiftKit
//
//  Created by Filip Dolnik on 28.10.16.
//  Copyright © 2016 Brightify. All rights reserved.
//

import SwiftyJSON

public struct JsonSerializer: TypedSerializer {
    
    public init() {
    }
    
    public func typedSerialize(_ supportedType: SupportedType) -> JSON {
        return JSON(serializeToAny(supportedType))
    }
    
    public func serialize(_ supportedType: SupportedType) -> Data {
        return (try? typedSerialize(supportedType).rawData()) ?? Data()
    }
    
    public func typedDeserialize(_ data: JSON) -> SupportedType {
        return deserializeToSupportedType(data)
    }
    
    public func deserialize(_ data: Data) -> SupportedType {
        return typedDeserialize(JSON(data: data))
    }
    
    private func serializeToAny(_ supportedType: SupportedType) -> Any {
        switch supportedType {
        case .null:
            return NSNull()
        case .string(let string):
            return string
        case .number(let number):
            return number.double ?? number.int
        case .bool(let bool):
            return bool
        case .array(let array):
            return array.map { serializeToAny($0) }
        case .dictionary(let dictionary):
            return dictionary.mapValue { serializeToAny($0) }
        }
    }
    
    private func deserializeToSupportedType(_ json: JSON) -> SupportedType {
        switch json.type {
        case .array:
            return .array(json.array!.map { deserializeToSupportedType($0) })
        case .dictionary:
            return .dictionary(json.dictionary!.mapValue { deserializeToSupportedType($0) })
        case .string:
            return .string(json.string!)
        case .number:
            let double = json.number!.doubleValue
            if double.truncatingRemainder(dividingBy: 1) == 0 {
                return .number(SupportedNumber(int: json.number!.intValue, double: double))
            } else {
                return .double(double)
            }
        case .bool:
            return .bool(json.bool!)
        default:
            return .null
        }
    }
}
