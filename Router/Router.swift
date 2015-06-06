import Foundation
import Alamofire
import ObjectMapper
import SwiftyJSON

public class Router {
    
    /// Block to be executed when a request has completed.
    typealias Completion = (data: NSData?, statusCode: Int?, request: NSURLRequest, response: NSURLResponse?, error: NSError?) -> ()
    
    public let baseURL: NSURL
    
    public init(baseURL: NSURL) {
        self.baseURL = baseURL
    }
    
    public func request<ENDPOINT: Endpoint
        where ENDPOINT.Input == Void, ENDPOINT.Output == Void>
        (endpoint: ENDPOINT, callback: EmptyResponse -> ()) -> Cancellable
    {
        let request = prepareRequest(endpoint)
        
        return runRequest(request, completion: Router.relayEmptyResponse(callback))
    }
    
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
        
        return runRequest(request, completion: Router.relaySingleObjectResponse(callback))
    }
    
    public func request<OUT: Mappable, ENDPOINT: Endpoint
        where ENDPOINT.Input == Void, ENDPOINT.Output == [OUT]>
        (endpoint: ENDPOINT, callback: Response<[OUT]> -> ()) -> Cancellable
    {
        let request = prepareRequest(endpoint)
        
        return runRequest(request, completion: Router.relayObjectArrayResponse(callback))
    }
    
    // Input and output requests
    public func request<IN: Mappable, OUT: Mappable, ENDPOINT: Endpoint
        where ENDPOINT.Input == IN, ENDPOINT.Output == OUT>
        (endpoint: ENDPOINT, input: IN, callback: Response<OUT?> -> ()) -> Cancellable
    {
        let request = prepareRequest(endpoint, input: input)
        
        return runRequest(request, completion: Router.relaySingleObjectResponse(callback))
    }

    public func request<IN: Mappable, OUT: Mappable, ENDPOINT: Endpoint
        where ENDPOINT.Input == [IN], ENDPOINT.Output == OUT>
        (endpoint: ENDPOINT, input: [IN], callback: Response<OUT?> -> ()) -> Cancellable
    {
        let request = prepareRequest(endpoint, input: input)
        
        return runRequest(request, completion: Router.relaySingleObjectResponse(callback))
    }
    
    public func request<IN: Mappable, OUT: Mappable, ENDPOINT: Endpoint
        where ENDPOINT.Input == IN, ENDPOINT.Output == [OUT]>
        (endpoint: ENDPOINT, input: IN, callback: Response<[OUT]> -> ()) -> Cancellable
    {
        let request = prepareRequest(endpoint, input: input)
        
        return runRequest(request, completion: Router.relayObjectArrayResponse(callback))
    }

    public func request<IN: Mappable, OUT: Mappable, ENDPOINT: Endpoint
        where ENDPOINT.Input == [IN], ENDPOINT.Output == [OUT]>
        (endpoint: ENDPOINT, input: [IN], callback: Response<[OUT]> -> ()) -> Cancellable
    {
        let request = prepareRequest(endpoint, input: input)
     
        return runRequest(request, completion: Router.relayObjectArrayResponse(callback))
    }
    
    private func request<ENDPOINT: Endpoint
        where ENDPOINT.Input == [String], ENDPOINT.Output == Void>
        (endpoint: ENDPOINT, input: [String], callback: EmptyResponse -> ()) -> Cancellable
    {
        return jsonRequest(endpoint, input: JSON(input)) {
            callback($0.emptyCopy())
        }
    }
    
    private func request<OUT: Mappable, ENDPOINT: Endpoint
        where ENDPOINT.Input == [String], ENDPOINT.Output == OUT>
        (endpoint: ENDPOINT, input: [String], callback: Response<OUT?> -> ()) -> Cancellable
    {
        return jsonRequest(endpoint, input: JSON(input)) {
            Router.relaySingleObjectResponse(callback)(data: $0.rawData, statusCode: $0.statusCode, request: $0.rawRequest, response: $0.rawResponse, error: $0.error)
        }
    }
    
    private func request<OUT: Mappable, ENDPOINT: Endpoint
        where ENDPOINT.Input == [String], ENDPOINT.Output == [OUT]>
        (endpoint: ENDPOINT, input: [String], callback: Response<[OUT]> -> ()) -> Cancellable
    {
        return jsonRequest(endpoint, input: JSON(input)) {
            Router.relayObjectArrayResponse(callback)(data: $0.rawData, statusCode: $0.statusCode, request: $0.rawRequest, response: $0.rawResponse, error: $0.error)
        }
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
    
    private func prepareRequest<E: Endpoint, IN: Mappable where E.Input == IN>(endpoint: E, input: IN) -> NSMutableURLRequest {
        var request = prepareRequest(endpoint)
        
        let json = JSON(Mapper().toJSON(input))
        
        if let data = json.rawData() {
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.HTTPBody = data
        }
        
        return request
    }
    
    private func prepareRequest<E: Endpoint, IN: Mappable where E.Input == [IN]>(endpoint: E, input: [IN]) -> NSMutableURLRequest {
        var request = prepareRequest(endpoint)
        
        let json = JSON(Mapper().toJSONArray(input))
        
        if let data = json.rawData() {
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.HTTPBody = data
        }
        
        return request
    }
    
    private func prepareRequest<E: Endpoint>(endpoint: E) -> NSMutableURLRequest {
        var url = baseURL.URLByAppendingPathComponent(endpoint.path)
        
        var request: NSMutableURLRequest = NSMutableURLRequest(URL: url)
        request.HTTPMethod = endpoint.method.rawValue
        
        return request
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
    
    private class func relaySingleObjectResponse<OBJECT: Mappable>(callback: Response<OBJECT?> -> ()) -> Completion {
        return { completion in
            
            var model: OBJECT? = nil
            
            if completion.statusCode >= 200 && completion.statusCode <= 299, let data = completion.data {
                let json = JSON(data: data)
                model = Mapper<OBJECT>().map(json.object)
            }
            
            let response = Response<OBJECT?>(output: model, statusCode: completion.statusCode, error: completion.error, rawRequest: completion.request, rawResponse: completion.response, rawData: completion.data)
            
            callback(response)
        }
    }
    
    private class func relayObjectArrayResponse<OBJECT: Mappable>(callback: Response<[OBJECT]> -> ()) -> Completion {
        return { completion in
            var models: [OBJECT] = []
            
            if completion.statusCode >= 200 && completion.statusCode <= 299, let data = completion.data {
                let json = JSON(data: data)
                for item in json.arrayValue {
                    if let model = Mapper<OBJECT>().map(item.object) {
                        models.append(model)
                    }
                }
            }
            
            let response = Response<[OBJECT]>(output: models, statusCode: completion.statusCode, error: completion.error, rawRequest: completion.request, rawResponse: completion.response, rawData: completion.data)
            
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