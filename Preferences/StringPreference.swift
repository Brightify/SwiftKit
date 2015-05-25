//
//  StringPreference.swift
//  Pods
//
//  Created by Filip Dolník on 25.05.15.
//
//

public typealias StringPreference = __StringPreferencePrivate<String>

public class __StringPreferencePrivate<T>: Preference<T> {
    
    public convenience init(key: String) {
        __StringPreferencePrivate.assertType(T.self)
        
        let defaultValue = ""
        self.init(key: key, defaultValue: defaultValue as! T)
    }
    
    public override init(key: String, defaultValue: T) {
        __StringPreferencePrivate.assertType(T.self)
        
        super.init(key: key, defaultValue: defaultValue)
    }
    
    private class func assertType(type: Any.Type) {
        assert(type is String.Type, "")
    }
    
}