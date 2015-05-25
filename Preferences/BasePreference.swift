//
//  BasePreference.swift
//  
//
//  Created by Filip Dolník on 25.05.15.
//
//

import Foundation

public class BasePreference<T> {
    
    let key: String
    let defaultValue: T
    let onValueChangeEvent = Event<BasePreference<T>, T>()
    
    var preferences: NSUserDefaults {
        return NSUserDefaults.standardUserDefaults()
    }
    
    public var value: T {
        get {
            return exists ? valueDelegate : defaultValue
        } set {
            let currentValue = value
            valueDelegate = newValue
            preferences.synchronize()
            if (!areEquals(currentValue, newValue)) {
                event.fire(self, newValue)
            }
        }
    }
    
    public var exists: Bool {
        get {
            return preferences.objectForKey(key) != nil
        }
    }
    
    var valueDelegate: T {
        get {
            fatalError("Value in BasePreference has not been implemented!")
        } set {
            fatalError("Value in BasePreference has not been implemented!")
        }
    }
    
    init(key: String, defaultValue: T) {
        self.key = key
        self.defaultValue = defaultValue

    }
    
    public func delete() {
        preferences.removeObjectForKey(key)
    }
    
    func areEquals(first: T, _ second: T) -> Bool {
        fatalError("areEquals in BasePreference has not been implemented!")
    }
}