import CoreData

class CoreDataManager {
    static var shared = CoreDataManager()
    
    private let persistentContainer: NSPersistentContainer
    
    init(container: NSPersistentContainer = CoreDataManager.defaultContainer) {
        self.persistentContainer = container
    }
    
    static var defaultContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "MoviesModel")
        container.loadPersistentStores { storeDescription, error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
        return container
    }()
    

    var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }

    func saveContext() {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}

