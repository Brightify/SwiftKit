import Foundation
import Alamofire
import SwiftyJSON

public class Router {
    
    /// Block to be executed when a request has completed.
    typealias Completion = (data: NSData?, statusCode: Int?, request: NSURLRequest, response: NSURLResponse?, error: NSError?) -> ()
    
    public let baseURL: NSURL
    public let objectMapper: ObjectMapper
    
    public init(baseURL: NSURL, objectMapper: ObjectMapper) {
        self.baseURL = baseURL
        self.objectMapper = objectMapper
    }
    
    private func prepareRequest<E: Endpoint>(endpoint: E) -> NSMutableURLRequest {
        let urlString: String
        // FIXME should we fail? Or set a default?
        let basePath = baseURL.absoluteString ?? ""
        
        let basePathLastCharacter = basePath[basePath.endIndex.predecessor()]
        let endpointPathFirstCharacter = endpoint.path[endpoint.path.startIndex]
        
        // We cannot use URLByAppendingPathComponent because it escapes the component which is something we do not want
        if (basePathLastCharacter != "/" && endpointPathFirstCharacter != "/") {
            urlString = basePath + "/" + endpoint.path
        } else if (basePathLastCharacter == "/" && endpointPathFirstCharacter == "/") {
            urlString = basePath + endpoint.path.substringFromIndex(endpoint.path.startIndex.successor())
        } else {
            urlString = basePath + endpoint.path
        }
        
        if let url = NSURL(string: urlString) {
            var request: NSMutableURLRequest = NSMutableURLRequest(URL: url)
            request.HTTPMethod = endpoint.method.rawValue
            return request
        } else {
            fatalError("URL could not be built using base URL: \(baseURL) and endpoint path: \(endpoint.path)")
        }
    }
    
    private func runRequest(request: NSURLRequest, completion: Completion) -> Cancellable {
        let alamofireRequest = Alamofire.Manager.sharedInstance
            .request(request)
            .response { (request: NSURLRequest, response: NSHTTPURLResponse?, data: AnyObject?, error: NSError?) -> () in
                let statusCode = response?.statusCode
                completion(data: data as? NSData, statusCode: statusCode, request: request, response: response, error: error)
        }
        
        return CancellableToken {
            alamofireRequest.cancel()
        }
    }
    
    private class func relayEmptyResponse(callback: EmptyResponse -> ()) -> Completion {
        return { completion in
            let response = EmptyResponse(output: Void(), statusCode: completion.statusCode, error: completion.error, rawRequest: completion.request, rawResponse: completion.response, rawData: completion.data)
            callback(response)
        }
    }

}

// Support for basic types
extension Router {
    // No input or output
    public func request<ENDPOINT: Endpoint
        where ENDPOINT.Input == Void, ENDPOINT.Output == Void>
        (endpoint: ENDPOINT, callback: EmptyResponse -> ()) -> Cancellable
    {
        let request = prepareRequest(endpoint)
        
        return runRequest(request, completion: Router.relayEmptyResponse(callback))
    }
    
    // No output requests
    public func request<ENDPOINT: Endpoint
        where ENDPOINT.Input == [String], ENDPOINT.Output == Void>
        (endpoint: ENDPOINT, input: [String], callback: EmptyResponse -> ()) -> Cancellable
    {
        return jsonRequest(endpoint, input: JSON(input)) {
            callback($0.emptyCopy())
        }
    }
}

// Support for Mappable
extension Router {
    
    // No output requests
    public func request<IN: Mappable, ENDPOINT: Endpoint
        where ENDPOINT.Input == IN, ENDPOINT.Output == Void>
        (endpoint: ENDPOINT, input: IN, callback: EmptyResponse -> ()) -> Cancellable
    {
        let request = prepareRequest(endpoint, input: input)
        
        return runRequest(request, completion: Router.relayEmptyResponse(callback))
    }
    
    public func request<IN: Mappable, ENDPOINT: Endpoint
        where ENDPOINT.Input == [IN], ENDPOINT.Output == Void>
        (endpoint: ENDPOINT, input: [IN], callback: EmptyResponse -> ()) -> Cancellable
    {
        let request = prepareRequest(endpoint, input: input)
        
        return runRequest(request, completion: Router.relayEmptyResponse(callback))
    }

