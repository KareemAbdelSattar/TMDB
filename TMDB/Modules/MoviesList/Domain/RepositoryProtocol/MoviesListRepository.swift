import Foundation

protocol MoviesListRepository {
    func fetchMoviesList(completion: MoviesListCompletionHandler)
}
