//
//  ArrayPreference.swift
//  Pods
//
//  Created by Filip Dolník on 25.05.15.
//
//

public class ArrayPreference<S: AnyObject>: Preference {
    
    public typealias T = [S]
    
    public private(set) lazy var onValueChange = Event<ArrayPreference<S>, T>()
    
    private lazy var preferences: NSUserDefaults = NSUserDefaults.standardUserDefaults()
    
    private let key: String
    private let defaultValue: T

    public var value: T {
        get {
            return exists ? preferences.objectForKey(key) as! T : defaultValue
        } set {
            preferences.setObject(newValue, forKey: key)
            onValueChange.fire(self, input: newValue)
        }
    }
    
    public var exists: Bool {
        get {
            return preferences.objectForKey(key) as? T != nil
        }
    }
    
    public required init(key: String, defaultValue: T = []) {
        self.key = key
        self.defaultValue = defaultValue
    }
    
    public func delete() {
        preferences.removeObjectForKey(key)
    }
}