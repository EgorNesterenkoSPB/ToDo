final class ProfileRouter: PresenterToRouterProfileProtocol {
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
