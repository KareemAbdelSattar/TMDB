import Foundation
import Factory
import Combine

protocol MoviesListCoordinatorDelegate: AnyObject {
    func didSelectMovie(_ id: Int)
}

// MARK: MoviesListViewModel

class MoviesListViewModel {
    @Injected(\.moviesListUseCase) private var moviesListUseCase: FetchMoviesListUseCase
    @Injected(\.config) private var config: Configuration
    @Published private var state: State = .loading
    
    private weak var coordinate: MoviesListCoordinatorDelegate?
    var movies: CurrentValueSubject<[MovieViewModel], Never> = CurrentValueSubject([])
    
    static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        return formatter
    }()
    
    enum State {
        case initial, loading, loadingMore, loaded
        case failure(Error)
        var isLoaded: Bool {
            if case .loaded = self {
                return true
            }
            return false
        }
    }
    
    init(coordinate: MoviesListCoordinatorDelegate) {
        self.coordinate = coordinate
    }
}

// MARK: MoviesListViewModel

extension MoviesListViewModel: MoviesListViewModelInput {
    func didSelectRow(at row: Int) {
        let id = movies.value[row].id
        coordinate?.didSelectMovie(id)
    }
}

// MARK: MoviesListViewModelOutput

extension MoviesListViewModel: MoviesListViewModelOutput {
    var isEmptyTableView: AnyPublisher<Bool, Never> {
        movies.combineLatest(isLoadingPublisher)
            .map { $0.isEmpty && !$1 }
            .eraseToAnyPublisher()
        
    }
    
    var isLoadingPublisher: AnyPublisher<Bool, Never> {
        $state.map {
            guard case .loading = $0 else { return false }
            return true
        }.eraseToAnyPublisher()
    }
    
    func viewDidLoad() {
        performFetchMoviesList()
    }
}

// MARK: Private Handlers

private extension MoviesListViewModel {
    func performFetchMoviesList() {
        state = .loading
        moviesListUseCase.execute { [weak self] result in
            guard let self else { return }
            
            switch result {
            case .success(let moviesList):
                self.state = .loaded
                let moviesViewModel = movieViewModelMapping(movies: moviesList?.movies)
                self.movies.send(moviesViewModel)
            case .failure(let error):
                self.state = .failure(error)
            }
        }
    }
    
    func movieViewModelMapping(movies: [Movie]?) -> [MovieViewModel] {
        guard let movies else { return [] }
        return movies.map {
            let url = URL(string: self.config.value(.imageURL) + $0.image)
            let date = self.parseDate(from: $0.releaseDate)
            let year = self.extractYear(from: date)
            return MovieViewModel(id: $0.id, title: $0.title, image: url, releaseDate: year)
        }
    }
    
    func parseDate(from dateString: String) -> Date? {
        MoviesListViewModel.dateFormatter.dateFormat = "yyyy-MM-dd"
        return MoviesListViewModel.dateFormatter.date(from: dateString)
    }
    
    func extractYear(from date: Date?) -> String {
        guard let date else { return "Unknown" }
        MoviesListViewModel.dateFormatter.dateFormat = "yyyy"
        return MoviesListViewModel.dateFormatter.string(from: date)
    }
}
