import MessageUI
import UIKit

//MARK: - View Input (View -> Presenter)
protocol ViewToPresenterSettingsProtocol {
    var view: PresenterToViewSettingsProtocol? {get set}
    var router: PresenterToRouterSettingsProtocol? {get set}
    var interactor: PresenterToInteractorSettingsProtocol? {get set}
    func switchTheme(isOn:Bool)
    func viewDidLoad(themeSwitcher:UISwitch)
    func cellForRowAt(tableView:UITableView,indexPath:IndexPath) -> UITableViewCell
    func didSelectRowAt(indexPath:IndexPath,settingsViewController:SettingsViewController)
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?)
}

//MARK: - View Output (Presenter -> View)
protocol PresenterToViewSettingsProtocol {
    
}

//MARK: -  Interactor Input (Presenter -> Interactor)
protocol PresenterToInteractorSettingsProtocol {
    var presenter:InteractorToPresenterSettingsProtocol? {get set}
    func onSwitchTheme(isOn:Bool)
}

//MARK: - Interactor Output (Interactor -> Presenter)
protocol InteractorToPresenterSettingsProtocol {

}

//MARK: - Router Input (Presenter -> Router)
protocol PresenterToRouterSettingsProtocol {
    static func createModule() -> SettingsViewController
    func showProfileScreen(navigationController:UINavigationController?)
}
