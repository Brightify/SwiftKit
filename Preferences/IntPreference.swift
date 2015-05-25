//
//  IntPreference.swift
//  Pods
//
//  Created by Filip Dolník on 25.05.15.
//
//

import Foundation

public class IntPreferenceImpl<T>: Preference<Int> {
    
    override var valueDelegate: Int {
        get {
            return preferences.integerForKey(key)
        } set {
            preferences.setInteger(newValue, forKey: key)
        }
    }
    
    public override init(key: String, defaultValue: Int = 0) {
        super.init(key: key, defaultValue: defaultValue)
    }
    
}

public typealias IntPreference = IntPreferenceImpl<Int>