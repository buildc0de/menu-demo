import UIKit

/// A view controller responsible for adding or editing a menu group
final class MenuGroupVC: UIViewController {

    // MARK: - @IBOutlets
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var imageViewHeightConstraint: NSLayoutConstraint!
    
    // MARK: - @IBOActions
    @IBAction func didTapSaveButton(_ sender: Any) { save() }
    @IBAction func didTapImagePickerButton(_ sender: Any) { pickImage() }
    
    /// A closure that takes `name: String` and `image: UIImage`
    var completion: ((_ name: String, _ image: UIImage) -> Void)?
    
    // MARK: - Private
    fileprivate var image: UIImage? { didSet { updateImageView() }}
    fileprivate let imagePicker = UIImagePickerController()
    
}

// MARK: - Helpers

fileprivate extension MenuGroupVC {
    
    func save() {
        
        completion?(nameTextField.text ?? "", image ?? UIImage())
        navigationController?.popViewController(animated: true)
        
    }
    
    func pickImage() {
        
        imagePicker.delegate = self
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .photoLibrary
        
        present(imagePicker, animated: true)
        
    }
    
    func updateImageView() {
        
        guard
            let image = image
            else { return }
        
        let aspectRatio = image.size.height / image.size.width
        imageViewHeightConstraint.constant = imageView.bounds.width * aspectRatio
        imageView.image = image
        
    }
    
}

// MARK: - UIImagePickerControllerDelegate, UINavigationControllerDelegate

extension MenuGroupVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            image = pickedImage
        }
        
        dismiss(animated: true)
        
    }

}
