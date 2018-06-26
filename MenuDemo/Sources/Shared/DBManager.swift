import CoreData
import UIKit

final class DBManager {
    
    fileprivate let managedContext = CoreDataManager.sharedManager.persistentContainer.viewContext
    
    func saveMenuGroup(name: String, image: UIImage) {
        
        let menuGroup = MenuGroup(context: managedContext)
        menuGroup.name = name
        
        do {
            
            let imageName = try saveImage(image)
            menuGroup.imageName = imageName
            
        } catch let error as NSError {
            print("Could not save image: \(error), \(error.userInfo)")
        }
        
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Could not save object: \(error), \(error.userInfo)")
        }
        
    }
    
    func fetchAllMenuGroups() -> [MenuGroup] {
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "MenuGroup")
        do {
            let items = try managedContext.fetch(fetchRequest) as? [MenuGroup]
            return items ?? []
        } catch let error as NSError {
            print("Could not fetch: \(error), \(error.userInfo)")
        }
        
        return []
        
    }

}

// MARK: - Helpers

fileprivate extension DBManager {
    
    func saveImage(_ image: UIImage) throws -> String {
        
        let imageUUID = UUID()
        let imageData = UIImagePNGRepresentation(image)
        let imageName = "\(imageUUID).png"
        
        let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let url = documentsURL.appendingPathComponent(imageName)
        try imageData?.write(to: url, options: .atomic)
        
        return imageName
        
    }
    
}
