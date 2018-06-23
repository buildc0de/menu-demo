import UIKit

/// A view controller responsible for displaying a list of menu groups
final class MenuGroupListVC: UITableViewController, EmptyStatePresenting {

    // MARK: - @IBOutlets
    @IBOutlet weak var emptyView: UIView!
    
    // MARK: - Private
    fileprivate var interactor: Interactor!
    fileprivate var data: [TableViewPresentable] = [] { didSet { updateEmptyView() }}
    
    // MARK: - EmptyStatePresenting
    var hasContent: Bool { return data.count > 0 }
    
}

// MARK: - Lifecycle

extension MenuGroupListVC {
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        configureInteractor()
        configureRefreshControl()
        configureTableView()
        updateEmptyView()
        
        refresh()
        
    }
    
}

// MARK: - Configuration

fileprivate extension MenuGroupListVC {

    func configureInteractor() {
        
        interactor = MenuGroupListInteractor()
        interactor.delegate = self
        
    }
    
    func configureRefreshControl() {
        
        tableView.refreshControl = UIRefreshControl()
        tableView.refreshControl?.addTarget(self, action: #selector(refresh), for: .valueChanged)

    }
    
    func configureTableView() {
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 50
        
    }
    
}

// MARK: - Helpers

fileprivate extension MenuGroupListVC {
    
    @objc func refresh() {
        
        tableView.refreshControl?.beginRefreshing()
        reloadData()
        
    }
    
    func reloadData() {
        interactor.loadData()
    }
    
}

// MARK: - UITableViewDataSource

extension MenuGroupListVC {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let item = data[indexPath.row]
        let cell = item.cell(for: tableView, at: indexPath)
        
        return cell
        
    }
    
}

// MARK: - UITableViewDelegate

extension MenuGroupListVC {
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {}
    
}

// MARK: - InteractorDelegate

extension MenuGroupListVC: InteractorDelegate {
    
    func didLoadData(_ data: [TableViewPresentable]) {
        
        self.data = data
        tableView.refreshControl?.endRefreshing()
        tableView.reloadData()
        
    }
    
}
