//
//  StringPreference.swift
//  
//
//  Created by Filip Dolník on 25.05.15.
//
//

import Foundation

public class StringPreferenceImpl<T>: BasePreference<String> {
    
    override var valueDelegate: String {
        get {
            return preferences.StringForKey(key)
        } set {
            preferences.setString(newValue, forKey: key)
        }
    }
    
    override init(key: String, defaultValue: String = "") {
        super.init(key: key, defaultValue: defaultValue)
    }
    
    override func areEquals(first: String, _ second: String) -> Bool {
        return first == second
    }
}

public typealias StringPreference = StringPreferenceImpl<String>