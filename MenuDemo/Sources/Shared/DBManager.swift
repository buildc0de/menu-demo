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
    
    func insertMenuGroup(name: String, image: UIImage?) throws -> MenuGroup {
        
        let newMenuGroup = MenuGroup(context: persistentContainer.viewContext)
        let menuGroup = try updateMenuGroup(newMenuGroup, name: name, image: image)
        
        return menuGroup
        
    }
    
    func updateMenuGroup(_ menuGroup: MenuGroup, name: String, image: UIImage?) throws -> MenuGroup {
        
        menuGroup.name = name
        
        if let image = image {
        
            do {
                
                menuGroup.deleteImage()
                
                let imageName = try saveImage(image)
                menuGroup.imageName = imageName
                
            } catch {
                print("Could not save image: \(error)")
                throw DBError.unableToSaveData
            }
            
        }
        
        do {
            try persistentContainer.viewContext.save()
        } catch {
            print("Could not save object: \(error)")
            throw DBError.unableToSaveData
        }
        
        return menuGroup
        
    }
    
    func delete(_ menuGroup: MenuGroup) throws {

        do {
            
            menuGroup.deleteImage()
            persistentContainer.viewContext.delete(menuGroup)
            try persistentContainer.viewContext.save()
            
        } catch {
            print("Could not save image: \(error)")
            throw DBError.unableToSaveData
        }
        
    }
    
    func fetchAllMenuGroups() throws -> [MenuGroup] {
        
        let fetchRequest = NSFetchRequest<MenuGroup>(entityName: "MenuGroup")
        do {
            let items = try persistentContainer.viewContext.fetch(fetchRequest)
            return items
        } catch {
            print("Could not fetch: \(error)")
            throw DBError.unableToFetchData
        }
        
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