    // No input requests
    public func request<OUT: Mappable, ENDPOINT: Endpoint
        where ENDPOINT.Input == Void, ENDPOINT.Output == OUT>
        (endpoint: ENDPOINT, callback: Response<OUT?> -> ()) -> Cancellable
    {
        let request = prepareRequest(endpoint)
        
        return runRequest(request, completion: relaySingleObjectResponse(callback))
    }
    
    public func request<OUT: Mappable, ENDPOINT: Endpoint
        where ENDPOINT.Input == Void, ENDPOINT.Output == [OUT]>
        (endpoint: ENDPOINT, callback: Response<[OUT]> -> ()) -> Cancellable
    {
        let request = prepareRequest(endpoint)
        
        return runRequest(request, completion: relayObjectArrayResponse(callback))
    }
    
    // Input and output requests
    public func request<IN: Mappable, OUT: Mappable, ENDPOINT: Endpoint
        where ENDPOINT.Input == IN, ENDPOINT.Output == OUT>
        (endpoint: ENDPOINT, input: IN, callback: Response<OUT?> -> ()) -> Cancellable
    {
        let request = prepareRequest(endpoint, input: input)
        
        return runRequest(request, completion: relaySingleObjectResponse(callback))
    }
    
    public func request<IN: Mappable, OUT: Mappable, ENDPOINT: Endpoint
        where ENDPOINT.Input == [IN], ENDPOINT.Output == OUT>
        (endpoint: ENDPOINT, input: [IN], callback: Response<OUT?> -> ()) -> Cancellable
    {
        let request = prepareRequest(endpoint, input: input)
        
        return runRequest(request, completion: relaySingleObjectResponse(callback))
    }
    
    public func request<IN: Mappable, OUT: Mappable, ENDPOINT: Endpoint
        where ENDPOINT.Input == IN, ENDPOINT.Output == [OUT]>
        (endpoint: ENDPOINT, input: IN, callback: Response<[OUT]> -> ()) -> Cancellable
    {
        let request = prepareRequest(endpoint, input: input)
        
        return runRequest(request, completion: relayObjectArrayResponse(callback))
    }
    
    public func request<IN: Mappable, OUT: Mappable, ENDPOINT: Endpoint
        where ENDPOINT.Input == [IN], ENDPOINT.Output == [OUT]>
        (endpoint: ENDPOINT, input: [IN], callback: Response<[OUT]> -> ()) -> Cancellable
    {
        let request = prepareRequest(endpoint, input: input)
        
        return runRequest(request, completion: relayObjectArrayResponse(callback))
    }
    
    
    // [String] input requests
    public func request<OUT: Mappable, ENDPOINT: Endpoint
        where ENDPOINT.Input == [String], ENDPOINT.Output == OUT>
        (endpoint: ENDPOINT, input: [String], callback: Response<OUT?> -> ()) -> Cancellable
    {
        return jsonRequest(endpoint, input: JSON(input)) {
            self.relaySingleObjectResponse(callback)(data: $0.rawData, statusCode: $0.statusCode, request: $0.rawRequest, response: $0.rawResponse, error: $0.error)
        }
    }
    
    public func request<OUT: Mappable, ENDPOINT: Endpoint
        where ENDPOINT.Input == [String], ENDPOINT.Output == [OUT]>
        (endpoint: ENDPOINT, input: [String], callback: Response<[OUT]> -> ()) -> Cancellable
    {
        return jsonRequest(endpoint, input: JSON(input)) {
            self.relayObjectArrayResponse(callback)(data: $0.rawData, statusCode: $0.statusCode, request: $0.rawRequest, response: $0.rawResponse, error: $0.error)
        }
    }
    

    private func prepareRequest<E: Endpoint, IN: Mappable where E.Input == IN>(endpoint: E, input: IN) -> NSMutableURLRequest {
        var request = prepareRequest(endpoint)
        
        let json = objectMapper.toJSON(input)
        
        if let data = json.rawData() {
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.HTTPBody = data
        }
        
        return request
    }
    
    private func prepareRequest<E: Endpoint, IN: Mappable where E.Input == [IN]>(endpoint: E, input: [IN]) -> NSMutableURLRequest {
        var request = prepareRequest(endpoint)
        
        let json = objectMapper.toJSONArray(input)
        
        if let data = json.rawData() {
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.HTTPBody = data
        }
        
        return request
    }
    
