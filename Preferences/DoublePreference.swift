//
//  DoublePreference.swift
//  Pods
//
//  Created by Filip Dolník on 25.05.15.
//
//

import Foundation

public typealias DoublePreference = __DoublePreferencePrivate<Double>

public class __DoublePreferencePrivate<T>: Preference<T> {
    
    override var valueDelegate: T {
        get {
            return preferences.doubleForKey(key) as! T
        } set {
            preferences.setDouble(newValue as! Double, forKey: key)
        }
    }
    
    public convenience init(key: String) {
        __DoublePreferencePrivate.assertType(T.self)
        
        let defaultValue: Double = 0
        self.init(key: key, defaultValue: defaultValue as! T)
    }
    
    public override init(key: String, defaultValue: T) {
        __DoublePreferencePrivate.assertType(T.self)
        
        super.init(key: key, defaultValue: defaultValue)
    }
    
    private class func assertType(type: Any.Type) {
        assert(type is Double.Type, "")
    }
    
}