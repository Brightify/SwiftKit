//
//  OptionalPreference.swift
//  Pods
//
//  Created by Filip Dolník on 25.05.15.
//
//

import Foundation

public class OptionalPreference<T: AnyObject> {
    
    public let onValueChange = Event<OptionalPreference<T>, T?>()
    
    private let key: String
    
    private lazy var preferences: NSUserDefaults = NSUserDefaults.standardUserDefaults()
    
    public var value: T? {
        get {
            return preferences.objectForKey(key) as? T
        } set {
            preferences.setObject(newValue, forKey: key)
            onValueChange.fire(self, input: newValue)
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

