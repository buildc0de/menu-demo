import UIKit

/// A class responsible for Menu Group data logic
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
        
        do {
            data = try dbManager.fetchAllMenuGroups()
            output?.showItems()
        } catch {
            output?.presentError(error)
        }
        
    }
    
    func addMenuGroup(name: String, image: UIImage?) {
        
        do {
            
            let menuGroup = try dbManager.insertMenuGroup(name: name, image: image)
            data += [menuGroup]
            output?.showItems()
            
        } catch {
            output?.presentError(error)
        }
        
    }

    func editMenuGroup(name: String, image: UIImage?, indexPath: IndexPath) {
        
        let menuGroup = data[indexPath.row]
        
        do {
            
            let editedMenuGroup = try dbManager.updateMenuGroup(menuGroup, name: name, image: image)
            data[indexPath.row] = editedMenuGroup
            output?.updateItem(at: indexPath)
            
        } catch {
            output?.presentError(error)
        }
        
    }
    
    func deleteItem(at indexPath: IndexPath) {

        let menuGroup = data[indexPath.row]
        
        do {
            
            try dbManager.delete(menuGroup)
            data.remove(at: indexPath.row)
            output?.deleteItem(at: indexPath)
            
        } catch {
            output?.presentError(error)
        }
        
    }
    
    func editData(for indexPath: IndexPath) -> (name: String?, image: UIImage?) {
        
        let menuGroup = data[indexPath.row]
        return (menuGroup.name, menuGroup.image?.image)
        
    }
    
    func menuGroupID(for indexPath: IndexPath) -> URL {
        
        let menuGroup = data[indexPath.row]
        return menuGroup.objectID.uriRepresentation()
        
    }
    
}

// MARK: - Helpers

fileprivate extension MenuGroupListInteractor {
    
    var composedData: [TableViewPresentable] {
        
        let composedData = data.map { (menuGroup) -> TableViewPresentable in
            
            let viewData = MenuGroupViewData(
                name: menuGroup.name ?? "",
                image: menuGroup.image?.image
            )
            let viewModel = ViewModel(
                cellType: MenuGroupCell.self,
                viewData: viewData
            )
            
            return viewModel
            
        }
        
        return composedData
        
    }
}
