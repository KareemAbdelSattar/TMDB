import Foundation
import Factory
import Combine

// MARK: MovieDetailsViewModel

class MovieDetailsViewModel {
    @Injected(\.movieDetailsUseCase) private var movieDetailsUseCase: FetchMovieDetailsUseCase
    @Injected(\.config) private var config: Configuration
    
    private let movieId: Int
    @Published private var state: State = .loading
    
    enum State {
        case loading
        case loaded(MovieDetailsModel)
        case failure(Error)        
    }
    
    init(movieId: Int) {
        self.movieId = movieId
    }
    
}

// MARK: MovieDetailsViewModel

extension MovieDetailsViewModel: MovieDetailsViewModelInput {
    func changeState(state: State) {
        self.state = state
    }
}

// MARK: MovieDetailsViewModelOutput

extension MovieDetailsViewModel: MovieDetailsViewModelOutput {
    var movieDetailsPublisher: AnyPublisher<MovieDetailsModel?, Never> {
        $state.map {
            guard case .loaded(let movieDetails) = $0 else { return nil }
            return movieDetails
        }.eraseToAnyPublisher()
    }
    
    var isLoadingPublisher: AnyPublisher<Bool, Never> {
        $state.map {
            guard case .loading = $0 else { return false }
            return true
        }.eraseToAnyPublisher()
    }
    
    var errorPublisher: AnyPublisher<NSError, Never> {
        $state
            .compactMap { state -> NSError? in
                if case .failure(let error) = state {
                    return error as NSError
                }
                return nil
            }
            .eraseToAnyPublisher()
    }
    
    func viewDidLoad() {
        performFetchMovieDetails(movieId: movieId)
    }
}

// MARK: Private Handlers

private extension MovieDetailsViewModel {
    func performFetchMovieDetails(movieId: Int) {
        state = .loading
            
        movieDetailsUseCase.execute(with: movieId) { [weak self] result in
            guard let self else { return }
            
            switch result {
            case .success(let movieDetails):
                guard let movieDetailsModel = movieDetailsMapping(movieDetails: movieDetails) else {
                    return
                }
                self.state = .loaded(movieDetailsModel)
            case .failure(let error):
                self.state = .failure(error)
            }
        }
    }
    
    func movieDetailsMapping(movieDetails: MovieDetails?) -> MovieDetailsModel? {
        if let movieDetails {
            let date = DateUtils.parseDate(from: movieDetails.year)
            let year = DateUtils.extractYear(from: date)
            let url = URL(string: "\(self.config.value(.imageURL))500\(movieDetails.poster)")

            let movieDetailsModel = MovieDetailsModel(
                title: movieDetails.title,
                year: year,
                overview: movieDetails.overview,
                poster: url
            )
            
            return movieDetailsModel
        }
        
        return nil
    }
}
