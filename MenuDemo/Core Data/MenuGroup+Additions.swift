import UIKit

extension MenuGroup {
    
    static let imageFolderURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    
    var image: UIImage? {
    
        guard
            let imageName = imageName
            else { return nil }
        
        let path = MenuGroup.imageFolderURL.appendingPathComponent(imageName).path
        
        guard
            FileManager.default.fileExists(atPath: path),
            let image = UIImage(contentsOfFile: path)
            else { return nil }
        
        return image
        
    }
    
    func deleteImage() {

        guard
            let imageName = imageName
            else { return }

        let path = MenuGroup.imageFolderURL.appendingPathComponent(imageName).path
        
        if FileManager.default.isDeletableFile(atPath: path) {
            
            do {
                try FileManager.default.removeItem(atPath: path)
            } catch let error as NSError {
                print("Could not delete: \(error), \(error.userInfo)")
            }

        }
        
    }
    
}
