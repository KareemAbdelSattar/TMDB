import XCTest
import Factory
@testable import TMDB

final class MoviesListRepositoryTests: XCTestCase {
    
    var mockService: MockDataTransferService!
    var sut: DefaultMoviesListRepository!
    
    override func setUp() {
        super.setUp()
        mockService = MockDataTransferService()
        Container.shared.dataTransferService.register { self.mockService }
        sut = DefaultMoviesListRepository()
    }
    
    override func tearDown() {
        super.tearDown()
        mockService = nil
        sut = nil
    }
    
    func testFetchMoviesList_WhenSuccessful_ReturnsExpectedData() {
        // Given
        mockService.resultToReturn = Result<MovieListDTO, DataTransferError>.success(
            MovieListDTO(
                page: 1,
                results: [
                    MovieDTO(id: 12, posterPath: "test", releaseDate: "2022-01-20", title: "welcome")
                ],
                totalPages: 10,
                totalResults: 20
            )
        )
        
        let expectation = expectation(description: "Fetch Movies should success")
        var returnedMovies: MoviesList?
        
        //When
        sut.fetchMoviesList(page: 1) { result in
            if case .success(let success) = result {
                returnedMovies = success
                expectation.fulfill()
            } else {
                XCTFail("Expected success")
            }
        }
        
        waitForExpectations(timeout: 2)

        // Then
        XCTAssertNotNil(returnedMovies)
        XCTAssertEqual(returnedMovies?.page, 1, "Returned movies list should not be nil")
        XCTAssertEqual(returnedMovies?.totalPage, 10, "Returned page should be 10")
        XCTAssertEqual(returnedMovies?.movies.count, 1)
        XCTAssertEqual(returnedMovies?.movies[0].id, 12)
        XCTAssertEqual(returnedMovies?.movies[0].title, "welcome")
        XCTAssertEqual(returnedMovies?.movies[0].releaseDate, "2022-01-20")
        XCTAssertEqual(returnedMovies?.movies[0].image, "test")
    }
    
    func testFetchMoviesList_WhenSuccessful_ReturnsEmptyData() {
        // Given
        mockService.resultToReturn = Result<MovieListDTO, DataTransferError>.success(
            MovieListDTO(
                page: 1,
                results: [],
                totalPages: 1,
                totalResults: 1
            )
        )
        
        let expectation = expectation(description: "Fetch Movies should success by with empty movies")
        var returnedMovies: MoviesList?
        
        //When
        sut.fetchMoviesList(page: 1) { result in
            if case .success(let success) = result {
                returnedMovies = success
                expectation.fulfill()
            } else {
                XCTFail("Expected success")
            }
        }
        
        // Then
        waitForExpectations(timeout: 2)
        
        XCTAssertNotNil(returnedMovies,"Returned movies list should not be nil")
        XCTAssertEqual(returnedMovies?.page, 1, "Returned page should be 1")
        XCTAssertEqual(returnedMovies?.totalPage, 1)
        XCTAssertEqual(returnedMovies?.movies.count, 0)
    }
    
    func testFetchMoviesList_WhenFails_ReturnsError() {
        // Given
        mockService.resultToReturn = Result<MovieListDTO, DataTransferError>.failure(.noResponse)
        
        let expectation = expectation(description: "Fetch Movies should fail")
        var returnedError: Error?
        
        //When
        sut.fetchMoviesList(page: 1) { result in
            if case .failure(let failure) = result {
                returnedError = failure
                expectation.fulfill()
            } else {
                XCTFail("Expected fail")
            }
        }
        
        // Then
        waitForExpectations(timeout: 2)
        XCTAssertNotNil(returnedError, "Returned Error should not be nil")
        XCTAssertEqual(returnedError?.localizedDescription, DataTransferError.noResponse.localizedDescription)
    }
}
