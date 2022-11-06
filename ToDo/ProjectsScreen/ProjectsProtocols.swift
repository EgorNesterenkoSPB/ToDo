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
}

//MARK: - View Output (Presenter -> View)
protocol PresenterToViewProjectsProtocol {
    func updateTableView()
}

//MARK: -  Interactor Input (Presenter -> Interactor)
protocol PresenterToInteractorProjectsProtocol {
    var presenter:InteractorToPresenterProjectsProtocol? {get set}

}

//MARK: - Interactor Output (Interactor -> Presenter)
protocol InteractorToPresenterProjectsProtocol {

}

//MARK: - Router Input (Presenter -> Router)
protocol PresenterToRouterProjectsProtocol {
    static func createModule() -> ProjectsViewController
}
