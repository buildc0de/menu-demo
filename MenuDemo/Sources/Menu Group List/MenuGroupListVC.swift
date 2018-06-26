import UIKit

/// A view controller responsible for displaying a list of menu groups
final class MenuGroupListVC: UITableViewController, EmptyStatePresenting {

    enum SegueIdentifier: String {
        case addMenuGroup
    }

    // MARK: - @IBOutlets
    @IBOutlet weak var emptyView: UIView!
    
    // MARK: - Private
    fileprivate var interactor: MenuGroupListInteractor!
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
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            interactor.deleteItem(at: indexPath)
        }
        
    }
    
}

// MARK: - InteractorDelegate

extension MenuGroupListVC: InteractorDelegate {
    
    func didLoadData(_ data: [TableViewPresentable]) {
        
        self.data = data
        tableView.refreshControl?.endRefreshing()
        tableView.reloadData()
        
    }
    
    func didInsertItem(_ item: TableViewPresentable) {
        
        data += [item]
        tableView.reloadData()
        
    }
    
    func deleteItem(at indexPath: IndexPath) {
        
        data.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .automatic)
        
    }
    
}

// MARK: - Segues

extension MenuGroupListVC: SegueHandler {
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let identifierCase = segueIdentifierCase(for: segue)
        
        switch identifierCase {
            
        case .addMenuGroup:
            let vc = segue.destination as! MenuGroupVC
            vc.completion = { name, image in
                self.interactor.addMenuGroup(name: name, image: image)
            }
            
        }
        
    }
}
