//
//  ArrayPreference.swift
//  Pods
//
//  Created by Filip Dolník on 25.05.15.
//
//

import Foundation

public class ArrayPreference<T: AnyObject>: Preference<[T]> {
    
    override var valueDelegate: [T] {
        get {
            if let array = preferences.objectForKey(key) as? [T] {
                return array
            }
            return defaultValue
        } set {
            let array = NSArray(array: newValue)
            preferences.setObject(array, forKey: key)
        }
    }
    
    public override init(key: String, defaultValue: [T] = []) {
        super.init(key: key, defaultValue: defaultValue)
    }
    
}