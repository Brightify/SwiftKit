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
    private let path: PARAMS -> String
    
    /**
        Initializes Target with closure that returns path costructed
        from base URL and PARAMS
        
        :param: path The closure that accepts PARAMS and returns the constructed URL
    */
    public init(_ path: PARAMS -> String) {
        self.path = path
    }
    
    /**
        Returns an Endpoint with the path constructed from supplied PARAMS
    
        :param: params The parameters used to construct the Endpoint URL
    */
    public func endpoint(params: PARAMS) -> ENDPOINT {
        return ENDPOINT(path(params))
    }
}

class BaseEndpoint<IN, OUT>: Endpoint {
    typealias Input = IN
    typealias Output = OUT
    
    let method: Alamofire.Method
    let path: String
    
    init(path: String, method: Alamofire.Method) {
        self.path = path
        self.method = method
    }
    
    required init(_ path: String) {
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
    public required init(_ path: String) {
        super.init(path: path, method: .GET)
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
    public required init(_ path: String) {
        super.init(path: path, method: .POST)
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
    public required init(_ path: String) {
        super.init(path: path, method: .PUT)
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
    public required init(_ path: String) {
        super.init(path: path, method: .DELETE)
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
    public required init(_ path: String) {
        super.init(path: path, method: .OPTIONS)
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
    public required init(_ path: String) {
        super.init(path: path, method: .HEAD)
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
    public required init(_ path: String) {
        super.init(path: path, method: .PATCH)
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
    public required init(_ path: String) {
        super.init(path: path, method: .TRACE)
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
    public required init(_ path: String) {
        super.init(path: path, method: .CONNECT)
    }
}
