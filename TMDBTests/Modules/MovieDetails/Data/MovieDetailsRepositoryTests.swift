import XCTest
import Factory
@testable import TMDB

final class MovieDetailsRepositoryTests: XCTestCase {
    var mockService: MockDataTransferService!
    var sut: DefaultMovieDetailsRepository!
    
    override func setUp() {
        super.setUp()
        mockService = MockDataTransferService()
        Container.shared.dataTransferService.register { self.mockService }
        sut = DefaultMovieDetailsRepository()
    }
    
    func testFetchMovieDetails_OnSuccess_ReturnMovieDetails() {
        //Given
        mockService.resultToReturn = Result<MovieDetailsDTO, DataTransferError>.success(
            MovieDetailsDTO(id: 1, originalTitle: "welcome", overview: "overview1", posterPath: "poster", releaseDate: "2022-01-20")
        )
        let expectation = expectation(description: "Fetch Movie Details should success")

        var returnMovieDetails: MovieDetails?
        
        //When
        sut.fetchMovieDetails(with: 1) { result in
            if case .success(let success) = result {
                returnMovieDetails = success
                expectation.fulfill()
            } else {
                XCTFail("Expected success")
            }
        }
        
        waitForExpectations(timeout: 2)
        
        //Then
        XCTAssertNotNil(returnMovieDetails)
        XCTAssertEqual(returnMovieDetails?.id, 1)
        XCTAssertEqual(returnMovieDetails?.title, "welcome")
        XCTAssertEqual(returnMovieDetails?.year, "2022-01-20")
        XCTAssertEqual(returnMovieDetails?.poster, "poster")
        XCTAssertEqual(returnMovieDetails?.overview, "overview1")
    }
    
    func testFetchMovieDetails_OnFailure_ReturnError() {
        //Given
        mockService.resultToReturn = Result<MovieDetailsDTO, DataTransferError>.failure(.noResponse)
        let expectation = expectation(description: "Fetch Movie Details should failure")

        var returnedError: Error?

        //When
        sut.fetchMovieDetails(with: 1) { result in
            if case .failure(let failure) = result {
                returnedError = failure
                expectation.fulfill()
            } else {
                XCTFail("Expected fail")
            }
        }
        
        waitForExpectations(timeout: 2)
        
        //Then
        XCTAssertNotNil(returnedError, "Returned Error should not be nil")
        XCTAssertEqual(returnedError?.localizedDescription, DataTransferError.noResponse.localizedDescription)
    }
}
