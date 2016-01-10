//
//  DictionaryPreference.swift
//  SwiftKit
//
//  Created by Maros Seleng on 10/01/16.
//  Copyright © 2016 Brightify.org. All rights reserved.
//

public class DictionaryPreference<K: NSObject, V: AnyObject>: Preference {
    
    public typealias T = [K : V]
    
    public private(set) lazy var onValueChange = Event<DictionaryPreference<K,V>,T>()
    
    private lazy var preferences: NSUserDefaults = NSUserDefaults.standardUserDefaults()
    
    private let key: String
    private let defaultValue: T
    
    public var value: T {
        get {
            return exists ? preferences.objectForKey(key) as! T : defaultValue
        }
        set {
            preferences.setObject(newValue, forKey: key)
            onValueChange.fire(self, input: newValue)
        }
    }
    
    public var exists: Bool {
        return preferences.objectForKey(key) as? T != nil
    }
    
    public required init(key: String, defaultValue: T = [:]) {
        self.key = key
        self.defaultValue = defaultValue
    }
    
    public func delete() {
        preferences.removeObjectForKey(key)
    }
}
