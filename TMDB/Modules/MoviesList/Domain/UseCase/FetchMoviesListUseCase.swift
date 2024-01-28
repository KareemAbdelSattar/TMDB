import Foundation
import Factory

typealias MoviesListCompletionHandler = (Result<MoviesList?, Error>) -> Void


protocol FetchMoviesListUseCase {
    func execute(page: Int, completion: @escaping MoviesListCompletionHandler)
}


final class DefaultFetchMoviesListUseCase {
    private let moviesListRepository: MoviesListRepository

    init(moviesListRepository: MoviesListRepository) {
        self.moviesListRepository = moviesListRepository
    }
}

extension DefaultFetchMoviesListUseCase: FetchMoviesListUseCase {
    func execute(page: Int, completion: @escaping MoviesListCompletionHandler) {
        moviesListRepository.fetchMoviesList(page: page, completion: completion)
    }
}
