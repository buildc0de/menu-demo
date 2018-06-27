import UIKit

/// A view controller responsible for adding or editing a menu item
final class MenuItemVC: UIViewController {
    
    struct Options {
        static let addTitle = NSLocalizedString("menu-item.title.add", comment: "")
        static let editTitle = NSLocalizedString("menu-item.title.edit", comment: "")
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
    
    /// A closure that takes `name: String` and `image: UIImage`
    var completion: ((_ name: String, _ price: NSDecimalNumber, _ image: UIImage) -> Void)?
    
    // MARK: - Public
    var name: String?
    var image: UIImage?
    var viewMode: ViewMode = .add
    
    // MARK: - Private
    fileprivate let imagePicker = UIImagePickerController()
    
}

// MARK: - Lifecycle

extension MenuItemVC {
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        configureTitle()
        configureNameTextField()
        configureImageView()
        
    }
    
}

// MARK: - Configuration

extension MenuItemVC {
    
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

fileprivate extension MenuItemVC {
    
    func save() {
        
        completion?(nameTextField.text ?? "", 0, image ?? UIImage())
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

extension MenuItemVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            image = pickedImage
            configureImageView()
        }
        
        dismiss(animated: true)
        
    }
    
}
