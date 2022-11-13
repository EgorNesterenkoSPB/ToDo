import UIKit

final class SettingsRouter:PresenterToRouterSettingsProtocol {
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
