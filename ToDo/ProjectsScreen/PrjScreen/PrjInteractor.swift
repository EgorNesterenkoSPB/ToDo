import Foundation

final class PrjInteractor:PresenterToInteractorPrjProtocol {
    var presenter: InteractorToPresenterPrjProtocol?
    
    func createCategory(name:String,project: ProjectCoreData) {
        let newCategory = DataManager.shared.category(name: name, project: project)
        do {
            project.addToCategories(newCategory)
            try DataManager.shared.save()
            presenter?.successfultCreateCategory(project: project)
        } catch let error {
            presenter?.failedCreateCategory(errorText: "\(error)")
        }
    }
    
}
