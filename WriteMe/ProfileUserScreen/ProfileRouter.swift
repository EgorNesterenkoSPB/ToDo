import UIKit

final class ProfileRouter: PresenterToRouterProfileProtocol {
    func onLogout(navigationController: UINavigationController?) {
        let loginViewController = LoginRouter.createModule()
        navigationController?.setViewControllers([loginViewController], animated: true)
    }
    
    static func createModule() -> ProfileViewController {
        let profileViewController = ProfileViewController()
        
        let profilePresenter: (ViewToPresenterProfileProtocol & InteractorToPresenterProfileProtocol) = ProfilePresenter()
        
        profileViewController.presenter = profilePresenter
        profileViewController.presenter?.view = profileViewController
        profileViewController.presenter?.interactor = ProfileInteractor()
        profileViewController.presenter?.router = ProfileRouter()
        profileViewController.presenter?.interactor?.presenter = profilePresenter
        return profileViewController
    }
    
    
}
