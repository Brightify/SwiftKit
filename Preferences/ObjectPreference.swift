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
    let onValueChangeEvent = Event<ObjectPreference<T>, T?>()
    
    private var preferences: NSUserDefaults {
        return NSUserDefaults.standardUserDefaults()
    }
    
    public var value: T? {
        get {
            return preferences.objectForKey(key) as? T
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
    
    public init(key: String) {
        self.key = key
    }
    
    public func delete() {
        preferences.removeObjectForKey(key)
    }
}