import Foundation
import Alamofire
import ObjectMapper
import SwiftyJSON

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
    
    public init() {
        
    }

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
    
    public override init() {
        
    }
    
    public func requestModel(token: T, jsonPath: [SubscriptType]? = nil, callback: (data: ResponseData<T.Model>) -> ()) -> Cancellable {
        return request(token) {
            completion in
            
            var model: T.Model? = nil
            
            if completion.statusCode >= 200 && completion.statusCode <= 299, let data = completion.data {
                let json = JSON(data: data)
                let object: AnyObject
                if let jsonPath = jsonPath {
                    object = json[jsonPath].object
                } else {
                    object = json.object
                }
                model = Mapper<T.Model>().map(object)
            }
            
            let responseData = ResponseData<T.Model>(model: model, statusCode: completion.statusCode, response: completion.response, error: completion.error, rawData: completion.data)
            
            callback(data: responseData)
        }
    }
    
    public func requestModelArray(token: T, arrayJsonPath: [SubscriptType]? = nil, itemJsonPath: [SubscriptType]? = nil, callback: (data: ResponseData<[T.Model]>) -> ()) -> Cancellable {
        return request(token) {
            completion in
            
            var models: [T.Model] = []
            
            if completion.statusCode >= 200 && completion.statusCode <= 299, let data = completion.data {
                let json = JSON(data: data)
                let array: [JSON]
                if let arrayJsonPath = arrayJsonPath {
                    array = json[arrayJsonPath].arrayValue
                } else {
                    array = json.arrayValue
                }
                
                for item in array {
                    let object: AnyObject
                    if let itemJsonPath = itemJsonPath {
                        object = json[itemJsonPath].object
                    } else {
                        object = json.object
                    }
                    if let model = Mapper<T.Model>().map(object) {
                        models.append(model)
                    }
                }
            }
            
            let responseData = ResponseData<[T.Model]>(model: models, statusCode: completion.statusCode, response: completion.response, error: completion.error, rawData: completion.data)
            
            callback(data: responseData)
        }
    }
}