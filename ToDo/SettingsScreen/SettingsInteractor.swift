import UIKit

final class SettingsInteractor:PresenterToInteractorSettingsProtocol {
    var presenter: InteractorToPresenterSettingsProtocol?
    lazy var defaults = UserDefaults.standard
    
    func onSwitchTheme(isOn: Bool) {
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
