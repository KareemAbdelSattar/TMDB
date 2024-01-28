import Foundation
import Combine

/// MoviesList Input & Output
///
typealias MoviesListViewModelType = MoviesListViewModelInput & MoviesListViewModelOutput

/// MoviesList ViewModel Input
///
protocol MoviesListViewModelInput {
    func didSelectRow(at row: Int)
}

/// MoviesList ViewModel Output
///
protocol MoviesListViewModelOutput {
    var isLoadingPublisher: AnyPublisher<Bool, Never> { get }
    var isEmptyTableView: AnyPublisher<Bool, Never> { get }
    var movies: CurrentValueSubject<[MovieViewModel], Never> { get }
    func viewDidLoad()
}
