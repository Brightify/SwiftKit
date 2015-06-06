//
//  String+UrlSafe.swift
//  Pods
//
//  Created by Tadeáš Kříž on 6/6/15.
//
//

extension String {
 
    public var urlSafe: String! {
        return stringByAddingPercentEncodingWithAllowedCharacters(
            NSCharacterSet.URLHostAllowedCharacterSet())
    }
    
}