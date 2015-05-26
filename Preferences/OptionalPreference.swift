//
//  OptionalPreference.swift
//  Pods
//
//  Created by Filip Dolník on 25.05.15.
//
//

import Foundation

public class OptionalPreference<T: AnyObject> {
    
    public private(set) lazy var onValueChange = Event<OptionalPreference<T>, T?>()
    
    private lazy var preferences: NSUserDefaults = NSUserDefaults.standardUserDefaults()
    
    private let key: String
    
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
            return value != nil
        }
    }
    
    public init(key: String) {
        self.key = key
    }
    
    public func delete() {
        preferences.removeObjectForKey(key)
    }
    
}

