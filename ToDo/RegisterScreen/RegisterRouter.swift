import UIKit

final class RegisterRouter:PresenterToRouterRegisterProtocol {
    static func createModule() -> RegisterViewController {
        let registerViewController = RegisterViewController()
        
        let registerPresenter: (ViewToPresenterRegisterProtocol & InteractorToPresenterRegisterProtocol) = RegisterPresenter(registerViewController: registerViewController)
        
        registerViewController.presenter = registerPresenter
        registerViewController.presenter?.view = registerViewController
        registerViewController.presenter?.interactor = RegisterIneractor()
        registerViewController.presenter?.router = RegisterRouter()
        registerViewController.presenter?.interactor?.presenter = registerPresenter
        return registerViewController
    }
    
    func showSignInScreen(registerViewController: RegisterViewController) {
        guard var viewControllers = registerViewController.navigationController?.viewControllers else {return}
        _ = viewControllers.popLast()
        let signInViewController = SignInRouter.createModule()
        viewControllers.append(signInViewController)
        registerViewController.navigationController?.setViewControllers(viewControllers, animated: true)
    }
    
}
