import UIKit

extension MenuGroup {
    
    var image: UIImage? {
    
        guard
            let imageName = imageName
            else { return nil }
        
        let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let path = documentsURL.appendingPathComponent(imageName).path
        
        guard
            FileManager.default.fileExists(atPath: path),
            let image = UIImage(contentsOfFile: path)
            else { return nil }
        
        return image
        
    }
    
}
