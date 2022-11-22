import UIKit
import Foundation
import CoreData

final class PrjInteractor:PresenterToInteractorPrjProtocol {

    var presenter: InteractorToPresenterPrjProtocol?
    
    func changeProjectColor(hexColor: String, project: ProjectCoreData) {
        project.setValue(hexColor, forKey: Resources.hexColorProjectKey)
        do {
            try DataManager.shared.save()
        } catch let error {
            presenter?.onfailedCoreData(errorText: "\(error)")
        }
    }
    
    
        
    func setFinishTask<T>(task:T,indexPath:IndexPath? = nil,unfinished:Bool) where T:NSManagedObject {
        
        task.setValue(unfinished ? false : true, forKey: Resources.isFinishedTaskKey)
        let currentDate = Date()
        task.setValue(unfinished ? nil : currentDate, forKey: Resources.timeFinishedTaskKey)
        do {
            try DataManager.shared.save()
            switch task {
            case is TaskCoreData:
                guard let task = task as? TaskCoreData else {return}
                guard let section = indexPath?.section else {return}
                presenter?.successfulyFinishedCatagoryTask(category: task.category, section: section)
            case is CommonTaskCoreData:
                guard let task = task as? CommonTaskCoreData else {return}
                presenter?.successfulyFinishedCommonTask(project: task.project)
            default:
                break
            }
        } catch let error {
            presenter?.onfailedCoreData(errorText: error.localizedDescription)
        }
    }
    
    func onRenameCategory(category: CategoryCoreData,sectionsData:[CategorySection],newName:String) {
        category.setValue(newName, forKey: Resources.categoryNameKey)
        do {
            try DataManager.shared.save()
            if let section = sectionsData.firstIndex(where: {$0.objectID == category.objectID}) {
                presenter?.successfulyRenamedCategory(section: section,newName: newName)
            }
        } catch let error {
            presenter?.onfailedCoreData(errorText: error.localizedDescription)
        }
    }
    
    func renameProject(project: ProjectCoreData,newName:String) {
        project.setValue(newName, forKey: Resources.projectNameKey)
        do {
            try DataManager.shared.save()
            presenter?.successfulyRenameProject()
        } catch let error {
            presenter?.onfailedCoreData(errorText: error.localizedDescription)
        }
    }
    
    func createCategory(name:String,project: ProjectCoreData) {
        let newCategory = DataManager.shared.category(name: name, project: project)
        do {
            var categories = try DataManager.shared.categories(project: project)
            categories.append(newCategory)
            try DataManager.shared.save()
            presenter?.successfulyCreateCategory(project: project)
        } catch let error {
            presenter?.onfailedCoreData(errorText: error.localizedDescription)
        }
    }
    
    func deleteTask(task: TaskCoreData,category:CategoryCoreData,section:Int) {
        do {
            try DataManager.shared.deleteTask(task: task)
            presenter?.successfulyDeleteTask(category: category, section: section)
        } catch let error {
            presenter?.onfailedCoreData(errorText: error.localizedDescription)
        }
    }
    
    func deleteCommonTask(commonTask: CommonTaskCoreData) {
        do {
            try DataManager.shared.deleteCommonTask(commonTask: commonTask)
            presenter?.successfulyDeleteCommonTask()
        } catch let error {
            presenter?.onfailedCoreData(errorText: error.localizedDescription)
        }
    }
    
    
    func deleteProject(project: ProjectCoreData) {
        do {
            try DataManager.shared.deleteProject(project: project)
            try DataManager.shared.save()
            presenter?.successfulyDeleteProject()
        } catch let error {
            presenter?.onfailedCoreData(errorText: error.localizedDescription)
        }
    }
    
    func deleteAllCategories(project: ProjectCoreData) {
        do {
            project.setValue(nil, forKey: Resources.categoriesKeyCoreData)
            try DataManager.shared.save()
            presenter?.successfulyDeleteAllCategories(project:project)
        } catch let error {
            presenter?.onfailedCoreData(errorText: error.localizedDescription)
        }
    }
    
    func deleteCategory(category: CategoryCoreData) {
        do {
            try DataManager.shared.deleteCategory(category: category)
            presenter?.successfulyDeleteCategory()
        } catch let error {
            presenter?.onfailedCoreData(errorText: error.localizedDescription)
        }
    }
    
}
