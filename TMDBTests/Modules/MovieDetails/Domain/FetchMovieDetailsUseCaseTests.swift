import XCTest
@testable import TMDB

final class FetchMovieDetailsUseCaseTests: XCTestCase {
    var mockRepository: MockMovieDetailRepository!
    var sut: DefaultFetchMovieDetailsUseCase!
    
    override func setUp() {
        super.setUp()
        mockRepository = MockMovieDetailRepository()
        sut = DefaultFetchMovieDetailsUseCase(movieDetailsRepository: mockRepository)
    }
    
    override func tearDown() {
        super.tearDown()
        mockRepository = nil
        sut = nil
    }
    
    func testFetchMovieDetails_OnSuccess_ReturnsMovieDetails() {
        //Given
        mockRepository.returnedResult = .success(
            MovieDetails(
                id: 1,
                title: "title1",
                year: "2022-12-10",
                overview: "test1",
                poster: "poster1"
            )
        )
        let expectation = expectation(description: "Fetch movie details success")
        var returnedMovieDetails: MovieDetails?
        
        //When
        sut.execute(with: 1) { result in
            if case .success(let movieDetails) = result {
                returnedMovieDetails = movieDetails
                expectation.fulfill()
            }
        }
        
        waitForExpectations(timeout: 5)
        
        //Then
        XCTAssertNotNil(returnedMovieDetails)
        XCTAssertEqual(returnedMovieDetails?.id, 1)
        XCTAssertEqual(returnedMovieDetails?.title, "title1")
        XCTAssertEqual(returnedMovieDetails?.year, "2022-12-10")
        XCTAssertEqual(returnedMovieDetails?.overview, "test1")
        XCTAssertEqual(returnedMovieDetails?.poster, "poster1")
    }
    
    func testFetchMovieDetails_OnSuccess_ReturnNilError() {
        //Given
        mockRepository.returnedResult = .success(nil)
        let expectation = expectation(description: "Fetch movie details success with nil data")
        var returnedMovieDetails: MovieDetails?
        
        //When
        sut.execute(with: 1) { result in
            if case .success(let movieDetails) = result {
                returnedMovieDetails = movieDetails
                expectation.fulfill()
            }
        }
        
        waitForExpectations(timeout: 5)
        
        //Then
        XCTAssertNil(returnedMovieDetails)
    }

    func testFetchMovieDetails_OnFailure_ReturnError() {
        //Given
        let actualError = NSError(domain: "com.test.error", code: 500)
        mockRepository.returnedResult = .failure(actualError)
        let expectation = expectation(description: "Fetch movie details fail")
        var returnedError: NSError?
        
        //When
        sut.execute(with: 1) { result in
            if case .failure(let error) = result {
                returnedError = error as NSError
                expectation.fulfill()
            }
        }
        
        waitForExpectations(timeout: 5)
        
        //Then
        XCTAssertNotNil(returnedError)
        XCTAssertEqual(returnedError?.code, 500)
        XCTAssertEqual(returnedError?.domain, "com.test.error")
    }
}
