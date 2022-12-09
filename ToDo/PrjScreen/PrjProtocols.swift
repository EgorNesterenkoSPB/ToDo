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
    func heightForHeaderInSection(section:Int) -> CGFloat
    func heightForFooterInSection() -> CGFloat
    func viewForHeaderInSection(prjViewController:PrjViewController,tableView: UITableView, section: Int) -> UIView?
    func updateSection(category:CategoryCoreData,section:Int)
    func didSelectRowAt(tableView:UITableView, indexPath:IndexPath,navigationController:UINavigationController?)
}

//MARK: - View Output (Presenter -> View)
protocol PresenterToViewPrjProtocol {
    func updateTableView()
    func reloadCommonTasksSection()
    func failedCoreData(errorText:String)
    func hideViewController()
    func onSuccessfulyDeleteCategory()
    func onSuccessefulyDeleteTask()
    func onUpdateSection(section:Int)
    func onSuccessfulyRenameProject()
    func showRenameCategoryAlert(alert:UIAlertController)
    func updateDataCommonTasks()
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
    func setFinishTask<T>(task:T,indexPath:IndexPath?,unfinished:Bool) where T:NSManagedObject
    func changeProjectColor(hexColor:String,project:ProjectCoreData)
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
    func successfulyFinishedCommonTask(project:ProjectCoreData?)
}

//MARK: - Router Input (Presenter -> Router)
protocol PresenterToRouterPrjProtocol {
    static func createModule(project:ProjectCoreData) -> PrjViewController
    func onShowCreateTaskViewController(projectName:String,projectID:NSManagedObjectID,prjViewController:PrjViewController)
    func showTaskScreen(task:NSManagedObject,taskContent:TaskContent,navigationController:UINavigationController?)
}
