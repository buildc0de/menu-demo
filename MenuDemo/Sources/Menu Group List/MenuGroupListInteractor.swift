import UIKit

protocol InteractorDelegate: class {
    
    func didLoadData(_ data: [TableViewPresentable])
    func didInsertItem(_ item: TableViewPresentable)
    
}

final class MenuGroupListInteractor {
    
    // MARK: - Public
    var delegate: InteractorDelegate?
    
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
        
        // TODO: Save in the DB
        
        self.delegate?.didInsertItem(viewModel)
        
    }
    
}
