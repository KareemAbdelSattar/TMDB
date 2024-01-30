import Foundation
import Combine
@testable import TMDB

class MockMoviesListViewModel: MoviesListViewModelType {
    var isLoadingPublisher: AnyPublisher<Bool, Never>
    var errorPublisher: AnyPublisher<NSError, Never>
    var movies: CurrentValueSubject<[MovieModel], Never>
    
    @Published var state: MoviesListViewModel.State
    var mockMovies: [MovieModel]
    var selectedRowID: Int?
    
    var isEmptyTableViewPublisher: AnyPublisher<Bool, Never> {
        movies.combineLatest(isLoadingPublisher)
            .map { $0.isEmpty && !$1 }
            .eraseToAnyPublisher()
        
    }
    
    var loadMorePublisher: AnyPublisher<Bool, Never> {
        $state.map {
            guard case .loadingMore = $0 else { return false }
            return true
        }.eraseToAnyPublisher()
    }
    
    init() {
        state = .initial
        mockMovies = []
        isLoadingPublisher = Just(false).eraseToAnyPublisher()
        errorPublisher = Just(NSError(domain: "", code: 0)).eraseToAnyPublisher()
        movies = CurrentValueSubject<[MovieModel], Never>(mockMovies)
    }

    func didSelectRow(at row: Int) {
        selectedRowID = mockMovies[row].id
    }

    func changeState(state: MoviesListViewModel.State) {
        self.state = state
    }

    func viewDidLoad() {
        setMovies(mockMovies)
    }

    func setMovies(_ movies: [MovieModel]) {
        self.movies.send(movies)
    }
}
