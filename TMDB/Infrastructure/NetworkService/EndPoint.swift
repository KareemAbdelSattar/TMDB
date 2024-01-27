import Foundation

protocol RequestAble {
    var path: String { get }
    var method: HTTPMethod { get }
    var headersParameters: [String: String] { get }
    var queryParametersEncodable: Encodable? { get }
    var queryParameters: [String: Any] { get }
    var bodyParametersEncodable: Encodable? { get }
    var bodyParameters: [String: Any] { get }
    var bodyEncoder: BodyEncoder { get }
    
    func request(_ networkConfig: NetworkConfigurable) throws -> URLRequest
}

protocol ResponseRequestAble: RequestAble  {
    associatedtype Response
    
    var responseDecoder: ResponseDecoder { get }
}

protocol BodyEncoder {
    func encode(_ parameters: [String: Any]) -> Data?
}

struct JSONBodyEncoder: BodyEncoder {
    func encode(_ parameters: [String : Any]) -> Data? {
        try? JSONSerialization.data(withJSONObject: parameters)
    }
}

protocol ResponseDecoder {
    func decode<T: Decodable>(_ data: Data) throws -> T
}

struct JSONResponseDecoder: ResponseDecoder {
    func decode<T>(_ data: Data) throws -> T where T : Decodable {
       try JSONDecoder().decode(T.self, from: data)
    }
}

enum RequestGenerationError: Error {
    case components
}

extension RequestAble {
    
    func url(_ config: NetworkConfigurable) throws -> URL {
        let baseURL = config.baseURL.absoluteString.last != "/"
        ? config.baseURL.absoluteString + "/"
        : config.baseURL.absoluteString
        
        
        let endPoint = config.isFullPath ? path : baseURL.appending(path)
        
        guard var urlComponents = URLComponents(string: endPoint) else {
            throw RequestGenerationError.components
        }
        
        var urlQueryItems: [URLQueryItem] = []
        
        let queryParameters = try queryParametersEncodable?.toDictionary() ?? self.queryParameters
        queryParameters.forEach {
            urlQueryItems.append(URLQueryItem(name: $0.key, value: "\($0.value)"))
        }
        
        config.queryParameters.forEach {
            urlQueryItems.append(URLQueryItem(name: $0.key, value: "\($0.value)"))
        }
        
        urlComponents.queryItems = !urlQueryItems.isEmpty ? urlQueryItems : nil
        guard let url = urlComponents.url else {
            throw RequestGenerationError.components
        }
        
        return url
    }
    
    func request(_ networkConfig: NetworkConfigurable) throws -> URLRequest {
        let url = try url(networkConfig)
        var urlRequest = URLRequest(url: url)
        var allHeaders = networkConfig.headers
        
        headersParameters.forEach {
            allHeaders.updateValue($1, forKey: $0)
        }
        
        let bodyParameter = try bodyParametersEncodable?.toDictionary() ?? self.bodyParameters
        if !bodyParameter.isEmpty {
            urlRequest.httpBody = bodyEncoder.encode(bodyParameter)
        }
        
        urlRequest.httpMethod = method.rawValue
        urlRequest.allHTTPHeaderFields = allHeaders
        
        return urlRequest
    }
}

private extension Encodable {
    func toDictionary() throws -> [String: Any]? {
        let data = try JSONEncoder().encode(self)
        let jsonData = try JSONSerialization.jsonObject(with: data)
        
        return jsonData as? [String: Any]
    }
}

class EndPoint<R>: ResponseRequestAble {
    typealias Response = R
    
    var path: String
    var method: HTTPMethod
    var headersParameters: [String : String]
    var queryParametersEncodable: Encodable?
    var queryParameters: [String : Any]
    var bodyParametersEncodable: Encodable?
    var bodyParameters: [String : Any]
    var bodyEncoder: BodyEncoder
    var responseDecoder: ResponseDecoder

    init(
        path: String,
        method: HTTPMethod,
        headersParameters: [String : String] = [:],
        queryParametersEncodable: Encodable? = nil,
        queryParameters: [String : Any] = [:],
        bodyParametersEncodable: Encodable? = nil,
        bodyParameters: [String : Any] = [:],
        bodyEncoder: BodyEncoder = JSONBodyEncoder(),
        responseDecoder: ResponseDecoder = JSONResponseDecoder()
    ) {
        self.path = path
        self.method = method
        self.headersParameters = headersParameters
        self.queryParametersEncodable = queryParametersEncodable
        self.queryParameters = queryParameters
        self.bodyParametersEncodable = bodyParametersEncodable
        self.bodyParameters = bodyParameters
        self.bodyEncoder = bodyEncoder
        self.responseDecoder = responseDecoder
    }
}
