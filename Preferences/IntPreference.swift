//
//  IntPreference.swift
//  Pods
//
//  Created by Filip Dolník on 25.05.15.
//
//

import Foundation

public class IntPreferenceImpl<T>: BaseValuePreference<Int> {
    
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
    
    override func areEquals(first: Int, _ second: Int) -> Bool {
        return first == second
    }
}

public typealias IntPreference = IntPreferenceImpl<Int>