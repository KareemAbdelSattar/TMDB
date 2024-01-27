import UIKit

class MovieDetailsViewController: UIViewController {

    // MARK: Outlets

    // MARK: Properties

    private let viewModel: MovieDetailsViewModelType

    // MARK: Init

    init(viewModel: MovieDetailsViewModelType) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

// MARK: - Actions

extension MovieDetailsViewController {}

// MARK: - Configurations

extension MovieDetailsViewController {}

// MARK: - Private Handlers

private extension MovieDetailsViewController {}
