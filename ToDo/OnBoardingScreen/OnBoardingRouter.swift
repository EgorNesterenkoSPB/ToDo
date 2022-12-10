import UIKit

final class OnBoardingRouter:PresenterToRouterOnBoardingProtocol {
    func onShowLoginScreen(navigationController: UINavigationController?) {
        navigationController?.setViewControllers([LoginRouter.createModule()], animated: true)
    }
    
    static func createModule() -> OnBoardingViewController {
        let onBoardingViewController = OnBoardingViewController()
        
        let onBoardingPresenter: (ViewToPresenterOnBoardingProtocol & InteractorToPresenterOnBoardingProtocol) = OnBoardingPresenter()
        
        onBoardingViewController.presenter = onBoardingPresenter
        onBoardingViewController.presenter?.view = onBoardingViewController
        onBoardingViewController.presenter?.interactor = OnBoardingInteractor()
        onBoardingViewController.presenter?.router = OnBoardingRouter()
        onBoardingViewController.presenter?.interactor?.presenter = onBoardingPresenter
        return onBoardingViewController
    }
    
    
}
