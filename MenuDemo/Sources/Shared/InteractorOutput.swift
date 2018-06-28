import Foundation

protocol InteractorOutput: class, ErrorPresenting {
    
    func showItems()
    func updateItem(at indexPath: IndexPath)
    func deleteItem(at indexPath: IndexPath)
    
}
