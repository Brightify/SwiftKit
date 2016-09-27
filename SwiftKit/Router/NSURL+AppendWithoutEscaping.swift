//
//  NSURL+AppendWithoutEscaping.swift
//  Pods
//
//  Created by Tadeas Kriz on 27/07/15.
//
//

import Foundation

internal extension URL {
    
    internal func URLByAppendingPathComponentWithoutEscape(_ pathComponent: String) -> URL? {
        guard pathComponent.characters.count != 0 else { return self }
        let baseUrl = absoluteString
        let baseUrlLastCharacter = baseUrl[baseUrl.characters.index(before: baseUrl.endIndex)]
        let pathComponentFirstCharacter = pathComponent[pathComponent.startIndex]
        
        let urlString: String
        if (baseUrlLastCharacter != "/" && pathComponentFirstCharacter != "/") {
            urlString = baseUrl + "/" + pathComponent
        } else if (baseUrlLastCharacter == "/" && pathComponentFirstCharacter == "/") {
            urlString = baseUrl + pathComponent.substring(from: pathComponent.characters.index(after: pathComponent.startIndex))
        } else {
            urlString = baseUrl + pathComponent
        }
        
        return URL(string: urlString)
    }
}
