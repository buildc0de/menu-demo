import Foundation

final class MenuGroupListInteractor: Interactor {
    
    var delegate: InteractorDelegate?
    
    func loadData() {
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.delegate?.didLoadData([])            
        }
        
    }
    
}
