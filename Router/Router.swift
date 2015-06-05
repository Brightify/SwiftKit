import Foundation
import Alamofire
import ObjectMapper

public class ResponseData<T> {
    
    public let model: T?
    public let statusCode: Int?
    public let response: NSURLResponse?
    public let error: NSError?
    public let rawData: NSData?
    
    public init(model: T?, statusCode: Int?, response: NSURLResponse?, error: NSError?, rawData: NSData?) {
        self.model = model
        self.statusCode = statusCode
        self.response = response
        self.error = error
        self.rawData = rawData
    }
    
}

/// Block to be executed when a request has completed.
public typealias RouterCompletion = (data: NSData?, statusCode: Int?, response: NSURLResponse?, error: NSError?) -> ()

/// Protocol to define the base URL and sample data for an enum.
public protocol RouteTarget {
    var baseURL: NSURL { get }
    var endpoint: Route.Endpoint { get }
    var parameters: Route.Parameters { get }
}

public protocol MappableRouteTarget {
    typealias Model: Mappable
}

public protocol RouteHeaders {
    var headers: [String: AnyObject] { get }
}

/// Protocol to define the opaque type returned from a request
public protocol Cancellable {
    func cancel()
}

/// Internal token that can be used to cancel requests
struct CancellableToken: Cancellable {
    let cancelAction: () -> ()
    
    func cancel() {
        cancelAction()
    }
}


public final class Route {
    
    /// Represents an HTTP method.
    public enum Endpoint {
        case GET(String)
        case POST(String)
        case PUT(String)
        case DELETE(String)
        case OPTIONS(String)
        case HEAD(String)
        case PATCH(String)
        case TRACE(String)
        case CONNECT(String)
        
        func method() -> Alamofire.Method {
            switch self {
            case .GET:
                return .GET
            case .POST:
                return .POST
            case .PUT:
                return .PUT
            case .DELETE:
                return .DELETE
            case .HEAD:
                return .HEAD
            case .OPTIONS:
                return .OPTIONS
            case PATCH:
                return .PATCH
            case TRACE:
                return .TRACE
            case .CONNECT:
                return .CONNECT
            }
        }
        
        func path() -> String {
            switch self {
            case .GET(let path):
                return path
            case .POST(let path):
                return path
            case .PUT(let path):
                return path
            case .DELETE(let path):
                return path
            case .HEAD(let path):
                return path
            case .OPTIONS(let path):
                return path
            case PATCH(let path):
                return path
            case TRACE(let path):
                return path
            case .CONNECT(let path):
                return path
            }
        }
    }
    
    public enum Parameters {
        case None
        case JSONString(String)
        case JSONArray([AnyObject])
        case JSON([String:AnyObject])
        case URL([String:AnyObject])
    }
    
}

public class Router<T: RouteTarget> {

    public func request(target: T, completion: RouterCompletion) -> Cancellable {
        var headers: [String: AnyObject] = [:]
        
        var url = target.baseURL.URLByAppendingPathComponent(target.endpoint.path())

        var request: NSMutableURLRequest = NSMutableURLRequest(URL: url)
        request.HTTPMethod = target.endpoint.method().rawValue
        
        request.allHTTPHeaderFields = headers
        
        switch(target.parameters) {
        case .None:
            break
        case .JSONString(let value):
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.HTTPBody = value.dataUsingEncoding(NSUTF8StringEncoding)
        case .JSONArray(let array):
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.HTTPBody = NSJSONSerialization.dataWithJSONObject(array, options: nil, error: nil)
        case .JSON(let parameters):
            request = Alamofire.ParameterEncoding.JSON.encode(request, parameters: parameters).0.mutableCopy() as! NSMutableURLRequest
        case .URL(let parameters):
            request = Alamofire.ParameterEncoding.URL.encode(request, parameters: parameters).0.mutableCopy() as! NSMutableURLRequest
        }
        
        let alamofireRequest = Alamofire.Manager.sharedInstance
            .request(request)
            .response { (request: NSURLRequest, response: NSHTTPURLResponse?, data: AnyObject?, error: NSError?) -> () in
                // Alamofire always sends the data param as an NSData? type, but we'll
                // add a check just in case something changes in the future.
                let statusCode = response?.statusCode
                if let data = data as? NSData {
                    completion(data: data, statusCode: statusCode, response:response, error: error)
                } else {
                    completion(data: nil, statusCode: statusCode, response:response, error: error)
                }
        }
        
        return CancellableToken {
            alamofireRequest.cancel()
        }
    }
}

