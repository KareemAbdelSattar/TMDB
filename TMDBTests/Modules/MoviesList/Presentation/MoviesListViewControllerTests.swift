import XCTest
import Combine
@testable import TMDB

final class MoviesListViewControllerTests: XCTestCase {
    var sut: MoviesListViewController!
    var mockViewModel: MockMoviesListViewModel!
    
    override func setUp() {
        super.setUp()
        mockViewModel = MockMoviesListViewModel()
        sut = MoviesListViewController(viewModel: mockViewModel)
        sut.loadViewIfNeeded()
    }
    
    override func tearDown() {
        super.tearDown()
        mockViewModel = nil
        sut = nil
    }

    func testViewControllerInitializesTableView() {
        // When
        sut.loadViewIfNeeded()
        
        //Then
        XCTAssertNotNil(sut.tableView, "Table view should be initialized")
    }
    
    func testTableViewCell_ConfiguresWithTitle() {
        //Given
        let indexPath = IndexPath(row: 0, section: 0)
        mockViewModel.mockMovies = [
            MovieModel(id: 1, title: "Movie 1", image: nil, releaseDate: "2022")
        ]
        
        //WHen
        sut.viewDidLoad()
        
        //Then
        let cell = sut.tableView(sut.tableView, cellForRowAt: indexPath) as? MoviesListTableViewCell
        XCTAssertNotNil(cell, "Cell should not be nil")
        XCTAssertEqual(cell?.titleLabel.text, "Movie 1", "Cell should be configured with movie title")
        XCTAssertEqual(cell?.yearLabel.text, "2022", "Cell should be configured with movie year")
    }
    
    func testTableView_OnSelectRow_TracksSelectedRow() {
        // Given
        let indexPath = IndexPath(row: 0, section: 0)
        mockViewModel.mockMovies = [
            MovieModel(id: 1, title: "Movie 1", image: nil, releaseDate: "2022")
        ]
        
        //When
        sut.viewDidLoad()
        sut.tableView(sut.tableView, didSelectRowAt: indexPath)
        
        //Then
        XCTAssertEqual(mockViewModel.selectedRowID, 1)
    }
    
    func testTableView_NumberOfRows_WithMoviesData() {
        //Given
        mockViewModel.mockMovies = [
            MovieModel(id: 1, title: "test", image: nil, releaseDate: "2023-10-02"),
            MovieModel(id: 2, title: "test2", image: nil, releaseDate: "2023-11-02"),
            MovieModel(id: 3, title: "test3", image: nil, releaseDate: "2023-12-02")
        ]
         
        //When
        sut.viewDidLoad()
        
        //Then
        XCTAssertEqual(sut.tableView.numberOfRows(inSection: 0), 3)

    }
    
    func testRefreshControlAction_TriggersReloadState() {
        //WHen
        sut.refreshControlAction()

        
        //Then
        guard case .reload  = mockViewModel.state else {
            XCTFail("Expected .reload state change")
            return
        }
    }
    
    func testScrollViewScrolling_InitiatesLoadingMore() {
        //When
        sut.scrollViewDidScroll(sut.tableView)

        //Then
        guard case .loadingMore  = mockViewModel.state else {
            XCTFail("Expected .loadMore state change")
            return
        }
    }
    
    
    func testTableViewState_WhenEmpty_DisplaysBackgroundView() {
        //When
        sut.viewDidLoad()
        
        let expectation = XCTestExpectation(description: "Wait for UI update")
        DispatchQueue.main.async {
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1.0)

        //Then
        XCTAssertNotNil(sut.tableView.backgroundView, "Table view's background view should not be nil when it is empty")
    }
}
