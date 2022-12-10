import Foundation
import UIKit
import CoreData

//MARK: - View Input (View -> Presenter)
protocol ViewToPresenterMainProtocol {
    var view: PresenterToViewMainProtocol? {get set}
    var router: PresenterToRouterMainProtocol? {get set}
    var interactor: PresenterToInteractorMainProtocol? {get set}
    func numberOfSections() -> Int
    func numberOfRowsInSection(section:Int) -> Int
    func cellForRowAt(tableView:UITableView, cellForRowAt indexPath:IndexPath) -> UITableViewCell
    func heightForHeaderInSection() -> CGFloat
    func heightForFooterInSection() -> CGFloat
    func userTapCreateTask(mainViewController:MainViewController)
    func viewForHeaderInSection(tableView: UITableView, section: Int) -> UIView?
    func userTapProjectsButton(navigationController:UINavigationController?)
    func userTapSettingsButton(navigationController:UINavigationController?)
    func getData()
    func didSelectRowAt(tableView:UITableView, indexPath:IndexPath,mainViewController:MainViewController)
    func trailingSwipeActionsConfigurationForRowAt(tableView: UITableView, indexPath: IndexPath,mainViewController:MainViewController) -> UISwipeActionsConfiguration?
    func creatyIncomingProject()
}

//MARK: - View Output (Presenter -> View)
protocol PresenterToViewMainProtocol {
    func updateTableView()
    func errorGetCoreData(errorText:String)
}

//MARK: -  Interactor Input (Presenter -> Interactor)
protocol PresenterToInteractorMainProtocol {
    var presenter:InteractorToPresenterMainProtocol? {get set}
    func setFinishTask(task:NSManagedObject)
    func deleteTask<T>(task:T) where T:NSManagedObject
    func createTask(projectID:NSManagedObjectID)
    func onCreateIncomingProject()
}

//MARK: - Interactor Output (Interactor -> Presenter)
protocol InteractorToPresenterMainProtocol {
    func successfulyFinishedTask()
    func failureFinishedTask(errorText:String)
    func successfulyDeleteTask()
    func failureDeleteTask(errorText:String)
    func successfulyCreateTask()
    func failureCreateTask(errorText:String)
    func failureCreateIncomingProject(errorText:String)
}

//MARK: - Router Input (Presenter -> Router)
protocol PresenterToRouterMainProtocol {
    static func createModule(token:Token?) -> MainViewController
    func showProjectsScreen(navigationController:UINavigationController?)
    func showCreateTaskViewController(mainViewController: MainViewController)
    func showSettingsScreen(navigationController:UINavigationController?)
    func showTaskScreen(task:NSManagedObject,taskContent:TaskContent,mainViewController:MainViewController)
}
