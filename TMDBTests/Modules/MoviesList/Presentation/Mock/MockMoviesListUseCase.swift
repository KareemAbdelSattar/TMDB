import Foundation
@testable import TMDB

struct MockMoviesListUseCase: FetchMoviesListUseCase {
    var resultToReturn: Result<MoviesList?, Error>?
    
    func execute(page: Int, completion: @escaping TMDB.MoviesListCompletionHandler) {
        if let result = resultToReturn {
            completion(result)
        }
    }
}
