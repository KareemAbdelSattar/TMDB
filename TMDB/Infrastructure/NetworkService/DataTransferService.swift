import Foundation
import Factory

enum DataTransferError: Error {
    case noResponse
    case parsing(Error)
    case networkFailure(NetworkError)
    case resolvedNetworkFailure(Error)
}

protocol DataTransferErrorResolver {
    func resolve(error: NetworkError) -> Error
}

// MARK: - Error Resolver
class DefaultDataTransferErrorResolver: DataTransferErrorResolver {
    init() { }
    func resolve(error: NetworkError) -> Error {
        return error
    }
}

protocol DataTransferService {
    typealias CompletionHandler<T> = (Result<T, DataTransferError>) -> Void

    func request<T: Decodable, E: ResponseRequestAble>(
        with endpoint: E,
        completion: @escaping CompletionHandler<T>
    )  where E.Response == T
}

final class DefaultDataTransferService {
    @Injected(\.networkService) private var networkService: NetworkService
    @Injected(\.dataTransferErrorResolver) private var errorResolver: DataTransferErrorResolver
}

extension DefaultDataTransferService: DataTransferService {
    func request<T: Decodable, E: ResponseRequestAble>(
        with endpoint: E,
        completion: @escaping CompletionHandler<T>
    ) where T : Decodable, T == E.Response, E : ResponseRequestAble {
        networkService.request(endpoint: endpoint) { result in
            switch result {
            case .success(let data):
                let result: Result<T, DataTransferError> = self.decode(
                    data: data,
                    decoder: endpoint.responseDecoder
                )
                completion(result)
            case .failure(let error):
                let error = self.resolve(networkError: error)
                completion(.failure(error))
            }
        }
    }
    
    // MARK: - Private
    private func decode<T: Decodable>(
        data: Data?,
        decoder: ResponseDecoder
    ) -> Result<T, DataTransferError> {
        do {
            guard let data = data else { return .failure(.noResponse) }
            let result: T = try decoder.decode(data)
            return .success(result)
        } catch {
            return .failure(.parsing(error))
        }
    }
    
    private func resolve(networkError error: NetworkError) -> DataTransferError {
        let resolvedError = self.errorResolver.resolve(error: error)
        return resolvedError is NetworkError
        ? .networkFailure(error)
        : .resolvedNetworkFailure(resolvedError)
    }

}
