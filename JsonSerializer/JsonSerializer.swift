//
//  JsonSerializer.swift
//  SwiftKit
//
//  Created by Filip Dolnik on 28.10.16.
//  Copyright © 2016 Brightify. All rights reserved.
//

import SwiftyJSON

public struct JsonSerializer: Serializer {
    
    public func serialize(_ supportedType: SupportedType) -> Data {
        let json = JSON(serializeToAny(supportedType))
        return (try? json.rawData()) ?? Data()
    }
    
    public func deserialize(_ data: Data) -> SupportedType {
        return deserialize(JSON(data: data))
    }
    
    private func serializeToAny(_ supportedType: SupportedType) -> Any {
        switch supportedType {
        case .null:
            return NSNull()
        case .string(let string):
            return string
        case .int(let int):
            return int
        case .double(let double):
            return double
        case .bool(let bool):
            return bool
        case .array(let array):
            return array.map { serializeToAny($0) }
        case .dictionary(let dictionary):
            return dictionary.mapValue { serializeToAny($0) }
        }
    }
    
    private func deserialize(_ json: JSON) -> SupportedType {
        if let string = json.string {
            return .string(string)
        } else if let int = json.int {
            return .int(int)
        } else if let double = json.double {
            return .double(double)
        } else if let bool = json.bool {
            return .bool(bool)
        } else if let array = json.array {
            return .array(array.map { deserialize($0) })
        } else if let dictionary = json.dictionary {
            return .dictionary(dictionary.mapValue { deserialize($0) })
        } else {
            return .null
        }
    }
}
