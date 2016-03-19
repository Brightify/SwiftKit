//
//  Methods.swift
//  Pods
//
//  Created by Tadeáš Kříž on 6/6/15.
//
//

import Foundation
import Alamofire

/**
    Target specifies an URL in the API with parameters

    :param: ENDPOINT The endpoint in the API
    :param: PARAMS The parameters to be filled in the endpoint URL
*/
public class Target<ENDPOINT: TargetableEndpoint, PARAMS> {
    private let pathAndModifiers: PARAMS -> (String, [RequestModifier], InputEncoder?)
    
    /**
        Initializes Target with closure that returns path costructed
        from base URL and PARAMS
        
        :param: path The closure that accepts PARAMS and returns the constructed URL
    */
    public init(inputEncoder: InputEncoder? = nil, _ path: PARAMS -> String) {
        self.pathAndModifiers = { (path($0), [], inputEncoder) }
    }
    
    public init(inputEncoder: InputEncoder? = nil, _ modifiers: [RequestModifier], _ path: PARAMS -> String) {
        self.pathAndModifiers = { (path($0), modifiers, inputEncoder) }
    }
    
    public init(inputEncoder: InputEncoder? = nil, _ pathAndModifiers: PARAMS -> (String, [RequestModifier])) {
        self.pathAndModifiers = {
            let (path, modifiers) = pathAndModifiers($0)
            return (path, modifiers, inputEncoder)
        }
    }
    
    /**
        Returns an Endpoint with the path constructed from supplied PARAMS
    
        :param: params The parameters used to construct the Endpoint URL
    */
    public func endpoint(params: PARAMS) -> ENDPOINT {
        let (path, modifiers, inputEncoder) = pathAndModifiers(params)
        if let inputEncoder = inputEncoder {
            return ENDPOINT(path, modifiers, inputEncoder: inputEncoder)
        } else {
            return ENDPOINT(path, modifiers)
        }
    }
}

public class BaseEndpoint<IN, OUT>: Endpoint {
    public typealias Input = IN
    public typealias Output = OUT
    
    public let method: Alamofire.Method
    public let path: String
    public let inputEncoder: InputEncoder
    public let modifiers: [RequestModifier]
    
    public init(method: Alamofire.Method, path: String, modifiers: [RequestModifier], inputEncoder: InputEncoder) {
        self.method = method
        self.path = path
        self.inputEncoder = inputEncoder
        self.modifiers = modifiers
    }
    
    public convenience init<E: Endpoint where E.Input == IN, E.Output == OUT>(endpoint: E) {
        self.init(method: endpoint.method, path: endpoint.path, modifiers: endpoint.modifiers, inputEncoder: endpoint.inputEncoder)
    }
}

/**
 Represents Endpoint with method GET and input and output parameters
 
 :param: IN The input type
 :param: OUT The output type
 */
public final class GET<IN, OUT>: BaseEndpoint<IN, OUT>, TargetableEndpoint {
    public convenience init(_ path: String, _ modifiers: [RequestModifier]) {
        self.init(path, modifiers, inputEncoder: URLInputEncoder())
    }
    
    public init(_ path: String, _ modifiers: [RequestModifier], inputEncoder: InputEncoder) {
        super.init(method: .GET, path: path, modifiers: modifiers, inputEncoder: inputEncoder)
    }
}

/**
    Represents Endpoint with method POST and input and output parameters

    :param: IN The input type
    :param: OUT The output type
*/
public final class POST<IN, OUT>: BaseEndpoint<IN, OUT>, TargetableEndpoint {
    public convenience init(_ path: String, _ modifiers: [RequestModifier]) {
        self.init(path, modifiers, inputEncoder: JSONInputEncoder())
    }
    
    public init(_ path: String, _ modifiers: [RequestModifier], inputEncoder: InputEncoder) {
        super.init(method: .POST, path: path, modifiers: modifiers, inputEncoder: inputEncoder)
    }
}

/**
    Represents Endpoint with method PUT and input and output parameters

    :param: IN The input type
    :param: OUT The output type
*/
public final class PUT<IN, OUT>: BaseEndpoint<IN, OUT>, TargetableEndpoint {
    public convenience init(_ path: String, _ modifiers: [RequestModifier]) {
        self.init(path, modifiers, inputEncoder: JSONInputEncoder())
    }
    
