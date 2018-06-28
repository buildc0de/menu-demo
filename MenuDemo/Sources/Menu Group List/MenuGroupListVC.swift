import UIKit

/// A view controller responsible for displaying a list of menu groups
final class MenuGroupListVC: UITableViewController, EmptyStatePresenting, ErrorPresenting {

    enum SegueIdentifier: String {
        case addMenuGroup
        case editMenuGroup
        case showMenuItems
    }

    // MARK: - @IBOutlets
    @IBOutlet weak var emptyView: UIView!
    
    // MARK: - Private
    fileprivate var interactor: MenuGroupListInteractor!
    fileprivate var data: [TableViewPresentable] { return interactor.menuGroups }
    fileprivate var selectedIndexPath: IndexPath?
    
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
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        selectedIndexPath = indexPath
        performSegue(withIdentifier: SegueIdentifier.showMenuItems.rawValue, sender: self)

    }

    override func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {

        selectedIndexPath = indexPath
        performSegue(withIdentifier: SegueIdentifier.editMenuGroup.rawValue, sender: self)

    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            interactor.deleteItem(at: indexPath)
        }
        
    }
    
}

// MARK: - InteractorDelegate

extension MenuGroupListVC: InteractorOutput {
    
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

extension MenuGroupListVC: SegueHandler {
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let identifierCase = segueIdentifierCase(for: segue)
        
        switch identifierCase {
            
        case .addMenuGroup:
            let vc = segue.destination as! MenuGroupVC
            vc.completion = { name, image in
                self.interactor.addMenuGroup(name: name, image: image)
            }
            
        case .editMenuGroup:
            
            if let indexPath = selectedIndexPath {
                
                let vc = segue.destination as! MenuGroupVC
                vc.viewMode = .edit
                
                let editData = interactor.editData(for: indexPath)
                vc.name = editData.name
                vc.image = editData.image
                
                vc.completion = { name, image in
                    self.interactor.editMenuGroup(name: name, image: image, indexPath: indexPath)
                }
                
            }
            
        case .showMenuItems:

            if let indexPath = selectedIndexPath {
                
                let menuGroupID = interactor.menuGroupID(for: indexPath)
                let vc = segue.destination as! MenuItemListVC
                vc.menuGroupID = menuGroupID
                
            }
            
        }
        
    }
}
