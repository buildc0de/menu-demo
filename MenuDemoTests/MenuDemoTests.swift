import CoreData
import XCTest
@testable import MenuDemo

class MenuDemoTests: XCTestCase {
    
    var dbManager: DBManager!
    
    lazy var managedObjectModel: NSManagedObjectModel = {
        let managedObjectModel = NSManagedObjectModel.mergedModel(from: [Bundle(for: type(of: self))] )!
        return managedObjectModel
    }()
    
    lazy var mockPersistantContainer: NSPersistentContainer = {
        
        let container = NSPersistentContainer(name: "Menu", managedObjectModel: managedObjectModel)
        let description = NSPersistentStoreDescription()
        description.type = NSInMemoryStoreType
        description.shouldAddStoreAsynchronously = false
        
        container.persistentStoreDescriptions = [description]
        container.loadPersistentStores { (description, error) in

            precondition( description.type == NSInMemoryStoreType )
            
            if let error = error {
                fatalError("Create an in-mem coordinator failed \(error)")
            }
        }
        return container
    }()
    
    override func setUp() {
        
        super.setUp()
        
        initStubs()
        dbManager = DBManager(container: mockPersistantContainer)
        
    }
    
    override func tearDown() {

        super.tearDown()
        flushData()
        
    }
    
    func initStubs() {
        
        @discardableResult
        func insertMenuGroup(name: String) -> MenuGroup? {
            
            let object = NSEntityDescription.insertNewObject(
                forEntityName: "MenuGroup",
                into: mockPersistantContainer.viewContext
            )            
            object.setValue(name, forKey: "name")
            
            return object as? MenuGroup
            
        }
        
        insertMenuGroup(name: "1")
        insertMenuGroup(name: "2")
        insertMenuGroup(name: "3")
        insertMenuGroup(name: "4")
        insertMenuGroup(name: "5")
        
        do {
            try mockPersistantContainer.viewContext.save()
        }  catch {
            print(error)
            fatalError("Unable to save stubs")
        }
        
    }
    
    func flushData() {
        
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest<NSFetchRequestResult>(entityName: "MenuGroup")

        let objects = try! mockPersistantContainer.viewContext.fetch(fetchRequest)
        for case let obj as NSManagedObject in objects {
            mockPersistantContainer.viewContext.delete(obj)
        }
        do {
            try mockPersistantContainer.viewContext.save()
        } catch {
            print(error)
            fatalError("Unable to flush data")
        }
        
    }
    
    var numberOfItemsInPersistentStore: Int {
        
        let request: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "MenuGroup")
        let results = try! mockPersistantContainer.viewContext.fetch(request)
        return results.count
        
    }
    
    func testFetchAllMenuGroups() {
        
        let results = dbManager.fetchAllMenuGroups()
        XCTAssertEqual(results.count, 5)
        
    }
    
    func testCreateMenuGroup() {

        let name = "1"
        let menuGroup = dbManager.insertMenuGroup(name: name, image: nil)

        XCTAssertNotNil(menuGroup)

    }

    func testDeleteMenuGroup() {
        
        let items = dbManager.fetchAllMenuGroups()
        let item = items[0]
        
        let numberOfItems = items.count
        
        dbManager.delete(item)
        
        XCTAssertEqual(numberOfItemsInPersistentStore, numberOfItems - 1)
        
    }

    func testUpdateMenuGroup() {

        let items = dbManager.fetchAllMenuGroups()
        let item = items[0]

        let editedName = "Edited Name"
        let editedItem = dbManager.updateMenuGroup(item, name: editedName, image: nil)

        XCTAssertEqual(editedItem.name, editedName)

    }
    
}
