import UIKit

final class SettingsPresenter:ViewToPresenterSettingsProtocol {
    var view: PresenterToViewSettingsProtocol?
    var router: PresenterToRouterSettingsProtocol?
    var interactor: PresenterToInteractorSettingsProtocol?
    lazy var defaults = UserDefaults.standard
    
    func viewDidLoad(themeSwitcher: UISwitch) {
        let isDark = defaults.bool(forKey: Resources.isDarkKeyTheme)
        if isDark {
            themeSwitcher.isOn = true
        }
        else {
            themeSwitcher.isOn = false
        }
    }
    
    func switchTheme(isOn: Bool) {
        interactor?.onSwitchTheme(isOn: isOn)
    }
    
    func userTapProfileView(navigationController: UINavigationController?) {
        router?.showProfileScreen(navigationController: navigationController)
    }
    
}

extension SettingsPresenter:InteractorToPresenterSettingsProtocol {
    
}
