import UIKit

//MARK: - View Input (View -> Presenter)
protocol ViewToPresenterCreateProjectProtocol {
    var view: PresenterToViewCreateProjectProtocol? {get set}
    var router: PresenterToRouterCreateProjectProtocol? {get set}
    var interactor: PresenterToInteractorCreateProjectProtocol? {get set}
    var projectName:String {get set}
    var headerCircleImageColor:UIColor {get set}
    func numberOfRowsInSection(sectionColorData:ColorSection) -> Int
    func cellForRowAt(tableView:UITableView,indexPath:IndexPath,sectionColorData:ColorSection) -> UITableViewCell
    func didSelectRowAt(tableView:UITableView,indexPath:IndexPath)
    func numberOfSections() -> Int
    func viewForHeaderInSection(createProjectViewController:CreateProjectViewController,sectionColorData:ColorSection) -> UIView?
    func textFieldDidEndEditing(textField:UITextField,confirmButton:UIButton)
}

//MARK: - View Output (Presenter -> View)
protocol PresenterToViewCreateProjectProtocol {

}

//MARK: -  Interactor Input (Presenter -> Interactor)
protocol PresenterToInteractorCreateProjectProtocol {
    var presenter:InteractorToPresenterCreateProjectProtocol? {get set}

}

//MARK: - Interactor Output (Interactor -> Presenter)
protocol InteractorToPresenterCreateProjectProtocol {

}

//MARK: - Router Input (Presenter -> Router)
protocol PresenterToRouterCreateProjectProtocol {
    static func createModule() -> CreateProjectViewController

}
