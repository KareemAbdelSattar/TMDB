import Foundation
@testable import TMDB

class MockDataTransferService: DataTransferService {
    var resultToReturn: Any?

    func request<T, E>(with endpoint: E, completion: @escaping CompletionHandler<T>) where T : Decodable, T == E.Response, E : ResponseRequestAble {
        if let resultToReturn = resultToReturn as? Result<T, DataTransferError> {
            completion(resultToReturn)
        }
    }
}
