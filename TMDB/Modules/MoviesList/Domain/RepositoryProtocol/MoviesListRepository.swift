import Foundation

protocol MoviesListRepository {
    func fetchMoviesList(completion: @escaping MoviesListCompletionHandler)
}
