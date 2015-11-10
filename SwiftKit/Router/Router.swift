import Foundation
import Alamofire
import SwiftyJSON

public typealias DefaultRequestPerformer = AlamofireRequestPerformer

/// Router submodule helps to use REST APIs
public class Router {
    
    /// Block to be executed when a request has completed.
    typealias Completion = Response<NSData?> -> ()
    
    public let baseURL: NSURL
    public let objectMapper: ObjectMapper
    public let requestPerformer: RequestPerformer
    public let responseVerifier: ResponseVerifier
    
    public private(set) var requestEnhancers: [RequestEnhancer] = []
    
    /**
        Initialize with URL of the API, an instance of ObjectMapper that will be used for the JSON mapping and a 
        response verifier that is used to verify a response.
    
        :param: baseURL The URL of API
        :param: objectMapper An instance of ObjectMapper used to map object to and from JSON.
        :param: responseVerifier An instance of ResponseVerifier used to verify a response. By default a StatusCodeRangeVerifier is used with a range of 200...299.
    */
    public init(
        baseURL: NSURL,
        objectMapper: ObjectMapper,
        requestPerformer: RequestPerformer = DefaultRequestPerformer(),
        responseVerifier: ResponseVerifier = StatusCodeRangeVerifier(range: 200...299))
    {
        self.baseURL = baseURL
        self.objectMapper = objectMapper
        self.requestPerformer = requestPerformer
        self.responseVerifier = responseVerifier
        
        registerRequestEnhancer(HeaderRequestEnhancer())
    }
    
    public func registerRequestEnhancer(enhancer: RequestEnhancer) {
        requestEnhancers.append(enhancer)
        requestEnhancers.sortInPlace { $0.priority < $1.priority }
    }
    
    public func resolveEndpointUrl<E: Endpoint>(endpoint: E) -> NSURL? {
        // Checking for scheme being non-nil allows endpoints with absolute urls without appending the baseURL.
        if let endpointUrl = NSURL(string: endpoint.path) where endpointUrl.scheme != "" {
            return endpointUrl
        } else if let url = baseURL.URLByAppendingPathComponentWithoutEscape(endpoint.path) {
            return url
        } else {
            return nil
        }
    }
    
    private func prepareRequest<E: Endpoint>(endpoint: E, extraModifiers: [RequestModifier] = []) -> Request {
        var request: Request
        if let url = resolveEndpointUrl(endpoint) {
            request = Request(URL: url)
        } else {
            fatalError("URL could not be resolved using base URL: \(baseURL) and endpoint path: \(endpoint.path)")
        }
        
        request.HTTPMethod = endpoint.method.rawValue
        request.modifiers = endpoint.modifiers.arrayByAdding(extraModifiers)
        request.enhancedBy = requestEnhancers.filter { $0.canEnhance(request) }.map {
            $0.enhanceRequest(&request)
            return $0
        }

        return request
    }
    
    private func prepareRequest<E: Endpoint>(endpoint: E, input: NSData?, contentType: Headers.ContentType, extraModifiers: [RequestModifier] = []) -> Request {
        var request = prepareRequest(endpoint, extraModifiers: extraModifiers.arrayByAdding(contentType))
        
        request.HTTPBody = input
        
        return request
    }
    
    private func runRequest(request: Request, completion: Completion) -> Cancellable {
        return requestPerformer.performRequest(request) { (var response) in
            response = request.enhancedBy.reduce(response) { accumulator, enhancer in
                enhancer.deenhanceResponse(accumulator)
            }
            
            completion(response)
        }
    }
    
    private func relayEmptyResponse(callback: EmptyResponse -> ())(response: Response<NSData?>) {
        callback(response.emptyCopy())
    }

}

/// Extension that adds support basic types - for requests with no input and output and no output
extension Router {
    
    /**
        Performs request with no input data nor output data
    
        :param: endpoint The target Endpoint of the API
        :param: callback A callback that will be executed when the request is completed.
        :returns: Cancellable
    */
    public func request<ENDPOINT: Endpoint
        where ENDPOINT.Input == Void, ENDPOINT.Output == Void>
        (endpoint: ENDPOINT, callback: EmptyResponse -> ()) -> Cancellable
    {
        let request = prepareRequest(endpoint)
        
        return runRequest(request, completion: relayEmptyResponse(callback))
    }
    
