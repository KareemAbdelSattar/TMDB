import Foundation

protocol MovieDetailsRepository {
    func fetchMovieDetails(with id: Int, completion: @escaping MoviesDetailsCompletionHandler)
}
