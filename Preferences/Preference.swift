//
//  Preference.swift
//  Pods
//
//  Created by Filip Dolník on 25.05.15.
//
//

import Foundation

public class Preference<T> {
    
    public let onValueChange = Event<Preference<T>, T>()
    
    let key: String
    let defaultValue: T
    
    lazy var preferences: NSUserDefaults = NSUserDefaults.standardUserDefaults()

    public var value: T {
        get {
            return exists ? valueDelegate : defaultValue
        } set {
            valueDelegate = newValue
            onValueChange.fire(self, input: newValue)
        }
    }
    
    public var exists: Bool {
        get {
            return preferences.objectForKey(key) != nil
        }
    }
    
    var valueDelegate: T {
        get {
            if let data = preferences.objectForKey(key) as? T {
                return data
            } else {
                fatalError("Preference with key \(key) isn't of requested type.")
            }
        } set {
            if let newValue: AnyObject = newValue as? AnyObject {
                preferences.setObject(newValue, forKey: key)
            } else {
                fatalError("Value is not of type AnyObject.")
            }
        }
    }
    
    public init(key: String, defaultValue: T) {
        self.key = key
        self.defaultValue = defaultValue
    }
    
    public func delete() {
        preferences.removeObjectForKey(key)
    }
    
}