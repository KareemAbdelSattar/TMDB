import UIKit

class MoviesListViewController: UIViewController {

    // MARK: Outlets
    @IBOutlet private weak var tableView: UITableView!
    
    // MARK: Properties

    private let viewModel: MoviesListViewModelType

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
        tableView.estimatedRowHeight = 100
        tableView.registerNib(cellType: MoviesListTableViewCell.self)
    }
}

extension MoviesListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue(cellType: MoviesListTableViewCell.self, for: indexPath)
        return cell
    }
}
