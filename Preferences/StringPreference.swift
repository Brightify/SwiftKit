//
//  StringPreference.swift
//  Pods
//
//  Created by Filip Dolník on 25.05.15.
//
//

import Foundation

public class StringPreferenceImpl<T>: BaseValuePreference<String> {
    
    private let backingPreference: ObjectPreference<NSString>
    
    override var valueDelegate: String {
        get {
            if let value = backingPreference.value {
                return value as String
            }
            return defaultValue
        } set {
            backingPreference.value = NSString(UTF8String: newValue)
        }
    }
    
    public override init(key: String, defaultValue: String = "") {
        backingPreference = ObjectPreference<NSString>(key: key)
        
        super.init(key: key, defaultValue: defaultValue)
    }
    
    override func areEquals(first: String, _ second: String) -> Bool {
        return first == second
    }
}

public typealias StringPreference = StringPreferenceImpl<String>