//
//  BoolPreference.swift
//  Pods
//
//  Created by Filip Dolník on 25.05.15.
//
//

import Foundation

public typealias BoolPreference = __BoolPreferencePrivate<Bool>

public class __BoolPreferencePrivate<T>: Preference<T> {
    
    override var valueDelegate: T {
        get {
            return preferences.boolForKey(key) as! T
        } set {
            preferences.setBool(newValue as! Bool, forKey: key)
        }
    }
    
    public convenience init(key: String) {
        __BoolPreferencePrivate.assertType(T.self)
        
        let defaultValue: Bool = false
        self.init(key: key, defaultValue: defaultValue as! T)
    }
    
    public override init(key: String, defaultValue: T) {
        __BoolPreferencePrivate.assertType(T.self)
        
        super.init(key: key, defaultValue: defaultValue)
    }
    
    private class func assertType(type: Any.Type) {
        assert(type is Bool.Type, "")
    }
    
}
