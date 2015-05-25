//
//  FloatPreference.swift
//  Pods
//
//  Created by Filip Dolník on 25.05.15.
//
//

import Foundation

public class FloatPreferenceImpl<T>: Preference<Float> {
    
    override var valueDelegate: Float {
        get {
            return preferences.floatForKey(key)
        } set {
            preferences.setFloat(newValue, forKey: key)
        }
    }
    
    public override init(key: String, defaultValue: Float = 0) {
        super.init(key: key, defaultValue: defaultValue)
    }
    
}

public typealias FloatPreference = FloatPreferenceImpl<Float>