    /**
        Performs a request with no input data and a single String output.
    
        :param: endpoint The target Endpoint of the API
        :param: callback A callback that will be executed when the requests is completed.
    */
    public func request<ENDPOINT: Endpoint
        where ENDPOINT.Input == Void, ENDPOINT.Output == String>
        (endpoint: ENDPOINT, callback: Response<String?> -> ()) -> Cancellable
    {
        let request = prepareRequest(endpoint)

        return runRequest(request, completion: relayPlainTextResponse(callback))
    }
    
    public func request<ENDPOINT: Endpoint
        where ENDPOINT.Input == Void, ENDPOINT.Output == [String]>
        (endpoint: ENDPOINT, callback: Response<[String]> -> ()) -> Cancellable
    {
        let request = prepareRequest(endpoint)
        
        return runRequest(request, completion: relayStringArrayResponse(callback))
    }

    /**
        Performs request with no output data
    
        :param: endpoint The target Endpoint of the API
        :param: input The array of strings that will be filled to the Endpoint
        :param: callback The callback that is executed when request succeeds or fails
        :returns: Cancellable
    */
    public func request<ENDPOINT: Endpoint
        where ENDPOINT.Input == [String], ENDPOINT.Output == Void>
        (endpoint: ENDPOINT, input: [String], callback: EmptyResponse -> ()) -> Cancellable
    {
        return jsonRequest(endpoint, input: JSON(input)) {
            callback($0.emptyCopy())
        }
    }
    
    private func relayPlainTextResponse(callback: Response<String?> -> ())(response: Response<NSData?>) {
        let textResponse: Response<String?> = response.map {
            var text: String? = nil
            if self.responseVerifier.verify(response), let data = $0 {
                text = NSString(data: data, encoding: NSUTF8StringEncoding) as? String
            }
            return text
        }
        
        callback(textResponse)
    }
    
    private func relayStringArrayResponse(callback: Response<[String]> -> ())(response: Response<NSData?>) {
        let stringArrayResponse: Response<[String]> = response.map {
            var array: [String] = []
            if self.responseVerifier.verify(response), let data = $0 {
                let json = JSON(data: data)
                for (_, value) in json {
                    if let string = value.string {
                        array.append(string)
                    }
                }
            }
            return array
        }
        
        callback(stringArrayResponse)
    }
}

/// Extension that adds support for Serializable input and Deserializable output parameters
extension Router {
    
    /**
        Performs request with Serializable input and no output
    
        :param: endpoint The target Endpoint of the API
        :param: input The Serializable that will be filled to the Endpoint
        :param: callback The callback that is executed when request succeeds or fails
        :returns: Cancellable
    */
    public func request<IN: Serializable, ENDPOINT: Endpoint
        where ENDPOINT.Input == IN, ENDPOINT.Output == Void>
        (endpoint: ENDPOINT, input: IN, callback: EmptyResponse -> ()) -> Cancellable
    {
        let request = prepareRequest(endpoint, input: input)
        
        return runRequest(request, completion: relayEmptyResponse(callback))
    }
    
    /**
        Performs request with input of array of Serializables and no output
    
        :param: endpoint The target Endpoint of the API
        :param: input The input array of Serializables that will be filled to the Endpoint
        :param: callback The callback that is executed when request succeeds or fails
        :returns: Cancellable
    */
    public func request<IN: Serializable, ENDPOINT: Endpoint
        where ENDPOINT.Input == [IN], ENDPOINT.Output == Void>
        (endpoint: ENDPOINT, input: [IN], callback: EmptyResponse -> ()) -> Cancellable
    {
        let request = prepareRequest(endpoint, input: input)
        
        return runRequest(request, completion: relayEmptyResponse(callback))
    }

