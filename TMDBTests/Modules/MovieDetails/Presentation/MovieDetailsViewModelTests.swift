import XCTest
import Factory
import Combine
@testable import TMDB

final class MovieDetailsViewModelTests: XCTestCase {
    var mockUseCase: MockMovieDetailsUseCase!
    var sut: MovieDetailsViewModelType!
    private var cancellables: Set<AnyCancellable>!

    override func setUp() {
        super.setUp()
        mockUseCase = MockMovieDetailsUseCase()
        Container.shared.movieDetailsUseCase.register { self.mockUseCase }
        sut = MovieDetailsViewModel(movieId: 5)
        cancellables = []
    }
    
    override func tearDown() {
        super.tearDown()
        mockUseCase = nil
        Container.shared.reset()
        sut = nil
        cancellables = nil
    }
    
    func testMovieDetailsPublisher_OnSuccess_ReturnMovieDetailsModel() {
        //Given
        mockUseCase.returnResult = .success(MovieDetails(id: 1, title: "title", year: "2022-01-20", overview: "overview", poster: "poster"))
        var returnMovieDetails: MovieDetailsModel?
        
        //When
        sut.viewDidLoad()
        sut.movieDetailsPublisher.sink { movieDetails in
            returnMovieDetails = movieDetails
        }.store(in: &cancellables)
        
        //Then
        XCTAssertNotNil(returnMovieDetails)
        XCTAssertEqual(returnMovieDetails?.title, "title")
        XCTAssertEqual(returnMovieDetails?.year, "2022")
        XCTAssertEqual(returnMovieDetails?.overview, "overview")
    }
    
    func testMovieDetailsPublisher_OnSuccess_ReturnNil() {
        //Given
        mockUseCase.returnResult = .success(nil)
        var returnMovieDetails: MovieDetailsModel?
        
        //When
        sut.viewDidLoad()
        sut.movieDetailsPublisher.sink { movieDetails in
            returnMovieDetails = movieDetails
        }.store(in: &cancellables)
        
        //Then
        XCTAssertNil(returnMovieDetails)
    }
    
    func testMovieDetailsPublisher_OnFailure_ReturnError() {
        //Given
        let actualError = NSError(domain: "com.test.error", code: 400)
        mockUseCase.returnResult = .failure(actualError)
        var returnError: NSError?
        
        //When
        sut.viewDidLoad()
        sut.errorPublisher.sink { error in
            returnError = error
        }.store(in: &cancellables)
        
        //Then
        XCTAssertNotNil(returnError)
        XCTAssertEqual(returnError?.code, 400)
        XCTAssertEqual(returnError?.domain, "com.test.error")
    }
    
    func testInitMovieDetails_OnSuccess_ReturnTheSameValue() {
        //When
        sut.viewDidLoad()
        
        //Then
        XCTAssertEqual(mockUseCase.movieID, 5)
    }
    
    func testIsLoadingPublisher_OnSuccess_ReturnTrue() {
        //Given
        var returnResult: Bool?
        
        //When
        sut.changeState(state: .loading)
        
        sut.isLoadingPublisher.sink { isLoading in
            returnResult = isLoading
        }.store(in: &cancellables)
        
        //Then
        XCTAssertNotNil(returnResult)
        XCTAssertTrue(returnResult!)
    }
    
    func testIsLoadingPublisher_OnSuccess_ReturnFalse() {
        //Given
        let actualError = NSError(domain: "com.test.error", code: 400)
        var returnResult: Bool?
        
        //When
        sut.changeState(state: .failure(actualError))
        
        sut.isLoadingPublisher.sink { isLoading in
            returnResult = isLoading
        }.store(in: &cancellables)
        
        //Then
        XCTAssertNotNil(returnResult)
        XCTAssertFalse(returnResult!)
    }
}
