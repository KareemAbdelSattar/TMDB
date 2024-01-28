import Foundation

protocol MoviesListRepository {
    func fetchMoviesList(page: Int, completion: @escaping MoviesListCompletionHandler)
}
