//
//  String+UrlSafe.swift
//  Pods
//
//  Created by Tadeáš Kříž on 6/6/15.
//
//

extension String {
 
    /// Contains String with valid characters for URL
    public var urlSafe: String! {
        return stringByAddingPercentEncodingWithAllowedCharacters(
            NSCharacterSet.URLHostAllowedCharacterSet())
    }
    
}