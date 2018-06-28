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

// MARK: - Public MenuGroup API

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
                
                menuGroup.image?.deleteImage()
                
                let newImage = try saveImage(image)
                menuGroup.image = newImage
                
            } catch {
                print("Could not save image: \(error)")
                throw DBError.unableToSaveData
            }
            
        }
        
        do {
            try persistentContainer.viewContext.save()
        } catch {
            print("Could not save: \(error)")
            throw DBError.unableToSaveData
        }
        
        return menuGroup
        
    }
    
    func delete(_ menuGroup: MenuGroup) throws {

        do {
            
            persistentContainer.viewContext.delete(menuGroup)
            try persistentContainer.viewContext.save()
            
        } catch {
            print("Could not delete: \(error)")
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

// MARK: - Public MenuItem API

extension DBManager {
    
    func insertMenuItem(menuGroupID: URL, name: String, price: NSDecimalNumber, image: UIImage?) throws -> MenuItem {
        
        let parentMenuGroup = try menuGroup(id: menuGroupID)
        let newMenuItem = MenuItem(context: persistentContainer.viewContext)
        newMenuItem.menuGroup = parentMenuGroup
        let menuItem = try updateMenuItem(newMenuItem, name: name, price: price, image: image)
        
        return menuItem
        
    }
    
    func updateMenuItem(_ menuItem: MenuItem, name: String, price: NSDecimalNumber, image: UIImage?) throws -> MenuItem {
        
        menuItem.name = name
        menuItem.price = price
        
        if let image = image {
            
            do {
                
                menuItem.image?.deleteImage()
                
                let newImage = try saveImage(image)
                menuItem.image = newImage
                
            } catch {
                print("Could not save image: \(error)")
                throw DBError.unableToSaveData
            }
            
        }
        
        do {
            try persistentContainer.viewContext.save()
        } catch {
            print("Could not save: \(error)")
            throw DBError.unableToSaveData
        }
        
        return menuItem
        
    }
    
    func delete(_ menuItem: MenuItem) throws {
        
        do {
            
            persistentContainer.viewContext.delete(menuItem)
            try persistentContainer.viewContext.save()
            
        } catch {
            print("Could not delete: \(error)")
            throw DBError.unableToSaveData
        }
        
    }
    
    func fetchAllMenuItems(for menuGroupID: URL) throws -> [MenuItem] {
        
        let parentMenuGroup = try menuGroup(id: menuGroupID)
        let fetchRequest = NSFetchRequest<MenuItem>(entityName: "MenuItem")
        let predicate = NSPredicate(format: "menuGroup == %@", parentMenuGroup)
        fetchRequest.predicate = predicate
        
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
    
    func saveImage(_ image: UIImage) throws -> Image {
        
        let uuid = UUID()
        let data = UIImagePNGRepresentation(image)
        let name = "\(uuid).png"
        
        let url = Image.imageFolderURL.appendingPathComponent(name)
        try data?.write(to: url, options: .atomic)
        
        let newImage = Image(context: persistentContainer.viewContext)
        newImage.name = name
        
        return newImage
        
    }
    
    func menuGroup(id: URL) throws -> MenuGroup {
        
        guard
            let menuGroupObjectID = persistentContainer.persistentStoreCoordinator.managedObjectID(forURIRepresentation: id),
            let menuGroup = persistentContainer.viewContext.object(with: menuGroupObjectID) as? MenuGroup
            else { throw DBError.unexpectedData }
        
        return menuGroup
        
    }
    
}
