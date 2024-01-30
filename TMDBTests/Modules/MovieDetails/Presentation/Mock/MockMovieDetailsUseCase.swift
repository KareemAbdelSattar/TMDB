import Foundation
@testable import TMDB

final class MockMovieDetailsUseCase: FetchMovieDetailsUseCase {
    var returnResult: Result<MovieDetails?, Error>?
    var movieID: Int?
    
    func execute(with id: Int, completion: @escaping TMDB.MoviesDetailsCompletionHandler) {
        movieID = id
        if let returnResult {
            completion(returnResult)
        }
    }
}
