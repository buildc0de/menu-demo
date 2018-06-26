import CoreData
import UIKit

final class DBManager {
    
    func saveMenuGroup(name: String, image: UIImage) {
        
        let managedContext = CoreDataManager.sharedManager.persistentContainer.viewContext
        let menuGroup = MenuGroup(context: managedContext)
        menuGroup.name = name
        
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
        
    }
    
    func fetchAllMenuGroups() -> [MenuGroup] {
        
        let managedContext = CoreDataManager.sharedManager.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "MenuGroup")
        do {
            let items = try managedContext.fetch(fetchRequest) as? [MenuGroup]
            return items ?? []
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        
        return []
        
    }

}
