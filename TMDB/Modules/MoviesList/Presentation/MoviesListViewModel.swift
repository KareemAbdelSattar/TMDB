import Foundation
import Factory

// MARK: MoviesListViewModel

class MoviesListViewModel {
    @Injected(\.moviesListUseCase) private var moviesListUseCase: FetchMoviesListUseCase
    
}

// MARK: MoviesListViewModel

extension MoviesListViewModel: MoviesListViewModelInput {}

// MARK: MoviesListViewModelOutput

extension MoviesListViewModel: MoviesListViewModelOutput {
    func viewDidLoad() {
        performFetchMoviesList()
    }
}

// MARK: Private Handlers

private extension MoviesListViewModel {
    func performFetchMoviesList() {
        moviesListUseCase.execute { result in
            switch result {
            case .success(let moviesList):
                print(moviesList)
            case .failure(let error):
                print(error)
            }
        }
    }
}
