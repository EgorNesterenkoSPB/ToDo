import UIKit
import CoreData

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
    func didSelectRowAtCommonTask(tableView:UITableView, indexPath:IndexPath)
    func didSelectRowAtCategoryTask(tableView:UITableView, indexPath:IndexPath)
}

//MARK: - View Output (Presenter -> View)
protocol PresenterToViewPrjProtocol {
    func updateTableView()
    func reloadCommonTasksTableView()
    func failedCoreData(errorText:String)
    func hideViewController()
    func onSuccessfulyDeleteCategory()
    func onSuccessefulyDeleteTask()
    func onUpdateSection(section:Int)
    func onSuccessfulyRenameProject()
    func showRenameCategoryAlert(alert:UIAlertController)
    func updateDataCommonTasksTable()
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
    func setFinishTask<T>(task:T,indexPath:IndexPath?) where T:NSManagedObject
}

//MARK: - Interactor Output (Interactor -> Presenter)
protocol InteractorToPresenterPrjProtocol {
    func onfailedCoreData(errorText:String)
    func successfulyCreateCategory(project:ProjectCoreData)
    func successfulyDeleteProject()
    func successfulyDeleteAllCategories(project:ProjectCoreData)
    func successfulyDeleteCategory()
    func successfulyDeleteTask(category:CategoryCoreData,section:Int)
    func successfulyRenameProject()
    func successfulyRenamedCategory(section:Int,newName:String)
    func successfulyDeleteCommonTask()
    func successfulyFinishedCatagoryTask(category:CategoryCoreData?,section:Int)
    func successfultFinishedCommonTask(project:ProjectCoreData?)
}

//MARK: - Router Input (Presenter -> Router)
protocol PresenterToRouterPrjProtocol {
    static func createModule(project:ProjectCoreData) -> PrjViewController
    func onShowCreateCommonTaskViewController(project:ProjectCoreData,prjViewController:PrjViewController)
}
