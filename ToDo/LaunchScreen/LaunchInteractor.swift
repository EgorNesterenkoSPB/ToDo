import Foundation
import UIKit

final class LaunchInteractor:PresenterToInteractorLaunchProtocol {
    var presenter: InteractorToPresenterLaunchProtocol?
    let defaults = UserDefaults.standard
    
    func viewDidLoad(navigationController:UINavigationController?) {
        let isEntered = defaults.bool(forKey: Resources.isEnteredApplication)
        switch isEntered {
        case true:
            let pincode = defaults.integer(forKey: Resources.pincodeKey)
            if pincode != 0 {
                self.presenter?.showPincodeViewController(navigationController: navigationController)
            }
            else {
                self.presenter?.showMainViewController(navigationController: navigationController)
            }
        case false:
            self.presenter?.showLoginViewController(navigationController: navigationController)
        }
    }
}
