//
//  IntPreference.swift
//  Pods
//
//  Created by Filip Dolník on 25.05.15.
//
//

import Foundation

public typealias IntPreference = __IntPreferencePrivate<Int>

public class __IntPreferencePrivate<T: Any>: Preference<T> {
    
    override var valueDelegate: T {
        get {
            return preferences.integerForKey(key) as! T
        } set {
            preferences.setInteger(newValue as! Int, forKey: key)
        }
    }
    
    public convenience init(key: String) {
        __IntPreferencePrivate.assertType(T.self)
        
        let defaultValue = 0
        self.init(key: key, defaultValue: defaultValue as! T)
    }
    
    public override init(key: String, defaultValue: T) {
        __IntPreferencePrivate.assertType(T.self)
        
        super.init(key: key, defaultValue: defaultValue)
    }

    private class func assertType(type: Any.Type) {
        assert(type is Int.Type, "")
    }
    
}
