import UIKit
import SkeletonView
import Combine

class MoviesListViewController: UIViewController {
    
    // MARK: Outlets
    @IBOutlet private weak var tableView: UITableView!
    
    // MARK: Properties
    
    private let viewModel: MoviesListViewModelType
    private var subscription = Set<AnyCancellable>()
    
    // MARK: Init
    
    init(viewModel: MoviesListViewModelType) {
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
        setupUI()
        binding(viewModel: viewModel)
        viewModel.viewDidLoad()
    }
}

// MARK: - Actions

extension MoviesListViewController {}

// MARK: - Configurations

extension MoviesListViewController {}

// MARK: - Private Handlers

private extension MoviesListViewController {
    func setupUI() {
        setupTableView()
    }
    
    func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 150
        tableView.registerNib(cellType: MoviesListTableViewCell.self)
    }
    
    func binding(viewModel: MoviesListViewModelType) {
        viewModel.isLoadingPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isLoading in
                guard let self else { return }
                print(isLoading)
                self.tableView.updateSkeletonLoadingState(isLoading: isLoading)
            }.store(in: &subscription)
        
        viewModel.movies
            .receive(on: DispatchQueue.main)
            .sink { [weak self]  _ in
                guard let self else { return }
                self.tableView.reloadData()
            }.store(in: &subscription)
    }
}

extension MoviesListViewController: UITableViewDelegate, SkeletonTableViewDataSource {
    func collectionSkeletonView(_ skeletonView: UITableView, cellIdentifierForRowAt indexPath: IndexPath) -> ReusableCellIdentifier {
        MoviesListTableViewCell.reusableIdentifier
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.movies.value.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue(cellType: MoviesListTableViewCell.self, for: indexPath)
        return cell
    }
}
