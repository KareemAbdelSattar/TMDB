import Foundation
import Factory

typealias MoviesListCompletionHandler = (Result<MoviesList?, Error>) -> Void


protocol FetchMoviesListUseCase {
    func execute(completion: @escaping MoviesListCompletionHandler)
}


final class DefaultFetchMoviesListUseCase {
    private let moviesListRepository: MoviesListRepository

    init(moviesListRepository: MoviesListRepository) {
        self.moviesListRepository = moviesListRepository
    }
}

extension DefaultFetchMoviesListUseCase: FetchMoviesListUseCase {
    func execute(completion: @escaping MoviesListCompletionHandler) {
        moviesListRepository.fetchMoviesList(completion: completion)
    }
}