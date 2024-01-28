import UIKit

protocol Coordinator {
    func start()
}

protocol NavigationCoordinator: Coordinator {
    var navigationController: UINavigationController { get }
}

final class AppCoordinator: NavigationCoordinator {
    let navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let moviesListViewController = createMoviesListVC()
        navigationController.setViewControllers([moviesListViewController], animated: true)
    }
}

private extension AppCoordinator {
    func createMoviesListVC() -> UIViewController {
        let viewModel = MoviesListViewModel(coordinate: self)
        let moviesListViewController = MoviesListViewController(viewModel: viewModel)
        return moviesListViewController
    }
}

extension AppCoordinator: MoviesListCoordinatorDelegate {
    func didSelectMovie(_ id: Int) {
        let movieDetailsViewModel = MovieDetailsViewModel(movieId: id)
        let movieDetailsViewController = MovieDetailsViewController(viewModel: movieDetailsViewModel)
        navigationController.pushViewController(movieDetailsViewController, animated: true)
    }
}
