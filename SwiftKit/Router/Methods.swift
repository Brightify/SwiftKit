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
open class Target<ENDPOINT: TargetableEndpoint, PARAMS> {
    fileprivate let pathAndModifiers: (PARAMS) -> (String, [RequestModifier], InputEncoder?)
    
    /**
        Initializes Target with closure that returns path costructed
        from base URL and PARAMS
        
        :param: path The closure that accepts PARAMS and returns the constructed URL
    */
    public init(inputEncoder: InputEncoder? = nil, _ path: @escaping (PARAMS) -> String) {
        self.pathAndModifiers = { (path($0), [], inputEncoder) }
    }
    
    public init(inputEncoder: InputEncoder? = nil, _ modifiers: [RequestModifier], _ path: @escaping (PARAMS) -> String) {
        self.pathAndModifiers = { (path($0), modifiers, inputEncoder) }
    }
    
    public init(inputEncoder: InputEncoder? = nil, _ pathAndModifiers: @escaping (PARAMS) -> (String, [RequestModifier])) {
        self.pathAndModifiers = {
            let (path, modifiers) = pathAndModifiers($0)
            return (path, modifiers, inputEncoder)
        }
    }
    
    /**
        Returns an Endpoint with the path constructed from supplied PARAMS
    
        :param: params The parameters used to construct the Endpoint URL
    */
    open func endpoint(_ params: PARAMS) -> ENDPOINT {
        let (path, modifiers, inputEncoder) = pathAndModifiers(params)
        if let inputEncoder = inputEncoder {
            return ENDPOINT(path, modifiers, inputEncoder: inputEncoder)
        } else {
            return ENDPOINT(path, modifiers)
        }
    }
}

open class BaseEndpoint<IN, OUT>: Endpoint {
    public typealias Input = IN
    public typealias Output = OUT
    
    open let method: Alamofire.HTTPMethod
    open let path: String
    open let inputEncoder: InputEncoder
    open let modifiers: [RequestModifier]
    
    public init(method: Alamofire.HTTPMethod, path: String, modifiers: [RequestModifier], inputEncoder: InputEncoder) {
        self.method = method
        self.path = path
        self.inputEncoder = inputEncoder
        self.modifiers = modifiers
    }
    
    public convenience init<E: Endpoint>(endpoint: E) where E.Input == IN, E.Output == OUT {
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
        super.init(method: .get, path: path, modifiers: modifiers, inputEncoder: inputEncoder)
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
        super.init(method: .post, path: path, modifiers: modifiers, inputEncoder: inputEncoder)
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
        super.init(method: .put, path: path, modifiers: modifiers, inputEncoder: inputEncoder)
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
        super.init(method: .delete, path: path, modifiers: modifiers, inputEncoder: inputEncoder)
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
        super.init(method: .options, path: path, modifiers: modifiers, inputEncoder: inputEncoder)
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
        super.init(method: .head, path: path, modifiers: modifiers, inputEncoder: inputEncoder)
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
        super.init(method: .patch, path: path, modifiers: modifiers, inputEncoder: inputEncoder)
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
        super.init(method: .trace, path: path, modifiers: modifiers, inputEncoder: inputEncoder)
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
        super.init(method: .connect, path: path, modifiers: modifiers, inputEncoder: inputEncoder)
    }
}
