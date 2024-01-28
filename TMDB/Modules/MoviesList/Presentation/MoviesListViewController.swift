import UIKit
import SkeletonView
import Combine

class MoviesListViewController: UIViewController {
    
    // MARK: Outlets
    @IBOutlet private weak var tableView: UITableView!
    
    // MARK: Properties
    
    private let viewModel: MoviesListViewModelType
    private var subscription = Set<AnyCancellable>()
    private lazy var refreshController: UIRefreshControl = {
        let refreshController = UIRefreshControl()
        refreshController.addTarget(self, action: #selector(refreshControlAction), for: .valueChanged)
        return refreshController
    }()
    
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

extension MoviesListViewController {
    @objc
    func refreshControlAction() {
        viewModel.reloadMovieList()
    }
}

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
        tableView.registerNib(cellType: MoviesListTableViewCell.self)
        tableView.refreshControl = refreshController
    }
    
    func binding(viewModel: MoviesListViewModelType) {
        viewModel.isLoadingPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isLoading in
                guard let self else { return }
                self.tableView.updateSkeletonLoadingState(isLoading: isLoading)
                if !isLoading {
                    self.refreshController.endRefreshing()
                }
            }.store(in: &subscription)
        
        viewModel.isEmptyTableView
            .receive(on: DispatchQueue.main)
            .sink { isEmpty in
                self.tableView.updateTableViewState(isEmpty: isEmpty)
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
        let movieViewModel = viewModel.movies.value[indexPath.row]
        cell.configure(movieViewModel: movieViewModel)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.didSelectRow(at: indexPath.row)
    }
}
