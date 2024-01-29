import Foundation
@testable import TMDB

class MockCoordinator: MoviesListCoordinatorDelegate {
    var selectedID: Int?
    
    func didSelectMovie(_ id: Int) {
        selectedID = id
    }
}

