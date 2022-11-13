import UIKit

final class LoginInteractor:PresenterToInteractorLoginProtocol {
    var presenter: InteractorToPresenterLoginProtocol?
    
    func setEnteredApplication() {
        let defaults = UserDefaults.standard
        defaults.set(true, forKey: Resources.isEnteredApplication)
    }
    
}
