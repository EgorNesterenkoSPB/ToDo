import Foundation
import CoreData

enum PriorityTask:String {
    case high
    case medium
    case low
}

class DataManager {
    static let shared = DataManager()
    
    lazy var persistentContainer:NSPersistentContainer = {
        let container = NSPersistentContainer(name: Resources.coreModelName)
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolver error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    func save() {
        let context = persistentContainer.viewContext
        
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nsError = error as NSError
                fatalError("Unresolver error \(nsError), \(nsError.userInfo)")
            }
        }
    }
    
    func project(name:String) -> ProjectCoreData {
        let project = ProjectCoreData(context: persistentContainer.viewContext)
        project.name = name
        return project
    }
    
    func category(name:String,project:ProjectCoreData) -> CategoryCoreData {
        let category = CategoryCoreData(context: persistentContainer.viewContext)
        category.name = name
        project.addToCategories(category)
        return category
    }
    
    func task(name: String, description:String, priority:PriorityTask, time:Date,category:CategoryCoreData) -> TaskCoreData {
        let task = TaskCoreData(context: persistentContainer.viewContext)
        task.name = name
        task.descriptionTask = description
        task.priority = priority.rawValue
        task.time = time
        category.addToTasks(task)
        return task
    }
    
    func projects() -> [ProjectCoreData] {
        let request:NSFetchRequest<ProjectCoreData> = ProjectCoreData.fetchRequest()
        var fetchedProjects:[ProjectCoreData] = []
        
        do {
            fetchedProjects = try persistentContainer.viewContext.fetch(request)
        } catch let error {
            print("Error fetching projects \(error)")
        }
        return fetchedProjects
    }
    
    func categories(project:ProjectCoreData) -> [CategoryCoreData] {
        let request:NSFetchRequest<CategoryCoreData> = CategoryCoreData.fetchRequest()
        request.predicate = NSPredicate(format: "project = %@", project)
        request.sortDescriptors = [NSSortDescriptor(key: "releaseDate", ascending: false)]
        
        var fetchedCategories:[CategoryCoreData] = []
        
        do {
            fetchedCategories = try persistentContainer.viewContext.fetch(request)
        } catch let error {
            print("Error fetching categories \(error)")
        }
        return fetchedCategories
    }
    
    func tasks(category:CategoryCoreData) -> [TaskCoreData] {
        let request:NSFetchRequest<TaskCoreData> = TaskCoreData.fetchRequest()
        request.predicate = NSPredicate(format: "category = %@",category)
        request.sortDescriptors = [NSSortDescriptor(key: "releaseDate", ascending: false)]
        
        var fetchedTasks:[TaskCoreData] = []
        
        do {
            fetchedTasks = try persistentContainer.viewContext.fetch(request)
        } catch let error {
            print("Error fetching tasks \(error)")
        }
        return fetchedTasks
    }
    
    func deleteProject(project:ProjectCoreData) {
        let context = persistentContainer.viewContext
        context.delete(project)
        save()
    }
    
    func deleteCategory(category:CategoryCoreData) {
        let context = persistentContainer.viewContext
        context.delete(category)
        save()
    }
    
    func deleteTask(task:TaskCoreData) {
        let context = persistentContainer.viewContext
        context.delete(task)
        save()
    }
    
}
