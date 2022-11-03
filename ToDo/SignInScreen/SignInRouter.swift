import Foundation

final class SignInRouter:PresenterToRouterSignInProtocol {
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
