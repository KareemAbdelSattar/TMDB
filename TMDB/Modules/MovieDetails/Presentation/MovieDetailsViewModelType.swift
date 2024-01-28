import Foundation
import Combine

/// MovieDetails Input & Output
///
typealias MovieDetailsViewModelType = MovieDetailsViewModelInput & MovieDetailsViewModelOutput

/// MovieDetails ViewModel Input
///
protocol MovieDetailsViewModelInput {}

/// MovieDetails ViewModel Output
///
protocol MovieDetailsViewModelOutput {
    var movieDetailsPublisher: AnyPublisher<MovieDetailsModel?, Never> { get }
    var isLoadingPublisher: AnyPublisher<Bool, Never> { get }
    func viewDidLoad()
}
