import Foundation
@testable import TMDB

class MockMovieDetailRepository: MovieDetailsRepository {
    var returnedResult: Result<MovieDetails?, Error>?
    
    func fetchMovieDetails(with id: Int, completion: @escaping TMDB.MoviesDetailsCompletionHandler) {
        if let returnedResult {
            completion(returnedResult)
        }
    }
}
