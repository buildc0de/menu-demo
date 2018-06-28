import UIKit

/// A view controller responsible for adding or editing a menu group
final class MenuGroupVC: UIViewController {

    struct Options {
        static let addTitle = NSLocalizedString("menu-group.title.add", comment: "")
        static let editTitle = NSLocalizedString("menu-group.title.edit", comment: "")
    }
    
    enum ViewMode {
        case add
        case edit
    }
    
    // MARK: - @IBOutlets
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var imageViewHeightConstraint: NSLayoutConstraint!
    
    // MARK: - @IBOActions
    @IBAction func didTapSaveButton(_ sender: Any) { save() }
    @IBAction func didTapImagePickerButton(_ sender: Any) { pickImage() }
    
    /// A closure that takes `name:`, `image`
    var completion: ((_ name: String, _ image: UIImage?) -> Void)?

    // MARK: - Public
    var name: String?
    var image: UIImage?
    var viewMode: ViewMode = .add
    
    // MARK: - Private
    fileprivate let imagePicker = UIImagePickerController()
    
}

// MARK: - Lifecycle

extension MenuGroupVC {
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        configureTitle()
        configureNameTextField()
        configureImageView()
        
    }
    
}

// MARK: - Configuration

extension MenuGroupVC {
    
    func configureTitle() {
        
        switch viewMode {
        case .add:
            title = Options.addTitle
            
        case .edit:
            title = Options.editTitle
            
        }
        
    }
    
    func configureNameTextField() {
        nameTextField.text = name
    }
    
    func configureImageView() {
        
        guard
            let image = image
            else { return }
        
        let aspectRatio = image.size.height / image.size.width
        imageViewHeightConstraint.constant = imageView.bounds.width * aspectRatio
        imageView.image = image
        
    }
    
}

// MARK: - Helpers

fileprivate extension MenuGroupVC {
    
    func save() {
        
        completion?(nameTextField.text ?? "", image)
        navigationController?.popViewController(animated: true)
        
    }
    
    func pickImage() {
        
        imagePicker.delegate = self
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .photoLibrary
        
        present(imagePicker, animated: true)
        
    }
    
}

// MARK: - UIImagePickerControllerDelegate, UINavigationControllerDelegate

extension MenuGroupVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            image = pickedImage
            configureImageView()
        }
        
        dismiss(animated: true)
        
    }

}