    /**
        Performs request with no input and Deserializable output
        
        :param: endpoint The target Endpoint of the API
        :param: callback The callback with Deserializable parameter
        :returns: Cancellable
    */
    public func request<OUT: Deserializable, ENDPOINT: Endpoint
        where ENDPOINT.Input == Void, ENDPOINT.Output == OUT>
        (endpoint: ENDPOINT, callback: Response<OUT?> -> ()) -> Cancellable
    {
        let request = prepareRequest(endpoint)
        
        return runRequest(request, completion: relaySingleObjectResponse(callback))
    }
    
    /**
        Performs request with no input and output of Deserializable array
        
        :param: endpoint The target Endpoint of the API
        :param: callback The callback with Deserializable array parameter
        :returns: Cancellable
    */
    public func request<OUT: Deserializable, ENDPOINT: Endpoint
        where ENDPOINT.Input == Void, ENDPOINT.Output == [OUT]>
        (endpoint: ENDPOINT, callback: Response<[OUT]> -> ()) -> Cancellable
    {
        let request = prepareRequest(endpoint)
        
        return runRequest(request, completion: relayObjectArrayResponse(callback))
    }
    
    /**
        Performs request with Serializable input and Deserializable output
        
        :param: endpoint The target Endpoint of the API
        :param: input The Serializable input
        :param: callback The callback with Deserializable parameter
        :returns: Cancellable
    */
    public func request<IN: Serializable, OUT: Deserializable, ENDPOINT: Endpoint
        where ENDPOINT.Input == IN, ENDPOINT.Output == OUT>
        (endpoint: ENDPOINT, input: ENDPOINT.Input, callback: Response<OUT?> -> ()) -> Cancellable
    {
        let request = prepareRequest(endpoint, input: input)
        
        return runRequest(request, completion: relaySingleObjectResponse(callback))
    }
    
    /**
        Performs request with input of Serializable array and Deserializable output
    
        :param: endpoint The target Endpoint of the API
        :param: input The input of Serializable array
        :param: callback The callback with Deserializable parameter
        :returns: Cancellable
    */
    public func request<IN: Serializable, OUT: Deserializable, ENDPOINT: Endpoint
        where ENDPOINT.Input == [IN], ENDPOINT.Output == OUT>
        (endpoint: ENDPOINT, input: ENDPOINT.Input, callback: Response<OUT?> -> ()) -> Cancellable
    {
        let request = prepareRequest(endpoint, input: input)
        
        return runRequest(request, completion: relaySingleObjectResponse(callback))
    }
    
    /**
        Performs request with Serializable input and output of Deserializable array
    
        :param: endpoint The target Endpoint of the API
        :param: input The Serializable input
        :param: callback The callback with Deserializable array parameter
        :returns: Cancellable
    */
    public func request<IN: Serializable, OUT: Deserializable, ENDPOINT: Endpoint
        where ENDPOINT.Input == IN, ENDPOINT.Output == [OUT]>
        (endpoint: ENDPOINT, input: ENDPOINT.Input, callback: Response<[OUT]> -> ()) -> Cancellable
    {
        let request = prepareRequest(endpoint, input: input)
        
        return runRequest(request, completion: relayObjectArrayResponse(callback))
    }
    
    /**
        Performs request with Serializable array input and Deserializable output
    
        :param: endpoint The target Endpoint of the API
        :param: input The input of Serializable array
        :param: callback The callback with Deserializable arrayparameter
        :returns: Cancellable
    */
    public func request<IN: Serializable, OUT: Deserializable, ENDPOINT: Endpoint
        where ENDPOINT.Input == [IN], ENDPOINT.Output == [OUT]>
        (endpoint: ENDPOINT, input: ENDPOINT.Input, callback: Response<[OUT]> -> ()) -> Cancellable
    {
        let request = prepareRequest(endpoint, input: input)
        
        return runRequest(request, completion: relayObjectArrayResponse(callback))
    }
    
    /**
        Performs request with input of String array and Deserializable output
    
        :param: endpoint The target Endpoint of the API
        :param: input The input of String array
        :param: callback The Response with Deserializable parameter
        :returns: Cancellable
    */
    public func request<OUT: Deserializable, ENDPOINT: Endpoint
        where ENDPOINT.Input == [String], ENDPOINT.Output == OUT>
        (endpoint: ENDPOINT, input: [String], callback: Response<OUT?> -> ()) -> Cancellable
    {
        let request = prepareRequest(endpoint, input: JSON(input))
        
        return runRequest(request, completion: relaySingleObjectResponse(callback))
    }
    
