//
//  Preference.swift
//  Pods
//
//  Created by Filip Dolník on 26.05.15.
//
//

import Foundation

/// Protocol whose implementations help with accessing NSUserDefaults
public protocol Preference {
    
    typealias T

    /// Contains value of the Preference
    var value: T { get set }
    
    /// This is true if the Preference with correct key and type exists
    var exists: Bool { get }
    
    /**
        Initializer
    
        :param: key The key that will be used to access the Preference
        :param: defaultValue value of unset Preference
    */
    init(key: String, defaultValue: T)
    
    /// Deletes the Preference from NSUserDefaults
    func delete()
    
}