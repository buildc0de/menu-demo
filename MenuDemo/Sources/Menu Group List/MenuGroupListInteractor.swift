import UIKit

protocol InteractorDelegate: class {
    
    func didLoadData(_ data: [TableViewPresentable])
    func didInsertItem(_ item: TableViewPresentable)
    func deleteItem(at indexPath: IndexPath)
    
}

final class MenuGroupListInteractor {
    
    // MARK: - Public
    var delegate: InteractorDelegate?
    
    // MARK: - Private
    fileprivate var dbManager: DBManager! = DBManager()
    fileprivate var data: [MenuGroup] = []
    
}

// MARK: - Public API

extension MenuGroupListInteractor {
    
    func loadData() {
        
        data = dbManager.fetchAllMenuGroups()
        
        let items = data.map { (menuGroup) -> TableViewPresentable in
            
            let viewData = MenuGroupViewData(
                name: menuGroup.name ?? "",
                image: menuGroup.image
            )
            let viewModel = MenuGroupViewModel(
                cellType: MenuGroupCell.self,
                viewData: viewData
            )
            
            return viewModel
            
        }
        
        delegate?.didLoadData(items)
        
    }
    
    func addMenuGroup(name: String, image: UIImage) {
        
        let menuGroup = dbManager.insertMenuGroup(name: name, image: image)
        
        data += [menuGroup]
        
        let viewData = MenuGroupViewData(
            name: name,
            image: image
        )
        let viewModel = MenuGroupViewModel(
            cellType: MenuGroupCell.self,
            viewData: viewData
        )
        delegate?.didInsertItem(viewModel)
        
    }

    func deleteItem(at indexPath: IndexPath) {

        let menuGroup = data[indexPath.row]
        dbManager.delete(menuGroup)
        data.remove(at: indexPath.row)
        delegate?.deleteItem(at: indexPath)
        
    }
    
}
