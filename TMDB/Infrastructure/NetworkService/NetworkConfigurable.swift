import Foundation

protocol NetworkConfigurable {
    var baseURL: URL { get }
    var isFullPath: Bool { get }
    var headers: [String: String] { get }
    var queryParameters: [String: String] { get }
}

struct DefaultNetworkConfigurable: NetworkConfigurable {
    let baseURL: URL
    let isFullPath: Bool
    let headers: [String : String]
    let queryParameters: [String : String]
    
    init(
        baseURL: URL,
        isFullPath: Bool,
        headers: [String : String] = [:],
        queryParameters: [String : String] = [:]
    ) {
        self.baseURL = baseURL
        self.isFullPath = isFullPath
        self.headers = headers
        self.queryParameters = queryParameters
    }
}
