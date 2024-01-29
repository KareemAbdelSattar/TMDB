import Foundation
import Combine

/// MoviesList Input & Output
///
typealias MoviesListViewModelType = MoviesListViewModelInput & MoviesListViewModelOutput

/// MoviesList ViewModel Input
///
protocol MoviesListViewModelInput {
    func didSelectRow(at row: Int)
    func changeState(state: MoviesListViewModel.State)
}

/// MoviesList ViewModel Output
///
protocol MoviesListViewModelOutput {
    var isLoadingPublisher: AnyPublisher<Bool, Never> { get }
    var isEmptyTableViewPublisher: AnyPublisher<Bool, Never> { get }
    var errorPublisher: AnyPublisher<NSError, Never> { get }
    var movies: CurrentValueSubject<[MovieModel], Never> { get }
    func viewDidLoad()
}
