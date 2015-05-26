//
//  FloatPreference.swift
//  Pods
//
//  Created by Filip Dolník on 25.05.15.
//
//

import Foundation

public class FloatPreference: Preference {
    
    public typealias T = Float
    
    public private(set) lazy var onValueChange = Event<FloatPreference, T>()
    
    private lazy var preferences: NSUserDefaults = NSUserDefaults.standardUserDefaults()
    
    private let key: String
    private let defaultValue: T
    
    public var value: T {
        get {
            return exists ? preferences.floatForKey(key) : defaultValue
        } set {
            preferences.setFloat(newValue, forKey: key)
            onValueChange.fire(self, input: newValue)
        }
    }
    
    public var exists: Bool {
        get {
            return preferences.objectForKey(key) as? T != nil
        }
    }
    
    public required init(key: String, defaultValue: T = 0) {
        self.key = key
        self.defaultValue = defaultValue
    }
    
    public func delete() {
        preferences.removeObjectForKey(key)
    }
}