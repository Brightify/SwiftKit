//
//  DictionaryPreference.swift
//  Pods
//
//  Created by Filip Dolník on 25.05.15.
//
//

import Foundation

public class DictionaryPreference<K: Hashable, T>: Preference<[K:T]> {
    
    public override init(key: String, defaultValue: [K:T] = [:]) {
        super.init(key: key, defaultValue: defaultValue)
    }
    
}