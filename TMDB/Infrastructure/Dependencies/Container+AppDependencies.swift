import Foundation
import Factory

extension Container {
    var moviesListRepository: Factory<MoviesListRepository> {
        self { DefaultMoviesListRepository() }
    }
    
    var moviesListUseCase: Factory<FetchMoviesListUseCase> {
        self { DefaultFetchMoviesListUseCase(moviesListRepository: self.moviesListRepository()) }
    }
}
