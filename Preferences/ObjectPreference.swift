//
//  ObjectPreference.swift
//  Pods
//
//  Created by Filip Dolník on 25.05.15.
//
//

import Foundation

public class ObjectPreference<T: AnyObject> {
    
    let key: String
    let defaultValue: T?
    let onValueChangeEvent = Event<ObjectPreference<T>, T?>()
    
    private var preferences: NSUserDefaults {
        return NSUserDefaults.standardUserDefaults()
    }
    
    public var value: T? {
        get {
            return exists ? preferences.objectForKey(key) as? T : defaultValue
        } set {
            let currentValue = value
            preferences.setObject(newValue, forKey: key)
            preferences.synchronize()
            onValueChangeEvent.fire(self, input: newValue)
        }
    }
    
    public var exists: Bool {
        get {
            return preferences.objectForKey(key) != nil
        }
    }
    
    public init(key: String, defaultValue: T? = nil) {
        self.key = key
        self.defaultValue = defaultValue
    }
    
    public func delete() {
        preferences.removeObjectForKey(key)
    }
}