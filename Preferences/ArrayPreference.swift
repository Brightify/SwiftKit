//
//  ArrayPreference.swift
//  Pods
//
//  Created by Filip Dolník on 25.05.15.
//
//

import Foundation

public class ArrayPreference<T>: Preference<[T]> {
    
    public override init(key: String, defaultValue: [T] = []) {
        super.init(key: key, defaultValue: defaultValue)
    }
    
}