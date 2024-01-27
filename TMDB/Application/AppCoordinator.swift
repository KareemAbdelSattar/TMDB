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
        let viewModel = MoviesListViewModel()
        let moviesListViewController = MoviesListViewController(viewModel: viewModel)
        return moviesListViewController
    }
}
