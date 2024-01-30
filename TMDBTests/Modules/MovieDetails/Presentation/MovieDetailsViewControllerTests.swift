import XCTest
@testable import TMDB

final class MovieDetailsViewControllerTests: XCTestCase {
    var mockViewModel: MockMovieDetailsViewModel!
    var sut: MovieDetailsViewController!
    
    override func setUp() {
        super.setUp()
        mockViewModel = MockMovieDetailsViewModel()
        sut = MovieDetailsViewController(viewModel: mockViewModel)
        sut.loadViewIfNeeded()
    }
    
    override func tearDown() {
        super.tearDown()
        mockViewModel = nil
        sut = nil
    }
    
    func testViewControllerInitializes() {
        //When
        sut.viewDidLoad()
        
        //Then
        XCTAssertNotNil(sut.posterImageView)
        XCTAssertNotNil(sut.titleLabel)
        XCTAssertNotNil(sut.yearLabel)
        XCTAssertNotNil(sut.descriptionLabel)
    }
}
