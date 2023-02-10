import UIKit

final class SignInRouter:PresenterToRouterSignInProtocol {
    func openMainScreen(navigationController: UINavigationController?,token: Token) {
        let mainViewController = MainRouter.createModule(token: token)
        navigationController?.setViewControllers([mainViewController], animated: true)
    }
    
    static func createModule() -> SignInViewController {
        let signInViewController = SignInViewController()
        
        let signInPresenter: (ViewToPresenterSignInProtocol & InteractorToPresenterSignInProtocol) = SignInPresenter()
        
        signInViewController.presenter = signInPresenter
        signInViewController.presenter?.view = signInViewController
        signInViewController.presenter?.interactor = SignInInteractor()
        signInViewController.presenter?.router = SignInRouter()
        signInViewController.presenter?.interactor?.presenter = signInPresenter
        return signInViewController
    }
}
