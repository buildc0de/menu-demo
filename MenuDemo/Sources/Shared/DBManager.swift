import CoreData
import UIKit

final class DBManager {
    
    let persistentContainer: NSPersistentContainer!
    
    init(container: NSPersistentContainer) {
        self.persistentContainer = container
    }
    
    convenience init() {
        self.init(container: CoreDataManager.sharedManager.persistentContainer)
    }
    
}

// MARK: - Public API

extension DBManager {
    
    func insertMenuGroup(name: String, image: UIImage?) -> MenuGroup {
        
        let newMenuGroup = MenuGroup(context: persistentContainer.viewContext)
        let menuGroup = updateMenuGroup(newMenuGroup, name: name, image: image)
        
        return menuGroup
        
    }
    
    func updateMenuGroup(_ menuGroup: MenuGroup, name: String, image: UIImage?) -> MenuGroup {
        
        menuGroup.name = name
        
        if let image = image {
        
            do {
                
                menuGroup.deleteImage()
                
                let imageName = try saveImage(image)
                menuGroup.imageName = imageName
                
            } catch let error as NSError {
                print("Could not save image: \(error), \(error.userInfo)")
            }
            
        }
        
        do {
            try persistentContainer.viewContext.save()
        } catch let error as NSError {
            print("Could not save object: \(error), \(error.userInfo)")
        }
        
        return menuGroup
        
    }
    
    func delete(_ menuGroup: MenuGroup) {

        do {
            
            menuGroup.deleteImage()
            persistentContainer.viewContext.delete(menuGroup)
            try persistentContainer.viewContext.save()
            
        } catch let error as NSError {
            print("Could not save image: \(error), \(error.userInfo)")
        }
        
    }
    
    func fetchAllMenuGroups() -> [MenuGroup] {
        
        let fetchRequest = NSFetchRequest<MenuGroup>(entityName: "MenuGroup")
        do {
            let items = try persistentContainer.viewContext.fetch(fetchRequest)
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
