import UIKit

final class LoginRouter:PresenterToRouterLoginProtocol {
    func openMainScreen(navigationController: UINavigationController?) {
        let mainViewController = MainRouter.createModule()
        navigationController?.setViewControllers([mainViewController], animated: true)
    }
    
    func openSignInButton(navigationController: UINavigationController?) {
        let signInViewController = SignInRouter.createModule()
        navigationController?.pushViewController(signInViewController, animated: false)
    }
    
    
    static func createModule() -> LoginViewController {
        
        let loginViewController = LoginViewController()
        let loginPresenter: (ViewToPresenterLoginProtocol & InteractorToPresenterLoginProtocol) = LoginPresenter()
        loginViewController.presenter = loginPresenter
        loginViewController.presenter?.view = loginViewController
        loginViewController.presenter?.interactor = LoginInteractor()
        loginViewController.presenter?.router = LoginRouter()
        loginViewController.presenter?.interactor?.presenter = loginPresenter
        return loginViewController
    }
    
    func openRegisterView(navigationController: UINavigationController?) {
        let registerViewController = RegisterRouter.createModule()
        navigationController?.pushViewController(registerViewController, animated: false)
    }
}
