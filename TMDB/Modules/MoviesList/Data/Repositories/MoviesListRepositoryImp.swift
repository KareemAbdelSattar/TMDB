import Foundation
import Factory

struct DefaultMoviesListRepository: MoviesListRepository {
    @Injected(\.dataTransferService) private var dataTransferService

    func fetchMoviesList(page: Int, completion: @escaping (Result<MoviesList?, Error>) -> Void) {
        let endPoint = MoviesListsEndPoint.getMoviesList(page: page)
        
        dataTransferService.request(with: endPoint) { result in
            switch result {
            case .success(let moviesListDTO):
                let moviesListEntity = moviesListDTO.toDomain()
                completion(.success(moviesListEntity))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
