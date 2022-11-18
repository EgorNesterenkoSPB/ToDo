import UIKit

//MARK: - View Input (View -> Presenter)
protocol ViewToPresenterPrjProtocol {
    var view: PresenterToViewPrjProtocol? {get set}
    var router: PresenterToRouterPrjProtocol? {get set}
    var interactor: PresenterToInteractorPrjProtocol? {get set}
    func getCategories(project:ProjectCoreData)
    func getCommonTasks(project:ProjectCoreData)
    func showCreateCommonTaskScreen(project: ProjectCoreData,prjViewController:PrjViewController)
    func numberOfRowsInSection(section:Int) -> Int
    func numberOfSections() -> Int
    func cellForRowAt(tableView:UITableView,indexPath:IndexPath) -> UITableViewCell
    func showEditAlert(project:ProjectCoreData,prjViewController:PrjViewController)
    func trailingSwipeActionsConfigurationForRowAt(tableView:UITableView,indexPath:IndexPath) -> UISwipeActionsConfiguration?
    func heightForHeaderInSection() -> CGFloat
    func heightForFooterInSection() -> CGFloat
    func viewForHeaderInSection(prjViewController:PrjViewController,tableView: UITableView, section: Int) -> UIView?
    func updateSection(category:CategoryCoreData,section:Int)
    func numberOfRowsInCommonTasksTable() -> Int
    func cellForRowAtCommonTasksTable(tableView:UITableView,indexPath:IndexPath) -> UITableViewCell
    func trailingSwipeActionsConfigurationForRowAtCommonTasksTable(tableView:UITableView,indexPath:IndexPath) -> UISwipeActionsConfiguration?
}

//MARK: - View Output (Presenter -> View)
protocol PresenterToViewPrjProtocol {
    func updateTableView()
    func onUpdateCommonTasksTableView()
    func failedGetCoreData(errorText:String)
    func onFailedCreateCategory(errorText:String)
    func onFailedDeleteProject(errorText:String)
    func onFailedDeleteAllCategories(errorText:String)
    func hideViewController()
    func onSuccessfulyDeleteCategory()
    func onFailedDeleteCategory(errorText:String)
    func onFailedDeleteTask(errorText:String)
    func onSuccessefulyDeleteTask()
    func onUpdateSection(section:Int)
    func onFailedRenameProject(errorText:String)
    func onSuccessfulyRenameProject()
    func onFailedRenameCategory(errorText:String)
    func showRenameCategoryAlert(alert:UIAlertController)
    func onFailedDeleteCommonTask(errorText:String)
    func updateCommonTasksTable()
}

//MARK: -  Interactor Input (Presenter -> Interactor)
protocol PresenterToInteractorPrjProtocol {
    var presenter:InteractorToPresenterPrjProtocol? {get set}
    func createCategory(name:String,project:ProjectCoreData)
    func deleteProject(project:ProjectCoreData)
    func deleteAllCategories(project:ProjectCoreData)
    func deleteCategory(category:CategoryCoreData)
    func deleteTask(task:TaskCoreData,category:CategoryCoreData,section:Int)
    func renameProject(project:ProjectCoreData,newName:String)
    func onRenameCategory(category:CategoryCoreData,sectionsData:[CategorySection],newName:String)
    func deleteCommonTask(commonTask:CommonTaskCoreData)
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
    func failedDeleteTask(errorText:String)
    func successfulyDeleteTask(category:CategoryCoreData,section:Int)
    func failedRenameProject(errorText:String)
    func successfulyRenameProject()
    func failedRenameCategory(errorText:String)
    func successfulyRenamedCategory(section:Int,newName:String)
    func failedDeleteCommonTask(errorText:String)
    func successfulyDeleteCommonTask()
}

//MARK: - Router Input (Presenter -> Router)
protocol PresenterToRouterPrjProtocol {
    static func createModule(project:ProjectCoreData) -> PrjViewController
    func onShowCreateCommonTaskViewController(project:ProjectCoreData,prjViewController:PrjViewController)
}
