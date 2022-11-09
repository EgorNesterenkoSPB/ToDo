import Foundation

final class PrjInteractor:PresenterToInteractorPrjProtocol {

    var presenter: InteractorToPresenterPrjProtocol?
    
    func createCategory(name:String,project: ProjectCoreData) {
        let newCategory = DataManager.shared.category(name: name, project: project)
        do {
            project.addToCategories(newCategory)
            try DataManager.shared.save()
            presenter?.successfulyCreateCategory(project: project)
        } catch let error {
            presenter?.failedCreateCategory(errorText: "\(error)")
        }
    }
    
    func deleteProject(project: ProjectCoreData) {
        do {
            try DataManager.shared.deleteProject(project: project)
            try DataManager.shared.save()
            presenter?.successfulyDeleteProject()
        } catch let error {
            presenter?.failedDeleteProject(errorText: "\(error)")
        }
    }
    
    func deleteAllCategories(project: ProjectCoreData) {
        do {
            project.setValue(nil, forKey: "categories")
            try DataManager.shared.save()
            presenter?.successfulyDeleteAllCategories(project:project)
        } catch let error {
            presenter?.failedDeleteAllCategories(errorText: "\(error)")
        }
    }
    
    func deleteCategory(category: CategoryCoreData) {
        do {
            try DataManager.shared.deleteCategory(category: category)
            presenter?.successfulyDeleteCategory()
        } catch let error {
            presenter?.failedDeleteCategory(errorText: "\(error)")
        }
    }
    
}
