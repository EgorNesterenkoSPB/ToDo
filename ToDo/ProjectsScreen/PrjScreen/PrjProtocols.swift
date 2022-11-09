import UIKit

//MARK: - View Input (View -> Presenter)
protocol ViewToPresenterPrjProtocol {
    var view: PresenterToViewPrjProtocol? {get set}
    var router: PresenterToRouterPrjProtocol? {get set}
    var interactor: PresenterToInteractorPrjProtocol? {get set}
    func getCategories(project:ProjectCoreData)
    func showCreateCategoryAlert(project:ProjectCoreData) -> UIAlertController
    func numberOfRowsInSection() -> Int
    func cellForRowAt(tableView:UITableView,indexPath:IndexPath) -> UITableViewCell
    func showEditAlert(project:ProjectCoreData) -> UIAlertController
    func trailingSwipeActionsConfigurationForRowAt(tableView:UITableView,indexPath:IndexPath) -> UISwipeActionsConfiguration?
}

//MARK: - View Output (Presenter -> View)
protocol PresenterToViewPrjProtocol {
    func updateTableView()
    func failedGetCoreData(errorText:String)
    func onFailedCreateCategory(errorText:String)
    func onFailedDeleteProject(errorText:String)
    func onFailedDeleteAllCategories(errorText:String)
    func hideViewController()
    func onSuccessfulyDeleteCategory()
    func onFailedDeleteCategory(errorText:String)
}

//MARK: -  Interactor Input (Presenter -> Interactor)
protocol PresenterToInteractorPrjProtocol {
    var presenter:InteractorToPresenterPrjProtocol? {get set}
    func createCategory(name:String,project:ProjectCoreData)
    func deleteProject(project:ProjectCoreData)
    func deleteAllCategories(project:ProjectCoreData)
    func deleteCategory(category:CategoryCoreData)
}

//MARK: - Interactor Output (Interactor -> Presenter)
protocol InteractorToPresenterPrjProtocol {
    func failedCreateCategory(errorText:String)
    func successfulyCreateCategory(project:ProjectCoreData)
    func failedDeleteProject(errorText:String)
    func failedDeleteAllCategories(errorText:String)
    func successfulyDeleteProject()
    func successfulyDeleteAllCategories(project:ProjectCoreData)
    func successfulyDeleteCategory()
    func failedDeleteCategory(errorText:String)
}

//MARK: - Router Input (Presenter -> Router)
protocol PresenterToRouterPrjProtocol {
    static func createModule(project:ProjectCoreData) -> PrjViewController

}
