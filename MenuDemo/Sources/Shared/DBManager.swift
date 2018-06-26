import CoreData
import UIKit

final class DBManager {
    
    func saveMenuGroup(name: String, image: UIImage) {
        
        let managedContext = CoreDataManager.sharedManager.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(
            forEntityName: "MenuGroup",
            in: managedContext
        )!
        
        let menuGroup = NSManagedObject(
            entity: entity,
            insertInto: managedContext
        )
        
        menuGroup.setValue(name, forKeyPath: "name")
        
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
        
    }

}
