import Foundation
import UIKit

protocol ErrorPresenting {
    func presentError(_ error: Error)
}

extension ErrorPresenting where Self: UIViewController {
    
    func presentError(_ error: Error) {
        
        let alertVC = UIAlertController(
            title: NSLocalizedString("generic-error-title", comment: ""),
            message: error.localizedDescription,
            preferredStyle: .alert
        )
        let action = UIAlertAction(
            title: "OK",
            style: .default
        )
        alertVC.addAction(action)
        
        present(alertVC, animated: true, completion: nil)
        
    }
    
}
