//
//  DoublePreference.swift
//  Pods
//
//  Created by Filip Dolník on 25.05.15.
//
//

import Foundation

public class DoublePreferenceImpl<T>: BaseValuePreference<Double> {
    
    override var valueDelegate: Double {
        get {
            return preferences.doubleForKey(key)
        } set {
            preferences.setDouble(newValue, forKey: key)
        }
    }
    
    public override init(key: String, defaultValue: Double = 0) {
        super.init(key: key, defaultValue: defaultValue)
    }
    
    override func areEquals(first: Double, _ second: Double) -> Bool {
        return first == second
    }
}

public typealias DoublePreference = DoublePreferenceImpl<Double>