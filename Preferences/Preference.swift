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
            preferences.synchronize()
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
            let wrapper = preferences.objectForKey(key) as? Wrapper<T>
            if let data = wrapper?.data {
                return data
            } else {
                fatalError("Preference with key \(key) isn't of requested type.")
            }
        } set {
            let wrapper = Wrapper(data: newValue)
            preferences.setObject(wrapper, forKey: key)
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