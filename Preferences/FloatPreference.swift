//
//  FloatPreference.swift
//  
//
//  Created by Filip Dolník on 25.05.15.
//
//

import Foundation

public class FloatPreferenceImpl<T>: BasePreference<Float> {
    
    override var valueDelegate: Float {
        get {
            return preferences.floatForKey(key)
        } set {
            preferences.setFloat(newValue, forKey: key)
        }
    }
    
    override init(key: String, defaultValue: Float = 0) {
        super.init(key: key, defaultValue: defaultValue)
    }
    
    override func areEquals(first: Float, _ second: Float) -> Bool {
        return first == second
    }
}

public typealias FloatPreference = FloatPreferenceImpl<Float>