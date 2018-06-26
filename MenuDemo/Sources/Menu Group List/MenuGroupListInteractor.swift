import UIKit

protocol InteractorOutput: class {
    
    func showItems()
    func deleteItem(at indexPath: IndexPath)
    
}

final class MenuGroupListInteractor {
    
    // MARK: - Public
    var menuGroups: [TableViewPresentable] { return composedData }
    var output: InteractorOutput?
    
    // MARK: - Private
    fileprivate var dbManager: DBManager! = DBManager()
    fileprivate var data: [MenuGroup] = []
    
}

// MARK: - Public API

extension MenuGroupListInteractor {
    
    func loadData() {
        
        data = dbManager.fetchAllMenuGroups()
        output?.showItems()
        
    }
    
    func addMenuGroup(name: String, image: UIImage) {
        
        let menuGroup = dbManager.insertMenuGroup(name: name, image: image)
        data += [menuGroup]
        
        output?.showItems()
        
    }

    func deleteItem(at indexPath: IndexPath) {

        let menuGroup = data[indexPath.row]
        dbManager.delete(menuGroup)
        data.remove(at: indexPath.row)
        
        output?.deleteItem(at: indexPath)
        
    }
    
}

// MARK: - Helpers

fileprivate extension MenuGroupListInteractor {
    
    var composedData: [TableViewPresentable] {
        
        let composedData = data.map { (menuGroup) -> TableViewPresentable in
            
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
        
        return composedData
        
    }
}
