import XCTest
@testable import TMDB

final class MoviesListUseCaseTests: XCTestCase {

    func testExecuteSuccessReturnsExpectedData() {
        // Given
        let mockRepository = MockMoviesListRepository()
        let sut = DefaultFetchMoviesListUseCase(moviesListRepository: mockRepository)
        mockRepository.resultToReturn = .success(
            MoviesList(
                page: 1,
                totalPage: 2,
                movies: [
                    Movie(id: 1, title: "test1", image: "image", releaseDate: "2023-12-20")
                ]
            )
        )
        let expectation = expectation(description: "Fetch Movies should success")
        var returnedResult: MoviesList?
        
        // When
        sut.execute(page: 1) { result in
            if case .success(let value) = result {
                returnedResult = value
                expectation.fulfill()
            }
        }
        
        // Then
        waitForExpectations(timeout: 1)
        XCTAssertNotNil(returnedResult, "Returned result should not be nil")
        XCTAssertEqual(returnedResult?.page, 1)
        XCTAssertEqual(returnedResult?.totalPage, 2)
        XCTAssertEqual(returnedResult?.movies.count, 1)
        XCTAssertEqual(returnedResult?.movies[0].id, 1)
        XCTAssertEqual(returnedResult?.movies[0].title, "test1")
        XCTAssertEqual(returnedResult?.movies[0].image, "image")
        XCTAssertEqual(returnedResult?.movies[0].releaseDate, "2023-12-20")
    }
    
    func testExecuteSuccessReturnsExpectedEmptyData() {
        // Given
        let mockRepository = MockMoviesListRepository()
        let sut = DefaultFetchMoviesListUseCase(moviesListRepository: mockRepository)
        mockRepository.resultToReturn = .success(
            MoviesList(
                page: 1,
                totalPage: 2,
                movies: []
            )
        )
        let expectation = expectation(description: "Fetch ِEmpty Movies should success")
        var returnedResult: MoviesList?
        
        // When
        sut.execute(page: 1) { result in
            if case .success(let value) = result {
                returnedResult = value
                expectation.fulfill()
            }
        }
        
        // Then
        waitForExpectations(timeout: 1)
        XCTAssertNotNil(returnedResult, "Returned result should not be nil")
        XCTAssertTrue(returnedResult!.movies.isEmpty)
    }
    
    func testExecuteSuccessReturnsExpectedNilData() {
        // Given
        let mockRepository = MockMoviesListRepository()
        let sut = DefaultFetchMoviesListUseCase(moviesListRepository: mockRepository)
        mockRepository.resultToReturn = .success(nil)
        let expectation = expectation(description: "Fetch ِEmpty Movies should success")
        var returnedResult: MoviesList?
        
        // When
        sut.execute(page: 1) { result in
            if case .success(let value) = result {
                returnedResult = value
                expectation.fulfill()
            }
        }
        
        // Then
        waitForExpectations(timeout: 1)
        XCTAssertNil(returnedResult, "Returned result should be nil")
    }
    
    func testExecuteFailReturns() {
        // Given
        let mockRepository = MockMoviesListRepository()
        let sut = DefaultFetchMoviesListUseCase(moviesListRepository: mockRepository)
        mockRepository.resultToReturn = .failure(NSError(domain: "com.test", code: 500))
        let expectation = expectation(description: "Fetch Movies should fail")
        var returnedError: NSError?
        
        // When
        sut.execute(page: 1) { result in
            if case .failure(let error) = result {
                returnedError = error as NSError
                expectation.fulfill()
            }
        }
        
        // Then
        waitForExpectations(timeout: 1)
        XCTAssertNotNil(returnedError)
        XCTAssertEqual(returnedError?.code, 500)
        XCTAssertEqual(returnedError?.domain, "com.test")
    }
}
