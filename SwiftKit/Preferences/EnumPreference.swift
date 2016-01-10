//
//  EnumPreference.swift
//  SwiftKit
//
//  Created by Maros Seleng on 10/01/16.
//  Copyright © 2016 Brightify.org. All rights reserved.
//

public class EnumPreference<E: RawRepresentable> {
    
    public typealias T = E
    
    public private(set) lazy var onValueChange = Event<EnumPreference<T>, T>()
    
    private lazy var preferences: NSUserDefaults = NSUserDefaults.standardUserDefaults()
    
    private let key: String
    private let defaultValue: T
    
    public var value: T {
        get {
            return exists ? T(rawValue: preferences.objectForKey(key) as! T.RawValue)! : defaultValue
        }
        set {
            preferences.setObject(newValue.rawValue as! NSObject, forKey: key)
            onValueChange.fire(self, input: newValue)
        }
    }
    
    public var exists: Bool {
        return preferences.objectForKey(key) as? T != nil
    }
    
    public init(key: String, defaultValue: T) {
        self.key = key
        self.defaultValue = defaultValue
    }
}