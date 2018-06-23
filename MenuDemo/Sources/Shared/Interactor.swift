import Foundation

protocol Interactor {
    
    var delegate: InteractorDelegate? { get set }
    func loadData()
    
}

protocol InteractorDelegate: class {
    
    func didLoadData(_ data: [TableViewPresentable])
    
}