public class ObjectMappingRouter<T: protocol<RouteTarget, MappableRouteTarget>>: Router<T> {
    public func requestModel(token: T, callback: (data: ResponseData<T.Model>) -> ()) -> Cancellable {
        return request(token) {
            completion in
            
            var model: T.Model? = nil
            
            if completion.statusCode >= 200 && completion.statusCode <= 299, let data = completion.data, jsonString = NSString(data: data, encoding: NSUTF8StringEncoding) {
                model = Mapper<T.Model>().map(jsonString)
            }
            
            let responseData = ResponseData<T.Model>(model: model, statusCode: completion.statusCode, response: completion.response, error: completion.error, rawData: completion.data)
            
            callback(data: responseData)
        }
    }
    
    public func requestModelArray(token: T, callback: (data: ResponseData<[T.Model]>) -> ()) -> Cancellable {
        return request(token) {
            (data: NSData?, statusCode: Int?, response: NSURLResponse?, error: NSError?) in
            
            let models: [T.Model]
            
            if let data = data, jsonString = NSString(data: data, encoding: NSUTF8StringEncoding) {
                models = Mapper<T.Model>().mapArray(String(jsonString))
            } else {
                models = []
            }
            
            let responseData = ResponseData<[T.Model]>(model: models, statusCode: statusCode, response: response, error: error, rawData: data)
            
            callback(data: responseData)
        }
    }
}


