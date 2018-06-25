import UIKit

/// A view controller responsible for adding a new menu group
final class AddMenuGroupVC: UIViewController {

    // MARK: - @IBActions
    @IBOutlet weak var nameTextField: UITextField!
    
    // MARK: - @IBOActions
    @IBAction func didTapSaveButton(_ sender: Any) { save() }
    
    /// A closure that takes `name: String` and `image: UIImage`
    var completion: ((_ name: String, _ image: UIImage) -> Void)?
    
    // MARK: - Private
    fileprivate var image: UIImage?
    
}

fileprivate extension AddMenuGroupVC {
    
    func save() {
        
        completion?(nameTextField.text ?? "", image ?? UIImage())
        navigationController?.popViewController(animated: true)
        
    }
    
}
