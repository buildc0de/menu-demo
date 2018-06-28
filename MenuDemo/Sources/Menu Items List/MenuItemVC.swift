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
    @IBOutlet weak var priceTextField: UITextField!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var imageViewHeightConstraint: NSLayoutConstraint!
    
    // MARK: - @IBOActions
    @IBAction func didTapSaveButton(_ sender: Any) { save() }
    @IBAction func didTapImagePickerButton(_ sender: Any) { pickImage() }
    
    /// A closure that takes `name`, `price`, `image`
    var completion: ((_ name: String, _ price: NSDecimalNumber, _ image: UIImage?) -> Void)?
    
    // MARK: - Public
    var name: String?
    var price: NSDecimalNumber?
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
        configurePriceTextField()
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
    
    func configurePriceTextField() {
        
        priceTextField.delegate = self
        priceTextField.text = price?.stringValue
        
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
        
        completion?(nameTextField.text ?? "", decimal(with: priceTextField.text), image)
        navigationController?.popViewController(animated: true)
        
    }
    
    func decimal(with string: String?) -> NSDecimalNumber {
        
        let string = string ?? "0"
        let formatter = NumberFormatter()
        formatter.generatesDecimalNumbers = true
        return formatter.number(from: string) as? NSDecimalNumber ?? 0
        
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

// MARK: - UITextFieldDelegate

extension MenuItemVC: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        guard
            let oldText = textField.text,
            let range = Range(range, in: oldText)
            else { return true }
        
        let newText = oldText.replacingCharacters(in: range, with: string)
        let isNumeric = newText.isEmpty || (Double(newText) != nil)
        let numberOfDots = newText.components(separatedBy: ".").count - 1
        
        let numberOfDecimalDigits: Int
        if let dotIndex = newText.index(of: ".") {
            numberOfDecimalDigits = newText.distance(from: dotIndex, to: newText.endIndex) - 1
        } else {
            numberOfDecimalDigits = 0
        }
        
        return isNumeric && numberOfDots <= 1 && numberOfDecimalDigits <= 2
        
    }
    
}
