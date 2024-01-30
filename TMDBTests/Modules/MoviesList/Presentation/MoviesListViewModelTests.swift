import XCTest
import Combine
import Factory
@testable import TMDB

final class MoviesListViewModelTests: XCTestCase {
    private var cancellables: Set<AnyCancellable>!
    
    override func setUp() {
        super.setUp()
        cancellables = []
    }
    
    override func tearDown() {
        cancellables = nil
        super.tearDown()
    }
    
    func testViewModelFetchMoviesSuccess() {
        // Given
        let sut = setupSuccessSut(useCase: setupMockUseCaseWithSuccessData())
        var receivedMovies: [MovieModel] = []
        
        //When
        sut.viewDidLoad()
        sut.movies
            .sink { movies in
                receivedMovies = movies
            }
            .store(in: &cancellables)
        
        
        // Then
        XCTAssertEqual(receivedMovies.count, 2)
        XCTAssertEqual(receivedMovies[0].title, "test")
        XCTAssertEqual(receivedMovies[0].releaseDate, "2020")
        XCTAssertEqual(receivedMovies[1].title, "test2")
        XCTAssertEqual(receivedMovies[1].releaseDate, "2022")
    }
    
    func testViewModelLoadMoreMoviesSuccess() {
        // Given
        let sut = setupSuccessSut(useCase: setupMockUseCaseWithSuccessData())
        var receivedMovies: [MovieModel] = []
        
        //When
        
        sut.viewDidLoad()
        sut.changeState(state: .loadingMore)
        sut.movies
            .sink { movies in
                receivedMovies = movies
            }
            .store(in: &cancellables)
                
        // Then
        XCTAssertEqual(receivedMovies.count, 4)
    }

    func testViewModelReloadMoviesSuccess() {
        // Given
        let sut = setupSuccessSut(useCase: setupMockUseCaseWithSuccessData())
          var receivedMovies: [MovieModel] = []
        
        //When
        
        sut.viewDidLoad()
        sut.changeState(state: .loadingMore)
        sut.changeState(state: .reload)

        sut.movies
            .sink { movies in
                receivedMovies = movies
            }
            .store(in: &cancellables)
                
        // Then
        XCTAssertEqual(receivedMovies.count, 2)
    }
    
    func testIsLoadingPublisher() {
        // Given
        let sut = setupSuccessSut(useCase: setupMockUseCaseWithSuccessData())
        var isLoading = false

        // When
        sut.changeState(state: .loading)
        sut.isLoadingPublisher
            .sink { value in
                isLoading = value
            }
            .store(in: &cancellables)
        
        // Then
        XCTAssertTrue(isLoading, "isLoadingPublisher did not emit true during loading state")
    }
    
    func testIsEmptyTableViewPublisherSuccess() {
        // Given
        let sut = setupSuccessSut(useCase: setupMockUseCaseWithSuccessEmptyData())
        var isEmpty = false

        // When
        sut.viewDidLoad()
        sut.isEmptyTableViewPublisher
            .sink { value in
                isEmpty = value
            }
            .store(in: &cancellables)
    
        // Then
        XCTAssertTrue(isEmpty, "isEmptyTableViewPublisher did not emit true for an empty movies list")
    }
    
    func testViewModelFetchMoviesFail() {
        // Given
        let sut = setupSuccessSut(useCase: setupMockUseCaseWithFail())
        var receivedError: NSError?
        
        //When
        sut.viewDidLoad()
        sut.errorPublisher
            .sink { error in
                receivedError = (error)
            }
            .store(in: &cancellables)
        
        
        // Then
        XCTAssertNotNil(receivedError, "No error received when expected")
        XCTAssertEqual(receivedError!, NSError(domain: "error1", code: 500))
    }
    
    func testViewModelDidSelectRow() {
        // Given
        let mockUseCase = setupMockUseCaseWithSuccessData()
        Container.shared.moviesListUseCase.register { mockUseCase }
        let coordinator = MockCoordinator()
        let sut = MoviesListViewModel(coordinate: coordinator)
        let selectedIndex = 1

        // When
        sut.viewDidLoad()
        sut.didSelectRow(at: selectedIndex)

        // Then
        XCTAssertEqual(coordinator.selectedID, 2)
    }

}

extension MoviesListViewModelTests {
    private func setupMockUseCaseWithSuccessData() -> MockMoviesListUseCase {
        var mockUseCase = MockMoviesListUseCase()
        mockUseCase.resultToReturn = .success(
            MoviesList(
                page: 1,
                totalPage: 10,
                movies: [
                    Movie(id: 1, title: "test", image: "image", releaseDate: "2020-10-23"),
                    Movie(id: 2, title: "test2", image: "image2", releaseDate: "2022-01-20")
                ]
            )
        )
        return mockUseCase
    }
    
    private func setupMockUseCaseWithSuccessEmptyData() -> MockMoviesListUseCase {
        var mockUseCase = MockMoviesListUseCase()
        mockUseCase.resultToReturn = .success(
            MoviesList(
                page: 1,
                totalPage: 10,
                movies: []
            )
        )
        return mockUseCase
    }

    private func setupMockUseCaseWithFail() -> MockMoviesListUseCase {
        var mockUseCase = MockMoviesListUseCase()
        mockUseCase.resultToReturn = .failure(NSError(domain: "error1", code: 500))
        return mockUseCase
    }

    private func setupSuccessSut(useCase: MockMoviesListUseCase) -> MoviesListViewModelType {
        
        Container.shared.moviesListUseCase.register { useCase }

        let sut = MoviesListViewModel(coordinate: MockCoordinator())
        
        return sut
    }
}
