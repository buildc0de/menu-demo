import UIKit

/// A class responsible for Menu Item data logic
final class MenuItemListInteractor {
    
    // MARK: - Public
    let menuGroupID: URL
    var menuItems: [TableViewPresentable] { return composedData }
    var output: InteractorOutput?
    
    // MARK: - Private
    fileprivate var dbManager: DBManager! = DBManager()
    fileprivate var data: [MenuItem] = []
    
    init(menuGroupID: URL) {
        self.menuGroupID = menuGroupID
    }
    
}

// MARK: - Public API

extension MenuItemListInteractor {
    
    func loadData() {
        
        do {
            data = try dbManager.fetchAllMenuItems(for: menuGroupID)
            output?.showItems()
        } catch {
            output?.presentError(error)
        }
        
    }
    
    func addMenuItem(name: String, price: NSDecimalNumber, image: UIImage?) {
        
        do {
            
            let menuItem = try dbManager.insertMenuItem(menuGroupID: menuGroupID, name: name, price: price, image: image)
            data += [menuItem]
            output?.showItems()
            
        } catch {
            output?.presentError(error)
        }
        
    }
    
    func editMenuItem(name: String, price: NSDecimalNumber, image: UIImage?, indexPath : IndexPath) {
        
        let menuItem = data[indexPath.row]
        
        do {
            
            let editedMenuItem = try dbManager.updateMenuItem(menuItem, name: name, price: price, image: image)
            data[indexPath.row] = editedMenuItem
            output?.updateItem(at: indexPath)
            
        } catch {
            output?.presentError(error)
        }
        
    }
    
    func deleteItem(at indexPath: IndexPath) {
        
        let menuItem = data[indexPath.row]
        
        do {
            
            try dbManager.delete(menuItem)
            data.remove(at: indexPath.row)
            output?.deleteItem(at: indexPath)
            
        } catch {
            output?.presentError(error)
        }
        
    }
    
    func editData(for indexPath: IndexPath) -> (name: String?, price: NSDecimalNumber?, image: UIImage?) {
        
        let menuItem = data[indexPath.row]
        return (menuItem.name, menuItem.price, menuItem.image?.image)
        
    }
    
}

// MARK: - Helpers

fileprivate extension MenuItemListInteractor {
    
    var composedData: [TableViewPresentable] {
        
        let composedData = data.map { (menuItem) -> TableViewPresentable in
            
            let viewData = MenuItemViewData(
                name: menuItem.name ?? "",
                price: menuItem.price ?? 0,
                image: menuItem.image?.image
            )
            let viewModel = ViewModel(
                cellType: MenuItemCell.self,
                viewData: viewData
            )
            
            return viewModel
            
        }
        
        return composedData
        
    }
}
