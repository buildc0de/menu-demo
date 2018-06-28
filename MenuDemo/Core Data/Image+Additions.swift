import UIKit

extension Image {
    
    static let imageFolderURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    
    var image: UIImage? {
    
        guard
            let name = name
            else { return nil }
        
        let path = Image.imageFolderURL.appendingPathComponent(name).path
        
        guard
            FileManager.default.fileExists(atPath: path),
            let image = UIImage(contentsOfFile: path)
            else { return nil }
        
        return image
        
    }
    
    public override func prepareForDeletion() {
        deleteImage()
    }
    
    public override func willSave() {
        
        if
            menuGroup == nil,
            menuItem == nil,
            !isDeleted
        {
            managedObjectContext?.delete(self)
        }
        
    }
    
    func deleteImage() {

        guard
            let name = name
            else { return }

        let path = Image.imageFolderURL.appendingPathComponent(name).path
        
        if FileManager.default.isDeletableFile(atPath: path) {
            
            do {
                try FileManager.default.removeItem(atPath: path)
            } catch let error as NSError {
                print("Could not delete: \(error), \(error.userInfo)")
            }

        }
        
    }
    
}
