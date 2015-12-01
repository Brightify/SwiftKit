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
public class Target<ENDPOINT: Endpoint, PARAMS> {
    private let pathAndModifiers: PARAMS -> (String, [RequestModifier])
    
    /**
        Initializes Target with closure that returns path costructed
        from base URL and PARAMS
        
        :param: path The closure that accepts PARAMS and returns the constructed URL
    */
    public init(_ path: PARAMS -> String) {
        self.pathAndModifiers = { (path($0), []) }
    }
    
    public init(_ modifiers: [RequestModifier], _ path: PARAMS -> String) {
        self.pathAndModifiers = { (path($0), modifiers) }
    }
    
    public init(_ pathAndModifiers: PARAMS -> (String, [RequestModifier])) {
        self.pathAndModifiers = pathAndModifiers
    }
    
    /**
        Returns an Endpoint with the path constructed from supplied PARAMS
    
        :param: params The parameters used to construct the Endpoint URL
    */
    public func endpoint(params: PARAMS) -> ENDPOINT {
        let (path, modifiers) = pathAndModifiers(params)
        return ENDPOINT(path, modifiers)
    }
}

public class BaseEndpoint<IN, OUT>: Endpoint {
    public typealias Input = IN
    public typealias Output = OUT
    
    public let method: Alamofire.Method
    public let path: String
    public let modifiers: [RequestModifier]
    
    public init(path: String, method: Alamofire.Method, modifiers: [RequestModifier]) {
        self.path = path
        self.method = method
        self.modifiers = modifiers
    }
    
    public required init(_ path: String, _ modifiers: [RequestModifier] = []) {
        fatalError("Initializer init(path:String) cannot be used in BaseEndpoint!")
    }
}

/**
    Represents Endpoint with method GET and input and output parameters

    :param: IN The input type
    :param: OUT The output type
*/
public class GET<IN, OUT>: BaseEndpoint<IN, OUT> {
    
    /**
        Initializes an endpoint with path
    
        :param: path The path in the API
    */
    public required init(_ path: String, _ modifiers: RequestModifier...) {
        super.init(path: path, method: .GET, modifiers: modifiers)
    }
}

/**
    Represents Endpoint with method POST and input and output parameters

    :param: IN The input type
    :param: OUT The output type
*/
public class POST<IN, OUT>: BaseEndpoint<IN, OUT> {
    
    /**
        Initializes an endpoint with path
    
        :param: path The path in the API
    */
    public required init(_ path: String, _ modifiers: RequestModifier...) {
        super.init(path: path, method: .POST, modifiers: modifiers)
    }
}

/**
    Represents Endpoint with method PUT and input and output parameters

    :param: IN The input type
    :param: OUT The output type
*/
public class PUT<IN, OUT>: BaseEndpoint<IN, OUT> {
    
    /**
        Initializes an endpoint with path
    
        :param: path The path in the API
    */
    public required init(_ path: String, _ modifiers: RequestModifier...) {
        super.init(path: path, method: .PUT, modifiers: modifiers)
    }
}

/**
    Represents Endpoint with method DELETE and input and output parameters
    
    :param: IN The input type
    :param: OUT The output type
*/
public class DELETE<IN, OUT>: BaseEndpoint<IN, OUT> {
    
    /**
        Initializes an endpoint with path
    
        :param: path The path in the API
    */
    public required init(_ path: String, _ modifiers: RequestModifier...) {
        super.init(path: path, method: .DELETE, modifiers: modifiers)
    }
}

/**
    Represents Endpoint with method OPTIONS and input and output parameters

    :param: IN The input type
    :param: OUT The output type
*/
public class OPTIONS<IN, OUT>: BaseEndpoint<IN, OUT> {
    
    /**
        Initializes an endpoint with path
    
        :param: path The path in the API
    */
    public required init(_ path: String, _ modifiers: RequestModifier...) {
        super.init(path: path, method: .OPTIONS, modifiers: modifiers)
    }
}

/**
    Represents Endpoint with method HEAD and input and output parameters

    :param: IN The input type
    :param: OUT The output type
*/
public class HEAD<IN, OUT>: BaseEndpoint<IN, OUT> {
    
    /**
        Initializes an endpoint with path
        
        :param: path The path in the API
    */
    public required init(_ path: String, _ modifiers: RequestModifier...) {
        super.init(path: path, method: .HEAD, modifiers: modifiers)
    }
}

/**
    Represents Endpoint with method PATCH and input and output parameters

    :param: IN The input type
    :param: OUT The output type
*/
public class PATCH<IN, OUT>: BaseEndpoint<IN, OUT> {
    
    /**
        Initializes an endpoint with path
        
        :param: path The path in the API
    */
    public required init(_ path: String, _ modifiers: RequestModifier...) {
        super.init(path: path, method: .PATCH, modifiers: modifiers)
    }
}

/**
    Represents Endpoint with method TRACE and input and output parameters

    :param: IN The input type
    :param: OUT The output type
*/
public class TRACE<IN, OUT>: BaseEndpoint<IN, OUT> {
    
    /**
        Initializes an endpoint with path
        
        :param: path The path in the API
    */
    public required init(_ path: String, _ modifiers: RequestModifier...) {
        super.init(path: path, method: .TRACE, modifiers: modifiers)
    }
}

/**
    Represents Endpoint with method CONNECT and input and output parameters

    :param: IN The input type
    :param: OUT The output type
*/
public class CONNECT<IN, OUT>: BaseEndpoint<IN, OUT> {
    
    /**
        Initializes an endpoint with path
    
        :param: path The path in the API
    */
    public required init(_ path: String, _ modifiers: RequestModifier...) {
        super.init(path: path, method: .CONNECT, modifiers: modifiers)
    }
}
