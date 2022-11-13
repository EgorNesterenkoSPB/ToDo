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
        
        if isOn {
            UIApplication.shared.windows.forEach({window in
                window.overrideUserInterfaceStyle = .dark
                defaults.set(true, forKey: Resources.isDarkKeyTheme)
            })
        }
        else {
            UIApplication.shared.windows.forEach({window in
                window.overrideUserInterfaceStyle = .light
                defaults.set(false, forKey: Resources.isDarkKeyTheme)
            })
        }

    }
    
}

extension SettingsPresenter:InteractorToPresenterSettingsProtocol {
    
}
