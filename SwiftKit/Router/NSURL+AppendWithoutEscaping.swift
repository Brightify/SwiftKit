//
//  NSURL+AppendWithoutEscaping.swift
//  Pods
//
//  Created by Tadeas Kriz on 27/07/15.
//
//

import Foundation

internal extension NSURL {
    
    internal func URLByAppendingPathComponentWithoutEscape(pathComponent: String) -> NSURL? {
        guard pathComponent.characters.count != 0 else { return self }
        let baseUrl = absoluteString
        let baseUrlLastCharacter = baseUrl[baseUrl.endIndex.predecessor()]
        let pathComponentFirstCharacter = pathComponent[pathComponent.startIndex]
        
        let urlString: String
        if (baseUrlLastCharacter != "/" && pathComponentFirstCharacter != "/") {
            urlString = baseUrl + "/" + pathComponent
        } else if (baseUrlLastCharacter == "/" && pathComponentFirstCharacter == "/") {
            urlString = baseUrl + pathComponent.substringFromIndex(pathComponent.startIndex.successor())
        } else {
            urlString = baseUrl + pathComponent
        }
        
        return NSURL(string: urlString)
    }
}