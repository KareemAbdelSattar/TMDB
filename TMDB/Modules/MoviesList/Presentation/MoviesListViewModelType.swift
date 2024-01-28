import Foundation
import Combine

/// MoviesList Input & Output
///
typealias MoviesListViewModelType = MoviesListViewModelInput & MoviesListViewModelOutput

/// MoviesList ViewModel Input
///
protocol MoviesListViewModelInput {}

/// MoviesList ViewModel Output
///
protocol MoviesListViewModelOutput {
    var isLoadingPublisher: AnyPublisher<Bool, Never> { get }
    var isEmptyTableView: AnyPublisher<Bool, Never> { get }
    var movies: CurrentValueSubject<[MovieViewModel], Never> { get }
    func viewDidLoad()
}
