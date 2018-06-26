import UIKit

protocol InteractorDelegate: class {
    
    func didLoadData(_ data: [TableViewPresentable])
    func didInsertItem(_ item: TableViewPresentable)
    
}

final class MenuGroupListInteractor {
    
    // MARK: - Public
    var delegate: InteractorDelegate?
    
    // MARK: - Private
    fileprivate var dbManager: DBManager! = DBManager()
    
}

// MARK: - Public API

extension MenuGroupListInteractor {
    
    func loadData() {
        
        let menuGroups = dbManager.fetchAllMenuGroups()
        
        let items = menuGroups.map { (menuGroup) -> TableViewPresentable in
            
            let viewData = MenuGroupViewData(
                name: menuGroup.name ?? "",
                image: nil
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
        
        dbManager.saveMenuGroup(name: name, image: image)
        
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
    
}
