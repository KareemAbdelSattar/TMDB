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
    var productDetailsPublisher: AnyPublisher<MovieDetailsModel?, Never> { get }
    func viewDidLoad()
}
