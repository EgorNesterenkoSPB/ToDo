import UIKit

final class SettingsRouter:PresenterToRouterSettingsProtocol {
    func showProfileScreen(navigationController: UINavigationController?) {
        let profileViewController = ProfileRouter.createModule()
        navigationController?.pushViewController(profileViewController, animated: true)
    }
    
    static func createModule() -> SettingsViewController {
        let settingsViewController = SettingsViewController()
        
        let settingsPresenter: (ViewToPresenterSettingsProtocol & InteractorToPresenterSettingsProtocol) = SettingsPresenter()
        
        settingsViewController.presenter = settingsPresenter
        settingsViewController.presenter?.view = settingsViewController
        settingsViewController.presenter?.interactor = SettingsInteractor()
        settingsViewController.presenter?.router = SettingsRouter()
        settingsViewController.presenter?.interactor?.presenter = settingsPresenter
        return settingsViewController
    }
}
