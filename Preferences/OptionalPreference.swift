//
//  OptionalPreference.swift
//  Pods
//
//  Created by Filip Dolník on 25.05.15.
//
//

import Foundation

public class OptionalPreference<T> {
    
    public let onValueChange = Event<OptionalPreference<T>, T?>()
    
    private let key: String
    
    private lazy var preferences: NSUserDefaults = NSUserDefaults.standardUserDefaults()
    
    public var value: T? {
        get {
            let wrapper = preferences.objectForKey(key) as? Wrapper<T>
            return wrapper?.data
        } set {
            let wrapper = Wrapper(data: newValue)
            preferences.setObject(wrapper, forKey: key)
            preferences.synchronize()
            onValueChange.fire(self, input: newValue)
        }
    }
    
    public var exists: Bool {
        get {
            let wrapper = preferences.objectForKey(key) as? Wrapper<T>
            return wrapper?.data != nil
        }
    }
    
    public init(key: String) {
        self.key = key
    }
    
    public func delete() {
        preferences.removeObjectForKey(key)
    }
    
}

