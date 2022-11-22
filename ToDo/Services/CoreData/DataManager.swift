import Foundation
import CoreData


enum CoreManagerError:Error {
    case failedSaveContext(text:String)
    case failedFetchProjects(text:String)
    case failedFetchCategories(text:String)
    case failedFetchTasks(text:String)
    case failedDeleteProject(text:String)
    case failedDeleteCategory(text:String)
    case failedDeleteTask(text:String)
    case failedFetchCommonTasks(text:String)
    case failedDeleteCommonTask(text:String)
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
    
    func save() throws {
        let context = persistentContainer.viewContext
        
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nsError = error as NSError
                throw CoreManagerError.failedSaveContext(text: "Unresolver error \(nsError), \(nsError.userInfo)")
                //fatalError("Unresolver error \(nsError), \(nsError.userInfo)")
            }
        }
    }
    
    func project(name:String,hexColor:String,isFavorite:Bool) -> ProjectCoreData {
        let project = ProjectCoreData(context: persistentContainer.viewContext)
        project.name = name
        project.hexColor = hexColor
        project.isFavorite = isFavorite
        return project
    }
    
    func category(name:String,project:ProjectCoreData) -> CategoryCoreData {
        let category = CategoryCoreData(context: persistentContainer.viewContext)
        category.name = name
        project.addToCategories(category)
        return category
    }
    
    func task(name: String, description:String?, priority:Int64?, time:Date?,category:CategoryCoreData) -> TaskCoreData {
        let task = TaskCoreData(context: persistentContainer.viewContext)
        task.name = name
        task.descriptionTask = description
        task.priority = priority ?? 0
        task.time = time
        task.isFinished = false
        task.timeFinished = nil
        category.addToTasks(task)
        return task
    }
    
    func commonTask(name: String, description:String?, priority:Int64?, time:Date?,project:ProjectCoreData) -> CommonTaskCoreData {
        let commonTask = CommonTaskCoreData(context: persistentContainer.viewContext)
        commonTask.name = name
        commonTask.descriptionTask = description
        commonTask.priority = priority ?? 0
        commonTask.time = time
        commonTask.isFinished = false
        commonTask.timeFinished = nil
        project.addToCommonTasks(commonTask)
        return commonTask
    }
    
    func projects() throws -> [ProjectCoreData] {
        let request:NSFetchRequest<ProjectCoreData> = ProjectCoreData.fetchRequest()
        var fetchedProjects:[ProjectCoreData] = []
        
        do {
            fetchedProjects = try persistentContainer.viewContext.fetch(request)
        } catch let error {
            throw CoreManagerError.failedFetchProjects(text: "Error fetching projects \(error)")
        }
        return fetchedProjects
    }
    
    func commonTasks(project:ProjectCoreData) throws -> [CommonTaskCoreData] {
        let request:NSFetchRequest<CommonTaskCoreData> = CommonTaskCoreData.fetchRequest()
        request.predicate = NSPredicate(format: "project = %@", project)
        
        var fetchedCommonTasks:[CommonTaskCoreData] = []
        
        do {
            fetchedCommonTasks = try persistentContainer.viewContext.fetch(request)
        } catch let error {
            throw CoreManagerError.failedFetchCommonTasks(text: "Error fetching tasks \(error)")
        }
        return fetchedCommonTasks
    }
    
    func categories(project:ProjectCoreData) throws -> [CategoryCoreData] {
        let request:NSFetchRequest<CategoryCoreData> = CategoryCoreData.fetchRequest()
        request.predicate = NSPredicate(format: "project = %@", project)
        //request.sortDescriptors = [NSSortDescriptor(key: "releaseDate", ascending: false)]
        
        var fetchedCategories:[CategoryCoreData] = []
        
        do {
            fetchedCategories = try persistentContainer.viewContext.fetch(request)
        } catch let error {
            throw CoreManagerError.failedFetchCategories(text: "Error fetching categories \(error)")
        }
        return fetchedCategories
    }
    
    func tasks(category:CategoryCoreData) throws -> [TaskCoreData] {
        let request:NSFetchRequest<TaskCoreData> = TaskCoreData.fetchRequest()
        request.predicate = NSPredicate(format: "category = %@",category)
//        request.sortDescriptors = [NSSortDescriptor(key: "releaseDate", ascending: false)]
        
        var fetchedTasks:[TaskCoreData] = []
        
        do {
            fetchedTasks = try persistentContainer.viewContext.fetch(request)
        } catch let error {
            throw CoreManagerError.failedFetchTasks(text: "Error fetching tasks \(error)")
        }
        return fetchedTasks
    }
    
    func deleteProject(project:ProjectCoreData) throws {
        let context = persistentContainer.viewContext
        context.delete(project)
        do {
            try save()
        } catch let error {
            throw CoreManagerError.failedDeleteProject(text: "\(error)")
        }
    }
    
    func deleteCommonTask(commonTask:CommonTaskCoreData) throws {
        let context = persistentContainer.viewContext
        context.delete(commonTask)
        do {
            try save()
        } catch let error {
            throw CoreManagerError.failedDeleteCommonTask(text: "\(error)")
        }
    }
    
    func deleteCategory(category:CategoryCoreData) throws {
        let context = persistentContainer.viewContext
        context.delete(category)
        do {
            try save()
        } catch let error {
            throw CoreManagerError.failedDeleteCategory(text: "\(error)")
        }
    }
    
    func deleteTask(task:TaskCoreData) throws {
        let context = persistentContainer.viewContext
        context.delete(task)
        do {
            try save()
        } catch let error {
            throw CoreManagerError.failedDeleteTask(text: "\(error)")
        }
    }
    
    func loadCategory(with request:NSFetchRequest<CategoryCoreData> = CategoryCoreData.fetchRequest(),predicate:NSPredicate? = nil,categoryName:String) {
        
    }
}
