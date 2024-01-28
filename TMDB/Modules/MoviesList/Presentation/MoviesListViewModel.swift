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
    private var subscription = Set<AnyCancellable>()
    private var currentPage = 0
    var movies: CurrentValueSubject<[MovieModel], Never> = CurrentValueSubject([])
    
    enum State {
        case initial, loading, loadingMore, loaded
        case failure(Error)
        case reload
        var isLoaded: Bool {
            if case .loaded = self {
                return true
            }
            return false
        }
    }
    
    init(coordinate: MoviesListCoordinatorDelegate) {
        self.coordinate = coordinate
        
        binding()
    }
}

// MARK: MoviesListViewModel

extension MoviesListViewModel: MoviesListViewModelInput {
    func changeState(state: State) {
        self.state = state
    }
    
    func didSelectRow(at row: Int) {
        let id = movies.value[row].id
        coordinate?.didSelectMovie(id)
    }
}

// MARK: MoviesListViewModelOutput

extension MoviesListViewModel: MoviesListViewModelOutput {
    var loadMorePublisher: AnyPublisher<Bool, Never> {
        $state.map {
            guard case .loadingMore = $0 else { return false }
            return true
        }.eraseToAnyPublisher()
    }
    
    var reloadMoviesListPublisher: AnyPublisher<Bool, Never> {
        $state.map {
            guard case .reload = $0 else { return false }
            return true
        }.eraseToAnyPublisher()
    }
    
    var isEmptyTableViewPublisher: AnyPublisher<Bool, Never> {
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
    func binding() {
        reloadMoviesListPublisher.sink { [weak self] reloadMovies in
            guard let self else { return }
            if reloadMovies {
                self.performReloadMoviesList()
            }
        }.store(in: &subscription)
        
        loadMorePublisher.sink { [weak self] loadMore in
            guard let self else { return }
            if loadMore {
                self.performFetchMoviesList()
            }
        }.store(in: &subscription)
    }
    
    func performFetchMoviesList() {
        state = .loading
        currentPage += 1
        moviesListUseCase.execute(page: currentPage) { [weak self] result in
            guard let self else { return }
            
            switch result {
            case .success(let moviesList):
                self.state = .loaded
                if let moviesList, self.currentPage <= moviesList.totalPage {
                    let moviesViewModel = movieViewModelMapping(movies: moviesList.movies)
                    let oldMovies = self.movies.value
                    let updatedMovies = oldMovies + moviesViewModel
                    self.movies.send(updatedMovies)
                }
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
    
    func performReloadMoviesList() {
        movies.send([])
        currentPage = 0
        performFetchMoviesList()
    }
}