/*

/// Request provider class. Requests should be made through this class only.
public class MoyaProvider<T: MoyaTarget> {
    /// Closure that defines the endpoints for the provider.
    public typealias MoyaEndpointsClosure = (T) -> (Endpoint<T>)
    /// Closure that resolves an Endpoint into an NSURLRequest.
    public typealias MoyaEndpointResolution = (endpoint: Endpoint<T>) -> (NSURLRequest)
    public typealias MoyaStubbedBehavior = ((T) -> (Moya.StubbedBehavior))
    
    public let endpointsClosure: MoyaEndpointsClosure
    public let endpointResolver: MoyaEndpointResolution
    public let stubResponses: Bool
    public let stubBehavior: MoyaStubbedBehavior
    public let networkActivityClosure: Moya.NetworkActivityClosure?
    
    /// Initializes a provider.
    public init(endpointsClosure: MoyaEndpointsClosure = MoyaProvider.DefaultEndpointMapping(), endpointResolver: MoyaEndpointResolution = MoyaProvider.DefaultEnpointResolution(), stubResponses: Bool = false, stubBehavior: MoyaStubbedBehavior = MoyaProvider.DefaultStubBehavior, networkActivityClosure: Moya.NetworkActivityClosure? = nil) {
        self.endpointsClosure = endpointsClosure
        self.endpointResolver = endpointResolver
        self.stubResponses = stubResponses
        self.stubBehavior = stubBehavior
        self.networkActivityClosure = networkActivityClosure
    }
    
    /// Returns an Endpoint based on the token, method, and parameters by invoking the endpointsClosure.
    public func endpoint(token: T) -> Endpoint<T> {
        return endpointsClosure(token)
    }
    
    /// Designated request-making method.
    public func request(token: T, completion: MoyaCompletion) -> Cancellable {
        let endpoint = self.endpoint(token)
        let request = endpointResolver(endpoint: endpoint)
        
        networkActivityClosure?(change: .Began)
        
        if stubResponses {
            
            var canceled = false
            let cancellableToken = CancellableToken { canceled = true }
            
            let behavior = stubBehavior(token)
            
            let stub: () -> () = {
                self.networkActivityClosure?(change: .Ended)
                
                if (canceled) {
                    completion(data: nil, statusCode: nil, response: nil, error: NSError(domain: NSURLErrorDomain, code: NSURLErrorCancelled, userInfo: nil))
                    return
                }
                
                switch endpoint.sampleResponse.evaluate() {
                case .Success(let statusCode, let data):
                    completion(data: data(), statusCode: statusCode, response:nil, error: nil)
                case .Error(let statusCode, let error, let data):
                    completion(data: data?(), statusCode: statusCode, response:nil, error: error)
                case .Closure:
                    break  // the `evaluate()` method will never actually return a .Closure
                }
            }
            
            switch behavior {
            case .Immediate:
                stub()
            case .Delayed(let delay):
                let killTimeOffset = Int64(CDouble(delay) * CDouble(NSEC_PER_SEC))
                let killTime = dispatch_time(DISPATCH_TIME_NOW, killTimeOffset)
                dispatch_after(killTime, dispatch_get_main_queue()) {
                    stub()
                }
            }
            
            return cancellableToken
            
        } else {
            // We need to keep a reference to the closure without a reference to ourself.
            let networkActivityCallback = networkActivityClosure
            let request = Alamofire.Manager.sharedInstance.request(request)
                .response { (request: NSURLRequest, response: NSHTTPURLResponse?, data: AnyObject?, error: NSError?) -> () in
                    networkActivityCallback?(change: .Ended)
                    
                    // Alamofire always sends the data param as an NSData? type, but we'll
                    // add a check just in case something changes in the future.
                    let statusCode = response?.statusCode
                    if let data = data as? NSData {
                        completion(data: data, statusCode: statusCode, response:response, error: error)
                    } else {
                        completion(data: nil, statusCode: statusCode, response:response, error: error)
                    }
            }
            
            return CancellableToken {
                request.cancel()
            }
        }
    }
    
    public class func DefaultEndpointMapping() -> MoyaEndpointsClosure {
        return { (target: T) -> Endpoint<T> in
            let url = target.baseURL.URLByAppendingPathComponent(target.path).absoluteString
            return Endpoint(URL: url!, sampleResponse: .Success(200, {target.sampleData}), method: target.method, parameters: target.parameters)
        }
    }
    
    public class func DefaultEnpointResolution() -> MoyaEndpointResolution {
        return { (endpoint: Endpoint<T>) -> (NSURLRequest) in
            return endpoint.urlRequest
        }
    }
    
    public class func DefaultStubBehavior(_: T) -> Moya.StubbedBehavior {
        return .Immediate
    }
}


//
//  Moya.swift
//  Moya
//
//  Created by Ash Furrow on 2014-08-16.
//  Copyright (c) 2014 Ash Furrow. All rights reserved.
//

import Foundation
import Alamofire

/// Block to be executed when a request has completed.
public typealias MoyaCompletion = (data: NSData?, statusCode: Int?, response: NSURLResponse?, error: NSError?) -> ()

/// General-purpose class to store some enums and class funcs.
public class Moya {
    
    /// Network activity change notification type.
    public enum NetworkActivityChangeType {
        case Began, Ended
    }
    
    /// Network activity change notification closure typealias.
    public typealias NetworkActivityClosure = (change: NetworkActivityChangeType) -> ()
    
    public enum Parameters {
        case Dictionary([String: AnyObject])
        case Array([AnyObject])
    }
    
    /// Represents an HTTP method.
    public enum Method {
        case GET, POST, PUT, DELETE, OPTIONS, HEAD, PATCH, TRACE, CONNECT
        
        func method() -> Alamofire.Method {
            switch self {
            case .GET:
                return .GET
            case .POST:
                return .POST
            case .PUT:
                return .PUT
            case .DELETE:
                return .DELETE
            case .HEAD:
                return .HEAD
            case .OPTIONS:
                return .OPTIONS
            case PATCH:
                return .PATCH
            case TRACE:
                return .TRACE
            case .CONNECT:
                return .CONNECT
            }
        }
    }
    
    /// Choice of parameter encoding.
    public enum ParameterEncoding {
        case URL
        case JSON
        case PropertyList(NSPropertyListFormat, NSPropertyListWriteOptions)
        case Custom((URLRequestConvertible, [String: AnyObject]?) -> (NSURLRequest, NSError?))
        
        func parameterEncoding() -> Alamofire.ParameterEncoding {
            switch self {
            case .URL:
                return .URL
            case .JSON:
                return .JSON
            case .PropertyList(let format, let options):
                return .PropertyList(format, options)
            case .Custom(let closure):
                return .Custom(closure)
            }
        }
    }
    
    public enum StubbedBehavior {
        case Immediate
        case Delayed(seconds: NSTimeInterval)
    }
}

/// Protocol defining the relative path of an enum.
public protocol MoyaPath {
    var path: String { get }
}

/// Protocol to define the base URL and sample data for an enum.
public protocol MoyaTarget : MoyaPath {
    var baseURL: NSURL { get }
    var method: Moya.Method { get }
    var parameters: Moya.Parameters { get }
    var sampleData: NSData { get }
}

/// Request provider class. Requests should be made through this class only.
public class MoyaProvider<T: MoyaTarget> {
    /// Closure that defines the endpoints for the provider.
    public typealias MoyaEndpointsClosure = (T) -> (Endpoint<T>)
    /// Closure that resolves an Endpoint into an NSURLRequest.
    public typealias MoyaEndpointResolution = (endpoint: Endpoint<T>) -> (NSURLRequest)
    public typealias MoyaStubbedBehavior = ((T) -> (Moya.StubbedBehavior))
    
    public let endpointsClosure: MoyaEndpointsClosure
    public let endpointResolver: MoyaEndpointResolution
    public let stubResponses: Bool
    public let stubBehavior: MoyaStubbedBehavior
    public let networkActivityClosure: Moya.NetworkActivityClosure?
    
    /// Initializes a provider.
    public init(endpointsClosure: MoyaEndpointsClosure = MoyaProvider.DefaultEndpointMapping(), endpointResolver: MoyaEndpointResolution = MoyaProvider.DefaultEnpointResolution(), stubResponses: Bool = false, stubBehavior: MoyaStubbedBehavior = MoyaProvider.DefaultStubBehavior, networkActivityClosure: Moya.NetworkActivityClosure? = nil) {
        self.endpointsClosure = endpointsClosure
        self.endpointResolver = endpointResolver
        self.stubResponses = stubResponses
        self.stubBehavior = stubBehavior
        self.networkActivityClosure = networkActivityClosure
    }
    
    /// Returns an Endpoint based on the token, method, and parameters by invoking the endpointsClosure.
    public func endpoint(token: T) -> Endpoint<T> {
        return endpointsClosure(token)
    }
    
    /// Designated request-making method.
    public func request(token: T, completion: MoyaCompletion) -> Cancellable {
        let endpoint = self.endpoint(token)
        let request = endpointResolver(endpoint: endpoint)
        
        networkActivityClosure?(change: .Began)
        
        if stubResponses {
            
            var canceled = false
            let cancellableToken = CancellableToken { canceled = true }
            
            let behavior = stubBehavior(token)
            
            let stub: () -> () = {
                self.networkActivityClosure?(change: .Ended)
                
                if (canceled) {
                    completion(data: nil, statusCode: nil, response: nil, error: NSError(domain: NSURLErrorDomain, code: NSURLErrorCancelled, userInfo: nil))
                    return
                }
                
                switch endpoint.sampleResponse.evaluate() {
                case .Success(let statusCode, let data):
                    completion(data: data(), statusCode: statusCode, response:nil, error: nil)
                case .Error(let statusCode, let error, let data):
                    completion(data: data?(), statusCode: statusCode, response:nil, error: error)
                case .Closure:
                    break  // the `evaluate()` method will never actually return a .Closure
                }
            }
            
            switch behavior {
            case .Immediate:
                stub()
            case .Delayed(let delay):
                let killTimeOffset = Int64(CDouble(delay) * CDouble(NSEC_PER_SEC))
                let killTime = dispatch_time(DISPATCH_TIME_NOW, killTimeOffset)
                dispatch_after(killTime, dispatch_get_main_queue()) {
                    stub()
                }
            }
            
            return cancellableToken
            
        } else {
            // We need to keep a reference to the closure without a reference to ourself.
            let networkActivityCallback = networkActivityClosure
            let request = Alamofire.Manager.sharedInstance.request(request)
                .response { (request: NSURLRequest, response: NSHTTPURLResponse?, data: AnyObject?, error: NSError?) -> () in
                    networkActivityCallback?(change: .Ended)
                    
                    // Alamofire always sends the data param as an NSData? type, but we'll
                    // add a check just in case something changes in the future.
                    let statusCode = response?.statusCode
                    if let data = data as? NSData {
                        completion(data: data, statusCode: statusCode, response:response, error: error)
                    } else {
                        completion(data: nil, statusCode: statusCode, response:response, error: error)
                    }
            }
            
            return CancellableToken {
                request.cancel()
            }
        }
    }
    
    public class func DefaultEndpointMapping() -> MoyaEndpointsClosure {
        return { (target: T) -> Endpoint<T> in
            let url = target.baseURL.URLByAppendingPathComponent(target.path).absoluteString
            return Endpoint(URL: url!, sampleResponse: .Success(200, {target.sampleData}), method: target.method, parameters: target.parameters)
        }
    }
    
    public class func DefaultEnpointResolution() -> MoyaEndpointResolution {
        return { (endpoint: Endpoint<T>) -> (NSURLRequest) in
            return endpoint.urlRequest
        }
    }
    
    public class func DefaultStubBehavior(_: T) -> Moya.StubbedBehavior {
        return .Immediate
    }
}
/*
*/*/