    /**
        Performs request with input of String array and Deserializable array output
    
        :param: endpoint The target Endpoint of the API
        :param: input The input of String array
        :param: callback The Response with Deserializable array parameter
        :returns: Cancellable
    */
    public func request<OUT: Deserializable, ENDPOINT: Endpoint
        where ENDPOINT.Input == [String], ENDPOINT.Output == [OUT]>
        (endpoint: ENDPOINT, input: ENDPOINT.Input, callback: Response<[OUT]> -> ()) -> Cancellable
    {
        let request = prepareRequest(endpoint, input: JSON(input))
        
        return runRequest(request, completion: relayObjectArrayResponse(callback))
    }

    private func prepareRequest<E: Endpoint, IN: Serializable where E.Input == IN>(endpoint: E, input: IN) -> Request {
        let json = objectMapper.toJSON(input)
        
        return prepareRequest(endpoint, input: try? json.rawData(), contentType: .ApplicationJson)
    }
    
    private func prepareRequest<E: Endpoint, IN: Serializable where E.Input == [IN]>(endpoint: E, input: [IN]) -> Request {
        let json = objectMapper.toJSONArray(input)
        
        return prepareRequest(endpoint, input: try? json.rawData(), contentType: .ApplicationJson)
    }
    
    private func relaySingleObjectResponse<OBJECT: Deserializable>(callback: Response<OBJECT?> -> ())(response: Response<NSData?>) {
        let modelResponse: Response<OBJECT?> = response.map {
            var model: OBJECT? = nil
            if self.responseVerifier.verify(response), let data = $0 {
                let json = JSON(data: data)
                model = self.objectMapper.map(json)
            }
            return model
        }
        
        callback(modelResponse)
    }
    
    private func relayObjectArrayResponse<OBJECT: Deserializable>(callback: Response<[OBJECT]> -> ())(response: Response<NSData?>) {
        let modelResponse: Response<[OBJECT]> = response.map {
            var models: [OBJECT]?
            
            if self.responseVerifier.verify(response), let data = $0 {
                let json = JSON(data: data)
                models = self.objectMapper.mapArray(json)
            }
            
            return models ?? []
        }
        
        callback(modelResponse)
    }
}

/// Extension of Router tha adds JSON support
extension Router {
    
    /**
        Performs request with input of JSON and output of JSON
    
        :param: input The input of JSON
        :param: callback The Response with parameter of JSON
        :returns: Cancellable
    */
    public func request<ENDPOINT: Endpoint
        where ENDPOINT.Input == JSON, ENDPOINT.Output == JSON>
        (endpoint: ENDPOINT, input: JSON, callback: Response<JSON?> -> ()) -> Cancellable
    {
        return jsonRequest(endpoint, input: input, callback: callback)
    }
    
    private func jsonRequest<ENDPOINT: Endpoint>
        (endpoint: ENDPOINT, callback: Response<JSON?> -> ()) -> Cancellable
    {
        let request = prepareRequest(endpoint)
        
        return runRequest(request, completion: relayJSONResponse(callback))
    }
    
    private func jsonRequest<ENDPOINT: Endpoint>
        (endpoint: ENDPOINT, input: JSON, callback: Response<JSON?> -> ()) -> Cancellable
    {
        let request = prepareRequest(endpoint, input: input)
        
        return runRequest(request, completion: relayJSONResponse(callback))
    }
    
    private func prepareRequest<E: Endpoint>(endpoint: E, input: JSON) -> Request {
        return prepareRequest(endpoint, input: try? input.rawData(), contentType: .ApplicationJson)
    }
    
    private func relayJSONResponse(callback: Response<JSON?> -> ())(response: Response<NSData?>) {
        let jsonResponse: Response<JSON?> = response.map {
            var json: JSON? = nil
            
            if self.responseVerifier.verify(response), let data = $0 {
                json = JSON(data: data)
            }
            
            return json
        }
        
        callback(jsonResponse)
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