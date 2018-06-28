import UIKit

extension UIImage {
    
    var pngRepresentation: Data? {
        
        guard
            let flattened = flattened
            else { return nil }
        
        return UIImagePNGRepresentation(flattened)
        
    }
    
    var flattened: UIImage? {
        
        guard
            imageOrientation != .up
            else { return self }
        
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        defer { UIGraphicsEndImageContext() }
        draw(in: CGRect(origin: .zero, size: size))
        
        return UIGraphicsGetImageFromCurrentImageContext()
        
    }
    
}
