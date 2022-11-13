import Foundation
import UIKit

//MARK: - View Input (View -> Presenter)
protocol ViewToPresenterSettingsProtocol {
    var view: PresenterToViewSettingsProtocol? {get set}
    var router: PresenterToRouterSettingsProtocol? {get set}
    var interactor: PresenterToInteractorSettingsProtocol? {get set}
    func switchTheme(isOn:Bool)
    func viewDidLoad(themeSwitcher:UISwitch)
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

}
