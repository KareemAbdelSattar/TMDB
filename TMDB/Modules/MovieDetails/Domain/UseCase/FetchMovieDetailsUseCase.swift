import Foundation

typealias MoviesDetailsCompletionHandler = (Result<MovieDetails?, Error>) -> Void

protocol FetchMovieDetailsUseCase {
    func execute(with id: Int, completion: @escaping MoviesDetailsCompletionHandler)
}


final class DefaultFetchMovieDetailsUseCase {
    private let movieDetailsRepository: MovieDetailsRepository
    
    init(movieDetailsRepository: MovieDetailsRepository) {
        self.movieDetailsRepository = movieDetailsRepository
    }
}

extension DefaultFetchMovieDetailsUseCase: FetchMovieDetailsUseCase {
    func execute(with id: Int, completion: @escaping MoviesDetailsCompletionHandler) {
        movieDetailsRepository.fetchMovieDetails(with: id, completion: completion)
    }
}
