//
//  StringPreference.swift
//  Pods
//
//  Created by Filip Dolník on 25.05.15.
//
//

import Foundation

public class StringPreferenceImpl<T>: Preference<String> {
    
    override var valueDelegate: String {
        get {
            if let string = preferences.objectForKey(key) as? String {
                return string
            }
            return defaultValue
        } set {
            let string = NSString(string: newValue)
            preferences.setObject(string, forKey: key)
        }
    }
    
    public override init(key: String, defaultValue: String = "") {
        super.init(key: key, defaultValue: defaultValue)
    }
    
}

public typealias StringPreference = StringPreferenceImpl<String>