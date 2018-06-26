import CoreData
import UIKit

final class DBManager {
    
    fileprivate let persistentContainer = CoreDataManager.sharedManager.persistentContainer
    fileprivate let managedContext = CoreDataManager.sharedManager.persistentContainer.viewContext
    
    func insertMenuGroup(name: String, image: UIImage) -> MenuGroup {
        
        let newMenuGroup = MenuGroup(context: managedContext)
        let menuGroup = updateMenuGroup(newMenuGroup, name: name, image: image)
        
        return menuGroup
        
    }
    
    func updateMenuGroup(_ menuGroup: MenuGroup, name: String, image: UIImage) -> MenuGroup {
        
        menuGroup.name = name
        
        do {
            
            menuGroup.deleteImage()
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
        
        return menuGroup
        
    }
    
    func delete(_ menuGroup: MenuGroup) {

        do {
            
            menuGroup.deleteImage()
            managedContext.delete(menuGroup)
            try managedContext.save()
            
        } catch let error as NSError {
            print("Could not save image: \(error), \(error.userInfo)")
        }
        
    }
    
    func fetchAllMenuGroups() -> [MenuGroup] {
        
        let fetchRequest = NSFetchRequest<MenuGroup>(entityName: MenuGroup.entity().name!)
        do {
            let items = try managedContext.fetch(fetchRequest)
            return items
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
        
        let url = MenuGroup.imageFolderURL.appendingPathComponent(imageName)
        try imageData?.write(to: url, options: .atomic)
        
        return imageName
        
    }
    
}
