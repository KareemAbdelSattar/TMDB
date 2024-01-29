//
//  MoviesListRepositoryTests.swift
//  TMDBTests
//
//  Created by Kareem Abd El Sattar on 29/01/2024.
//

import XCTest
import Factory
@testable import TMDB

final class MoviesListRepositoryTests: XCTestCase {
    
    func testFetchMoviesListSuccessReturnsExpectedData() {
        // Given
        let mockService = MockDataTransferService()
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
        Container.shared.dataTransferService.register { mockService }
        
        let sut = DefaultMoviesListRepository()
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
        
        // Then
        waitForExpectations(timeout: 2)
        
        XCTAssertNotNil(returnedMovies)
        XCTAssertEqual(returnedMovies?.page, 1, "Returned movies list should not be nil")
        XCTAssertEqual(returnedMovies?.totalPage, 10, "Returned page should be 10")
        XCTAssertEqual(returnedMovies?.movies.count, 1)
        XCTAssertEqual(returnedMovies?.movies[0].id, 12)
        XCTAssertEqual(returnedMovies?.movies[0].title, "welcome")
        XCTAssertEqual(returnedMovies?.movies[0].releaseDate, "2022-01-20")
        XCTAssertEqual(returnedMovies?.movies[0].image, "test")
    }
    
    func testFetchMoviesListSuccessReturnsEmptyData() {
        // Given
        let mockService = MockDataTransferService()
        mockService.resultToReturn = Result<MovieListDTO, DataTransferError>.success(
            MovieListDTO(
                page: 1,
                results: [],
                totalPages: 1,
                totalResults: 1
            )
        )
        Container.shared.dataTransferService.register { mockService }
        
        let sut = DefaultMoviesListRepository()
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
    
    func testFetchMoviesListFailReturns() {
        // Given
        let mockService = MockDataTransferService()
        mockService.resultToReturn = Result<MovieListDTO, DataTransferError>.failure(.noResponse)
        Container.shared.dataTransferService.register { mockService }
        
        let sut = DefaultMoviesListRepository()
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
        XCTAssertEqual(returnedError?.localizedDescription, returnedError?.localizedDescription)
    }
}