    private func relaySingleObjectResponse<OBJECT: Mappable>(callback: Response<OBJECT?> -> ()) -> Completion {
        return { completion in
            
            var model: OBJECT? = nil
            
            if completion.statusCode >= 200 && completion.statusCode <= 299, let data = completion.data {
                let json = JSON(data: data)
                model = self.objectMapper.map(json)
            }
            
            let response = Response<OBJECT?>(output: model, statusCode: completion.statusCode, error: completion.error, rawRequest: completion.request, rawResponse: completion.response, rawData: completion.data)
            
            callback(response)
        }
    }
    
    private func relayObjectArrayResponse<OBJECT: Mappable>(callback: Response<[OBJECT]> -> ()) -> Completion {
        return { completion in
            var models: [OBJECT]
            
            if completion.statusCode >= 200 && completion.statusCode <= 299, let data = completion.data {
                let json = JSON(data: data)
                models = self.objectMapper.mapArray(json) ?? []
            } else {
                models = []
            }
            
            let response = Response<[OBJECT]>(output: models, statusCode: completion.statusCode, error: completion.error, rawRequest: completion.request, rawResponse: completion.response, rawData: completion.data)
            
            callback(response)
        }
    }
}

// Support for Transformable
extension Router {
    
    // No output requests
    public func request<IN: Transformable, ENDPOINT: Endpoint
        where ENDPOINT.Input == IN, ENDPOINT.Output == Void>
        (endpoint: ENDPOINT, input: IN, callback: EmptyResponse -> ()) -> Cancellable
    {
        let request = prepareRequest(endpoint, input: input)
        
        return runRequest(request, completion: Router.relayEmptyResponse(callback))
    }
    
    public func request<IN: Transformable, ENDPOINT: Endpoint
        where ENDPOINT.Input == [IN], ENDPOINT.Output == Void>
        (endpoint: ENDPOINT, input: [IN], callback: EmptyResponse -> ()) -> Cancellable
    {
        let request = prepareRequest(endpoint, input: input)
        
        return runRequest(request, completion: Router.relayEmptyResponse(callback))
    }
    
    
    // No input requests
    public func request<OUT: Transformable, ENDPOINT: Endpoint
        where ENDPOINT.Input == Void, ENDPOINT.Output == OUT>
        (endpoint: ENDPOINT, callback: Response<OUT?> -> ()) -> Cancellable
    {
        let request = prepareRequest(endpoint)
        
        return runRequest(request, completion: Router.relaySingleObjectResponse(callback))
    }
    
    public func request<OUT: Transformable, ENDPOINT: Endpoint
        where ENDPOINT.Input == Void, ENDPOINT.Output == [OUT]>
        (endpoint: ENDPOINT, callback: Response<[OUT]> -> ()) -> Cancellable
    {
        let request = prepareRequest(endpoint)
        
        return runRequest(request, completion: Router.relayObjectArrayResponse(callback))
    }
    
    
    // Input and output requests
    public func request<IN: Transformable, OUT: Transformable, ENDPOINT: Endpoint
        where ENDPOINT.Input == IN, ENDPOINT.Output == OUT>
        (endpoint: ENDPOINT, input: IN, callback: Response<OUT?> -> ()) -> Cancellable
    {
        let request = prepareRequest(endpoint, input: input)
        
        return runRequest(request, completion: Router.relaySingleObjectResponse(callback))
    }
    
    public func request<IN: Transformable, OUT: Transformable, ENDPOINT: Endpoint
        where ENDPOINT.Input == [IN], ENDPOINT.Output == OUT>
        (endpoint: ENDPOINT, input: [IN], callback: Response<OUT?> -> ()) -> Cancellable
    {
        let request = prepareRequest(endpoint, input: input)
        
        return runRequest(request, completion: Router.relaySingleObjectResponse(callback))
    }
    
    public func request<IN: Transformable, OUT: Transformable, ENDPOINT: Endpoint
        where ENDPOINT.Input == IN, ENDPOINT.Output == [OUT]>
        (endpoint: ENDPOINT, input: IN, callback: Response<[OUT]> -> ()) -> Cancellable
    {
        let request = prepareRequest(endpoint, input: input)
        
        return runRequest(request, completion: Router.relayObjectArrayResponse(callback))
    }
    
