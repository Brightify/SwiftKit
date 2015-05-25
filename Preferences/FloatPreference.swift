//
//  FloatPreference.swift
//  Pods
//
//  Created by Filip Dolník on 25.05.15.
//
//

import Foundation

public typealias FloatPreference = __FloatPreferencePrivate<Float>

public class __FloatPreferencePrivate<T>: Preference<T> {
    
    override var valueDelegate: T {
        get {
            return preferences.floatForKey(key) as! T
        } set {
            preferences.setFloat(newValue as! Float, forKey: key)
        }
    }
    
    public convenience init(key: String) {
        __FloatPreferencePrivate.assertType(T.self)
        
        let defaultValue: Float = 0
        self.init(key: key, defaultValue: defaultValue as! T)
    }
    
    public override init(key: String, defaultValue: T) {
        __FloatPreferencePrivate.assertType(T.self)
        
        super.init(key: key, defaultValue: defaultValue)
    }
    
    private class func assertType(type: Any.Type) {
        assert(type is Float.Type, "")
    }
    
}