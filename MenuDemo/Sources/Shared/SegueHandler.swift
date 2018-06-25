import UIKit

protocol SegueHandler {
    associatedtype SegueIdentifier: RawRepresentable
}

extension SegueHandler
    where Self: UIViewController,
SegueIdentifier.RawValue == String {
    
    func performSegueWithIdentifier(segueIdentifier: SegueIdentifier,
                                    sender: AnyObject?) {
        
        performSegue(withIdentifier: segueIdentifier.rawValue, sender: sender)
        
    }
    
    func segueIdentifierCase(for segue: UIStoryboardSegue) -> SegueIdentifier {
        
        guard
            let identifier = segue.identifier,
            let segueIdentifier = SegueIdentifier(rawValue: identifier)
            else { fatalError("Invalid segue identifier: \(segue.identifier ?? "").") }
        
        return segueIdentifier
        
    }
    
}