    public func request<IN: Transformable, OUT: Transformable, ENDPOINT: Endpoint
        where ENDPOINT.Input == [IN], ENDPOINT.Output == [OUT]>
        (endpoint: ENDPOINT, input: [IN], callback: Response<[OUT]> -> ()) -> Cancellable
    {
        let request = prepareRequest(endpoint, input: input)
        
        return runRequest(request, completion: Router.relayObjectArrayResponse(callback))
    }
    
    
    // [String] input requests
    public func request<OUT: Transformable, ENDPOINT: Endpoint
        where ENDPOINT.Input == [String], ENDPOINT.Output == OUT>
        (endpoint: ENDPOINT, input: [String], callback: Response<OUT?> -> ()) -> Cancellable
    {
        return jsonRequest(endpoint, input: JSON(input)) {
            Router.relaySingleObjectResponse(callback)(data: $0.rawData, statusCode: $0.statusCode, request: $0.rawRequest, response: $0.rawResponse, error: $0.error)
        }
    }
    
    public func request<OUT: Transformable, ENDPOINT: Endpoint
        where ENDPOINT.Input == [String], ENDPOINT.Output == [OUT]>
        (endpoint: ENDPOINT, input: [String], callback: Response<[OUT]> -> ()) -> Cancellable
    {
        return jsonRequest(endpoint, input: JSON(input)) {
            Router.relayObjectArrayResponse(callback)(data: $0.rawData, statusCode: $0.statusCode, request: $0.rawRequest, response: $0.rawResponse, error: $0.error)
        }
    }
    
    
    private func prepareRequest<E: Endpoint, IN: Transformable where E.Input == IN>(endpoint: E, input: IN) -> NSMutableURLRequest {
        var request = prepareRequest(endpoint)
        
        let json = JSON(IN.transformToJSON(input) ?? NSNull())
        
        if let data = json.rawData() {
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.HTTPBody = data
        }
        
        return request
    }
    
    private func prepareRequest<E: Endpoint, IN: Transformable where E.Input == [IN]>(endpoint: E, input: [IN]) -> NSMutableURLRequest {
        var request = prepareRequest(endpoint)
        
        let output = input.map {
            return IN.transformToJSON($0) ?? NSNull()
        }
        let json = JSON(output)
        
        if let data = json.rawData() {
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.HTTPBody = data
        }
        
        return request
    }
    
    private class func relaySingleObjectResponse<OBJECT: Transformable>(callback: Response<OBJECT?> -> ()) -> Completion {
        return { completion in
            var model: OBJECT? = nil
            
            if completion.statusCode >= 200 && completion.statusCode <= 299, let data = completion.data {
                let json = JSON(data: data)
                model = OBJECT.transformFromJSON(json.object)
            }
            
            let response = Response<OBJECT?>(output: model, statusCode: completion.statusCode, error: completion.error, rawRequest: completion.request, rawResponse: completion.response,  rawData: completion.data)
            
            callback(response)
        }
    }
    
    private class func relayObjectArrayResponse<OBJECT: Transformable>(callback: Response<[OBJECT]> -> ()) -> Completion {
        return { completion in
            var models: [OBJECT] = []
            
            if completion.statusCode >= 200 && completion.statusCode <= 299, let data = completion.data {
                let json = JSON(data: data)
                for item in json.arrayValue {
                    if let model = OBJECT.transformFromJSON(item.object) {
                        models.append(model)
                    }
                }
            }
            
            let response = Response<[OBJECT]>(output: models, statusCode: completion.statusCode, error: completion.error, rawRequest: completion.request, rawResponse: completion.response, rawData: completion.data)
            
            callback(response)
            
        }
    }
}

// Support for JSON
extension Router {
    public func request<ENDPOINT: Endpoint
        where ENDPOINT.Input == JSON, ENDPOINT.Output == JSON>
        (endpoint: ENDPOINT, input: JSON, callback: Response<JSON?> -> ()) -> Cancellable
    {
        return jsonRequest(endpoint, input: input, callback: callback)
    }
    
    private func jsonRequest<ENDPOINT: Endpoint>
        (endpoint: ENDPOINT, input: JSON, callback: Response<JSON?> -> ()) -> Cancellable
    {
        let request = prepareRequest(endpoint)
        
        return runRequest(request) { completion in
            var json: JSON? = nil
            
            if completion.statusCode >= 200 && completion.statusCode <= 299, let data = completion.data {
                json = JSON(data: data)
            }
            
            let response = Response<JSON?>(output: json, statusCode: completion.statusCode, error: completion.error, rawRequest: completion.request, rawResponse: completion.response, rawData: completion.data)
            
            callback(response)
        }
    }
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