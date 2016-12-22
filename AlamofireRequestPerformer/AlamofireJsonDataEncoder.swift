//
//  AlamofireJsonDataEncoder.swift
//  SwiftKit
//
//  Created by Filip Dolnik on 10.12.16.
//  Copyright © 2016 Brightify. All rights reserved.
//

import Alamofire

// TODO Review
public struct AlamofireJsonDataEncoder: DataEncoder {
    
    private let serializer = JsonSerializer()
    
    public init() {
    }
    
    public func encodeToQueryString(input: SupportedType, to request: inout Request) {
        guard let url = request.url, var components = URLComponents(url: url, resolvingAgainstBaseURL: false) else { return }
        
        let percentEncodedQuery = (components.percentEncodedQuery.map { $0 + "&" } ?? "") + encodeParametersForURL(input)
        components.percentEncodedQuery = percentEncodedQuery
        request.url = components.url
    }
    
    public func encodeToHttpBody(input: SupportedType, to request: inout Request) {
        request.httpBody = serializer.serialize(input)
        request.modifiers.append(Headers.ContentType.applicationJson)
    }
    
    public func encodeCustom(input: SupportedType, to request: inout Request, inputEncoding: InputEncoding) {
        if inputEncoding is FormInputEncoding {
            if !request.modifiers.contains(where: { $0 is Headers.ContentType }) {
                request.modifiers.append(Headers.ContentType.applicationFormUrlencoded)
            }
            
            request.httpBody = encodeParametersForURL(input).data(using: String.Encoding.utf8, allowLossyConversion: false)
        } else {
            preconditionFailure("Unknown input encoding \(inputEncoding).")
        }
    }
    
    public func decode(response: Response<Data>) -> Response<SupportedType> {
        return response.map(serializer.deserialize)
    }

    private func encodeParametersForURL(_ parameters: SupportedType) -> String {
        return serializer.typedSerialize(parameters)
            .sorted { $0.0 < $1.0 }
            .map { ($0, $1.rawValue) }
            .map(URLEncoding.queryString.queryComponents)
            .reduce([]) { $0 + $1 }
            .map { "\($0)=\($1)" }
            .joined(separator: "&")
    }
}
