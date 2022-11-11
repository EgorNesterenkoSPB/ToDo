import Foundation
import UIKit

//MARK: - View Input (View -> Presenter)
protocol ViewToPresenterProjectsProtocol {
    var view: PresenterToViewProjectsProtocol? {get set}
    var router: PresenterToRouterProjectsProtocol? {get set}
    var interactor: PresenterToInteractorProjectsProtocol? {get set}
    func numberOfSections() -> Int
    func numberOfRowsInSection(section:Int) -> Int
    func cellForRowAt(tableView:UITableView, cellForRowAt indexPath:IndexPath) -> UITableViewCell
    func heightForHeaderInSection() -> CGFloat
    func heightForFooterInSection() -> CGFloat
    func viewForHeaderInSection(projectsViewController:ProjectsViewController,tableView: UITableView, section: Int) -> UIView?
    func getData() throws
    func showErrorAlert(errorText:String,projectsViewController:ProjectsViewController)
    func didSelectRowAt(tableView:UITableView,indexPath:IndexPath,projectsViewController:ProjectsViewController)
    func trailingSwipeActionsConfigurationForRowAt(tableView:UITableView,indexPath:IndexPath) -> UISwipeActionsConfiguration?
}

//MARK: - View Output (Presenter -> View)
protocol PresenterToViewProjectsProtocol {
    func updateTableView()
    func failedGetCoreData(errorText:String)
    func onfailedDeleteProject(errorText:String)
}

//MARK: -  Interactor Input (Presenter -> Interactor)
protocol PresenterToInteractorProjectsProtocol {
    var presenter:InteractorToPresenterProjectsProtocol? {get set}
    func deleteProject(project:ProjectCoreData)
}

//MARK: - Interactor Output (Interactor -> Presenter)
protocol InteractorToPresenterProjectsProtocol {
    func successfulyDeleteProject()
    func failedDeleteProject(errorText:String)
}

//MARK: - Router Input (Presenter -> Router)
protocol PresenterToRouterProjectsProtocol {
    static func createModule() -> ProjectsViewController
    func onShowErrorAlert(errorText:String,projectsViewController:ProjectsViewController)
    func showProjectScreen(projectsViewController:ProjectsViewController,project:ProjectCoreData)
}