    public init(_ path: String, _ modifiers: [RequestModifier], inputEncoder: InputEncoder) {
        super.init(method: .PUT, path: path, modifiers: modifiers, inputEncoder: inputEncoder)
    }
}

/**
    Represents Endpoint with method DELETE and input and output parameters
    
    :param: IN The input type
    :param: OUT The output type
*/
public final class DELETE<IN, OUT>: BaseEndpoint<IN, OUT>, TargetableEndpoint {
    public convenience init(_ path: String, _ modifiers: [RequestModifier]) {
        self.init(path, modifiers, inputEncoder: URLInputEncoder())
    }
    
    public init(_ path: String, _ modifiers: [RequestModifier], inputEncoder: InputEncoder) {
        super.init(method: .DELETE, path: path, modifiers: modifiers, inputEncoder: inputEncoder)
    }
}

/**
    Represents Endpoint with method OPTIONS and input and output parameters

    :param: IN The input type
    :param: OUT The output type
*/
public final class OPTIONS<IN, OUT>: BaseEndpoint<IN, OUT>, TargetableEndpoint {
    public convenience init(_ path: String, _ modifiers: [RequestModifier]) {
        self.init(path, modifiers, inputEncoder: JSONInputEncoder())
    }
    
    public init(_ path: String, _ modifiers: [RequestModifier], inputEncoder: InputEncoder) {
        super.init(method: .OPTIONS, path: path, modifiers: modifiers, inputEncoder: inputEncoder)
    }
}

/**
    Represents Endpoint with method HEAD and input and output parameters

    :param: IN The input type
    :param: OUT The output type
*/
public final class HEAD<IN, OUT>: BaseEndpoint<IN, OUT>, TargetableEndpoint {
    public convenience init(_ path: String, _ modifiers: [RequestModifier]) {
        self.init(path, modifiers, inputEncoder: URLInputEncoder())
    }
    
    public init(_ path: String, _ modifiers: [RequestModifier], inputEncoder: InputEncoder) {
        super.init(method: .HEAD, path: path, modifiers: modifiers, inputEncoder: inputEncoder)
    }
}

/**
    Represents Endpoint with method PATCH and input and output parameters

    :param: IN The input type
    :param: OUT The output type
*/
public final class PATCH<IN, OUT>: BaseEndpoint<IN, OUT>, TargetableEndpoint {
    public convenience init(_ path: String, _ modifiers: [RequestModifier]) {
        self.init(path, modifiers, inputEncoder: JSONInputEncoder())
    }
    
    public init(_ path: String, _ modifiers: [RequestModifier], inputEncoder: InputEncoder) {
        super.init(method: .PATCH, path: path, modifiers: modifiers, inputEncoder: inputEncoder)
    }
}

/**
    Represents Endpoint with method TRACE and input and output parameters

    :param: IN The input type
    :param: OUT The output type
*/
public final class TRACE<IN, OUT>: BaseEndpoint<IN, OUT>, TargetableEndpoint {
    public convenience init(_ path: String, _ modifiers: [RequestModifier]) {
        self.init(path, modifiers, inputEncoder: URLInputEncoder())
    }
    
    public init(_ path: String, _ modifiers: [RequestModifier], inputEncoder: InputEncoder) {
        super.init(method: .TRACE, path: path, modifiers: modifiers, inputEncoder: inputEncoder)
    }
}

/**
    Represents Endpoint with method CONNECT and input and output parameters

    :param: IN The input type
    :param: OUT The output type
*/
public final class CONNECT<IN, OUT>: BaseEndpoint<IN, OUT>, TargetableEndpoint {
    public convenience init(_ path: String, _ modifiers: [RequestModifier]) {
        self.init(path, modifiers, inputEncoder: URLInputEncoder())
    }
    
    public init(_ path: String, _ modifiers: [RequestModifier], inputEncoder: InputEncoder) {
        super.init(method: .CONNECT, path: path, modifiers: modifiers, inputEncoder: inputEncoder)
    }
}
