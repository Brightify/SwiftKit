//
//  String+UrlSafe.swift
//  Pods
//
//  Created by Tadeáš Kříž on 6/6/15.
//
//

extension String {
 
    /// Contains String with valid characters for URL fragment
    public var urlFragmentSafe: String! {
        return stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLFragmentAllowedCharacterSet())
    }
    
    /// Contains String with valid characters for URL host
    public var urlHostSafe: String! {
        return stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLHostAllowedCharacterSet())
    }
    
    /// Contains String with valid characters for URL password
    public var urlPasswordSafe: String! {
        return stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLPasswordAllowedCharacterSet())
    }
    
    /// Contains String with valid characters for URL path
    public var urlPathSafe: String! {
        return stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLPathAllowedCharacterSet())
    }
    
    /// Contains String with valid characters for URL query
    public var urlQuerySafe: String! {
        return stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())
    }
    
    /// Contains String with valid characters for URL user
    public var urlUserSafe: String! {
        return stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLUserAllowedCharacterSet())
    }
    
}