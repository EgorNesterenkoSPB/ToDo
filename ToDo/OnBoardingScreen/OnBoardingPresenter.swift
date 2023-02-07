import UIKit

final class OnBoardingPresenter:ViewToPresenterOnBoardingProtocol {
    var view: PresenterToViewOnBoardingProtocol?
    var router: PresenterToRouterOnBoardingProtocol?
    var interactor: PresenterToInteractorOnBoardingProtocol?
    
    func showNewViewData(currentPage: Int) {
        self.interactor?.onShowNewViewData(currentPage: currentPage)
    }
    
    func showLoginScreen(navigationController: UINavigationController?) {
        interactor?.setIsOnBoarding(navigationController: navigationController)
    }
    
    func showMainScreen(navigationController: UINavigationController?) {
        self.router?.onShowMainScreen(navigationController: navigationController)
    }
    
}

extension OnBoardingPresenter:InteractorToPresenterOnBoardingProtocol {
    func newViewData(mainText: String, secondText: String, imageName: String,currentPage:Int) {
        self.view?.setNewViewData(mainText: mainText, secondText: secondText, imageName: imageName,currentPage: currentPage)
    }
    
    func successfulySettedIsOnBoarding(navigationController: UINavigationController?) {
        router?.onShowLoginScreen(navigationController: navigationController)
    }
}
