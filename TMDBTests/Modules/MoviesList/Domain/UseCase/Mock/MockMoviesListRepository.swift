import Foundation
@testable import TMDB

class MockMoviesListRepository: MoviesListRepository {
    var resultToReturn: Result<MoviesList?, Error>?

    func fetchMoviesList(page: Int, completion: @escaping TMDB.MoviesListCompletionHandler) {
        if let resultToReturn {
            completion(resultToReturn)
        }
    }
}
