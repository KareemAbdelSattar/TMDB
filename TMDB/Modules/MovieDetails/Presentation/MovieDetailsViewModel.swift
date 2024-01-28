import Foundation
import Factory
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
        var isLoaded: Bool {
            if case .loaded = self {
                return true
            }
            return false
        }
        
    }
    
    init(movieId: Int) {
        self.movieId = movieId
    }
    
}

// MARK: MovieDetailsViewModel

extension MovieDetailsViewModel: MovieDetailsViewModelInput {}

// MARK: MovieDetailsViewModelOutput

extension MovieDetailsViewModel: MovieDetailsViewModelOutput {
    func viewDidLoad() {
        performFetchMovieDetails(movieId: movieId)
    }
}

// MARK: Private Handlers

private extension MovieDetailsViewModel {
    func performFetchMovieDetails(movieId: Int) {
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
            let url = URL(string: self.config.value(.imageURL) + movieDetails.poster)
            
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
