import UIKit

final class LoginPresenter:ViewToPresenterLoginProtocol {
    var view: PresenterToViewLoginProtocol?
    var router: PresenterToRouterLoginProtocol?
    var interactor: PresenterToInteractorLoginProtocol?
    
    func touchSignInButton(navigationController: UINavigationController?) {
        router?.openSignInButton(navigationController: navigationController)
    }
    
    func touchRegisterButton(navigationController: UINavigationController?) {
        router?.openRegisterView(navigationController: navigationController)
    }
    
    func touchSkipButton(navigationController: UINavigationController?) {
        interactor?.setEnteredApplication()
        router?.openMainScreen(navigationController: navigationController)
    }
    
}




extension LoginPresenter:InteractorToPresenterLoginProtocol {
    
}
