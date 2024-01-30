import Foundation
import Combine

/// MovieDetails Input & Output
///
typealias MovieDetailsViewModelType = MovieDetailsViewModelInput & MovieDetailsViewModelOutput

/// MovieDetails ViewModel Input
///
protocol MovieDetailsViewModelInput {
    func changeState(state: MovieDetailsViewModel.State)
}

/// MovieDetails ViewModel Output
///
protocol MovieDetailsViewModelOutput {
    var movieDetailsPublisher: AnyPublisher<MovieDetailsModel?, Never> { get }
    var isLoadingPublisher: AnyPublisher<Bool, Never> { get }
    var errorPublisher: AnyPublisher<NSError, Never> { get }
    func viewDidLoad()
}
