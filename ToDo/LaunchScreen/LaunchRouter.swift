import UIKit

final class LaunchRouter:PresenterToRouterLaunchProtocol {
    func onShowOnBoardingViewConroller(navigationController: UINavigationController?) {
        navigationController?.setViewControllers([OnBoardingRouter.createModule()], animated: false)
    }
    
    func onShowPincodeViewController(navigationController: UINavigationController?) {
        navigationController?.setViewControllers([PincodeViewController()], animated: false)
    }
    
    func onShowLoginViewController(navigationController: UINavigationController?) {
        navigationController?.setViewControllers([LoginRouter.createModule()], animated: false)
    }
    
    func onShowMainViewController(navigationController: UINavigationController?) {
        navigationController?.setViewControllers([MainRouter.createModule(token: nil)], animated: false)
    }
    
    static func createModule() -> LaunchViewController {
        let launchViewController = LaunchViewController()
        
        let launchPresenter: (ViewToPresenterLaunchProtocol & InteractorToPresenterLaunchProtocol) = LaunchPresenter()
        
        launchViewController.presenter = launchPresenter
        launchViewController.presenter?.view = launchViewController
        launchViewController.presenter?.interactor = LaunchInteractor()
        launchViewController.presenter?.router = LaunchRouter()
        launchViewController.presenter?.interactor?.presenter = launchPresenter
        return launchViewController
    }
    
    
}
