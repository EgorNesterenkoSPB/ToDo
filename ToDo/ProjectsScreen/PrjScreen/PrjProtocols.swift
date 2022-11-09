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
}

//MARK: - View Output (Presenter -> View)
protocol PresenterToViewPrjProtocol {
    func updateTableView()
    func failedGetCoreData(errorText:String)
    func onFailedCreateCategory(errorText:String)
}

//MARK: -  Interactor Input (Presenter -> Interactor)
protocol PresenterToInteractorPrjProtocol {
    var presenter:InteractorToPresenterPrjProtocol? {get set}
    func createCategory(name:String,project:ProjectCoreData)
}

//MARK: - Interactor Output (Interactor -> Presenter)
protocol InteractorToPresenterPrjProtocol {
    func failedCreateCategory(errorText:String)
    func successfultCreateCategory(project:ProjectCoreData)
}

//MARK: - Router Input (Presenter -> Router)
protocol PresenterToRouterPrjProtocol {
    static func createModule(project:ProjectCoreData) -> PrjViewController

}
