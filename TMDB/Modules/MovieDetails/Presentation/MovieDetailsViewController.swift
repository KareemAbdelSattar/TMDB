import UIKit
import Combine

class MovieDetailsViewController: UIViewController {
    
    // MARK: Outlets
    @IBOutlet private weak var posterImageView: UIImageView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var yearLabel: UILabel!
    @IBOutlet private weak var descriptionLabel: UILabel!
    @IBOutlet private weak var posterImageViewHeight: NSLayoutConstraint!
    
    // MARK: Properties
    
    private let viewModel: MovieDetailsViewModelType
    private var subscription = Set<AnyCancellable>()
    
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
        binding(viewModel: viewModel)
        viewModel.viewDidLoad()
    }
}

// MARK: - Actions

extension MovieDetailsViewController {}

// MARK: - Configurations

extension MovieDetailsViewController {}

// MARK: - Private Handlers

private extension MovieDetailsViewController {
    func binding(viewModel: MovieDetailsViewModelType) {
        viewModel.productDetailsPublisher
            .receive(on: DispatchQueue.main)
            .compactMap { $0 }
            .sink { [weak self] movieDetails in
                guard let self else { return }
                self.configureView(movieDetails: movieDetails)
            }.store(in: &subscription)
    }
    
    func configureView(movieDetails: MovieDetailsModel) {
        posterImageView.kf.indicatorType = .activity
        posterImageView.kf.setImage(with: movieDetails.poster)
        titleLabel.text = movieDetails.title
        yearLabel.text = movieDetails.year
        descriptionLabel.text = movieDetails.overview
    }
}
