import Foundation
import Factory

enum NetworkError: Error {
    case error(statusCode: Int, data: Data?)
    case urlGeneration  
}

protocol NetworkSessionManager {
    typealias CompletionHandler = (Data?, URLResponse?, Error?) -> Void
    
    func request(_ request: URLRequest,
                 completion: @escaping CompletionHandler)
}

struct DefaultNetworkSessionManager: NetworkSessionManager {
    func request(
        _ request: URLRequest,
        completion: @escaping CompletionHandler
    ) {
        let task = URLSession.shared.dataTask(with: request, completionHandler: completion)
        task.resume()
    }
}

protocol NetworkService {
    typealias CompletionHandler = (Result<Data?, NetworkError>) -> Void
    
    func request(endpoint: RequestAble, completion: @escaping CompletionHandler)
}


final class DefaultNetworkService {
    @Injected(\.sessions) private var sessions: NetworkSessionManager
    private let config: NetworkConfigurable

    init(config: NetworkConfigurable) {
        self.config = config
    }
    
    private func request(
        _ request: URLRequest,
        completion: @escaping CompletionHandler
    ) {
       sessions.request(request) { data, response, requestError in
           if requestError != nil {
                var error: NetworkError
                if let response = response as? HTTPURLResponse {
                    error = .error(statusCode: response.statusCode, data: data)
                    completion(.failure(error))
                }
            } else {
                completion(.success(data))
            }
        }
    }
}

extension DefaultNetworkService: NetworkService {
    func request(endpoint: RequestAble, completion: @escaping CompletionHandler) {
        do {
            let urlRequest = try endpoint.request(config)
            return request(urlRequest, completion: completion)
        } catch {
            completion(.failure(.urlGeneration))
        }
    }
}
