import UIKit

/// A view controller responsible for displaying a list of menu items
final class MenuItemListVC: UITableViewController, EmptyStatePresenting, ErrorPresenting {
    
    enum SegueIdentifier: String {
        case addMenuItem
        case editMenuItem
    }
    
    // MARK: - @IBOutlets
    @IBOutlet weak var emptyView: UIView!

    // MARK: - Public
    var menuGroupID: URL!
    
    // MARK: - Private
    fileprivate var interactor: MenuItemListInteractor!
    fileprivate var data: [TableViewPresentable] { return interactor.menuItems }
    fileprivate var selectedIndexPath: IndexPath?
    
    // MARK: - EmptyStatePresenting
    var hasContent: Bool { return data.count > 0 }
    
}

// MARK: - Lifecycle

extension MenuItemListVC {
    
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

fileprivate extension MenuItemListVC {
    
    func configureInteractor() {
        
        interactor = MenuItemListInteractor(menuGroupID: menuGroupID)
        interactor.output = self
        
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

fileprivate extension MenuItemListVC {
    
    @objc func refresh() {
        
        tableView.refreshControl?.beginRefreshing()
        reloadData()
        
    }
    
    func reloadData() {
        interactor.loadData()
    }
    
}

// MARK: - UITableViewDataSource

extension MenuItemListVC {
    
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

extension MenuItemListVC {
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        selectedIndexPath = indexPath
        performSegue(withIdentifier: SegueIdentifier.editMenuItem.rawValue, sender: self)

    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            interactor.deleteItem(at: indexPath)
        }
        
    }
    
}

// MARK: - InteractorDelegate

extension MenuItemListVC: InteractorOutput {
    
    func showItems() {
        
        tableView.refreshControl?.endRefreshing()
        updateEmptyView()
        tableView.reloadData()
        
    }
    
    func deleteItem(at indexPath: IndexPath) {
        
        updateEmptyView()
        tableView.deleteRows(at: [indexPath], with: .automatic)
        
    }
    
    func updateItem(at indexPath: IndexPath) {
        tableView.reloadRows(at: [indexPath], with: .automatic)
    }
    
}

// MARK: - Segues

extension MenuItemListVC: SegueHandler {
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let identifierCase = segueIdentifierCase(for: segue)
        
        switch identifierCase {
            
        case .addMenuItem:
            let vc = segue.destination as! MenuItemVC
            vc.completion = { name, price, image in
                self.interactor.addMenuItem(name: name, price: price, image: image)
            }
            
        case .editMenuItem:
            
            if let indexPath = selectedIndexPath {
                
                let vc = segue.destination as! MenuItemVC
                vc.viewMode = .edit
                
                let editData = interactor.editData(for: indexPath)
                vc.name = editData.name
                vc.price = editData.price
                
                vc.completion = { name, price, image in
                    self.interactor.editMenuItem(name: name, price: price, image: image, indexPath: indexPath)
                }
                
            }
            
        }
        
    }
}
