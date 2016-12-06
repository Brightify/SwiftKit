//
//  Methods.swift
//  SwiftKit
//
//  Created by Filip Dolnik on 05.12.16.
//  Copyright © 2016 Brightify. All rights reserved.
//

/**
 Represents Endpoint with method CONNECT and input and output parameters
 
 :param: IN The input type
 :param: OUT The output type
 */

open class CONNECT<IN, OUT>: Endpoint<IN, OUT> {
    
    open override static var method: HTTPMethod {
        return .connect
    }
}
/**
 Represents Endpoint with method DELETE and input and output parameters
 
 :param: IN The input type
 :param: OUT The output type
 */
open class DELETE<IN, OUT>: Endpoint<IN, OUT> {
    
    open override static var method: HTTPMethod {
        return .delete
    }
}

/**
 Represents Endpoint with method GET and input and output parameters
 
 :param: IN The input type
 :param: OUT The output type
 */
open class GET<IN, OUT>: Endpoint<IN, OUT> {
    
    open override static var method: HTTPMethod {
        return .get
    }
}

/**
 Represents Endpoint with method HEAD and input and output parameters
 
 :param: IN The input type
 :param: OUT The output type
 */
open class HEAD<IN, OUT>: Endpoint<IN, OUT> {
    
    open override static var method: HTTPMethod {
        return .head
    }
}

/**
 Represents Endpoint with method OPTIONS and input and output parameters
 
 :param: IN The input type
 :param: OUT The output type
 */
open class OPTIONS<IN, OUT>: Endpoint<IN, OUT> {
    
    open override static var method: HTTPMethod {
        return .options
    }
}

/**
 Represents Endpoint with method PATCH and input and output parameters
 
 :param: IN The input type
 :param: OUT The output type
 */
open class PATCH<IN, OUT>: Endpoint<IN, OUT> {
    
    open override static var method: HTTPMethod {
        return .patch
    }
}

/**
 Represents Endpoint with method POST and input and output parameters
 
 :param: IN The input type
 :param: OUT The output type
 */
open class POST<IN, OUT>: Endpoint<IN, OUT> {
    
    open override static var method: HTTPMethod {
        return .post
    }
}

/**
 Represents Endpoint with method PUT and input and output parameters
 
 :param: IN The input type
 :param: OUT The output type
 */
open class PUT<IN, OUT>: Endpoint<IN, OUT> {
    
    open override static var method: HTTPMethod {
        return .put
    }
}

/**
 Represents Endpoint with method TRACE and input and output parameters
 
 :param: IN The input type
 :param: OUT The output type
 */
open class TRACE<IN, OUT>: Endpoint<IN, OUT> {
    
    open override static var method: HTTPMethod {
        return .trace
    }
}
