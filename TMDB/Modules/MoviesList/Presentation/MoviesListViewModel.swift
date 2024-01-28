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
    var movies: CurrentValueSubject<[MovieModel], Never> = CurrentValueSubject([])

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
    
    func reloadMovieList() {
        movies.send([])
        performFetchMoviesList()
    }
}

// MARK: Private Handlers

private extension MoviesListViewModel {
    func performFetchMoviesList() {
        state = .loading
        moviesListUseCase.execute(page: 1) { [weak self] result in
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
    
    func movieViewModelMapping(movies: [Movie]?) -> [MovieModel] {
        guard let movies else { return [] }
        return movies.map {
            let url = URL(string: self.config.value(.imageURL) + $0.image)
            let date = DateUtils.parseDate(from: $0.releaseDate)
            let year = DateUtils.extractYear(from: date)
            return MovieModel(id: $0.id, title: $0.title, image: url, releaseDate: year)
        }
    }
}
