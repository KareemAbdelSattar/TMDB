import Foundation
import Factory

struct DefaultMovieDetailsRepository: MovieDetailsRepository {
    @Injected(\.dataTransferService) private var dataTransferService: DataTransferService

    
    func fetchMovieDetails(with id: Int, completion: @escaping MoviesDetailsCompletionHandler) {
        let endPoint = MovieDetailsEndPoint.getMovieDetails(id: id)
        
        dataTransferService.request(with: endPoint) { result in
            switch result {
            case .success(let movieDetails):
                completion(.success(movieDetails.toDomain()))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
