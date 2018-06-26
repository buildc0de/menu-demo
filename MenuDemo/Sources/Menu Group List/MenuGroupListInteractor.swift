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
        
        // TODO: Execute DB query
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.delegate?.didLoadData([])            
        }
        
    }
    
    func addMenuGroup(name: String, image: UIImage) {
        
        let viewData = MenuGroupViewData(
            name: name,
            image: image
        )
        let viewModel = MenuGroupViewModel(
            cellType: MenuGroupCell.self,
            viewData: viewData
        )
        
        dbManager.saveMenuGroup(name: name, image: image)
        
        self.delegate?.didInsertItem(viewModel)
        
    }
    
}
