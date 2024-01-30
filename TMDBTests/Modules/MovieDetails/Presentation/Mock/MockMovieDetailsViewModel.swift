//
//  MockMovieDetailsViewModel.swift
//  TMDBTests
//
//  Created by Kareem Abd El Sattar on 30/01/2024.
//

import Foundation
import Combine
@testable import TMDB

class MockMovieDetailsViewModel: MovieDetailsViewModelType {
    var changeStateCalled = false
    var viewDidLoadCalled = false

    var movieDetails: MovieDetailsModel?
    var isLoading = false
    var error: NSError?

    func changeState(state: MovieDetailsViewModel.State) {
        changeStateCalled = true
        switch state {
        case .loading:
            isLoading = true
        case .loaded(let movieDetailsModel):
            isLoading = false
            movieDetails = movieDetailsModel
        case .failure(let error):
            isLoading = false
            self.error = error as NSError
        }
    }

    func viewDidLoad() {
        viewDidLoadCalled = true
    }

    var movieDetailsPublisher: AnyPublisher<MovieDetailsModel?, Never> {
        Just(movieDetails).eraseToAnyPublisher()
    }

    var isLoadingPublisher: AnyPublisher<Bool, Never> {
        Just(isLoading).eraseToAnyPublisher()
    }

    var errorPublisher: AnyPublisher<NSError, Never> {
        Just(error).eraseToAnyPublisher().compactMap { $0 }.eraseToAnyPublisher()
    }
}
