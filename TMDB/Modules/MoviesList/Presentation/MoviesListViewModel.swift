import Foundation
import Factory
import Combine


// MARK: MoviesListViewModel

class MoviesListViewModel {
    @Injected(\.moviesListUseCase) private var moviesListUseCase: FetchMoviesListUseCase
    var movies: CurrentValueSubject<[Movie], Never> = CurrentValueSubject([])
    @Published private var state: State = .loading
    
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
    
}

// MARK: MoviesListViewModel

extension MoviesListViewModel: MoviesListViewModelInput {}

// MARK: MoviesListViewModelOutput

extension MoviesListViewModel: MoviesListViewModelOutput {
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
                self.movies.send(moviesList?.movies ?? [])
            case .failure(let error):
                self.state = .failure(error)
            }
            
            self.state = .loaded
        }
    }
}
