import UIKit

//MARK: - View Input (View -> Presenter)
protocol ViewToPresenterOnBoardingProtocol {
    var view: PresenterToViewOnBoardingProtocol? {get set}
    var router: PresenterToRouterOnBoardingProtocol? {get set}
    var interactor: PresenterToInteractorOnBoardingProtocol? {get set}
    func showLoginScreen(navigationController:UINavigationController?)
    func showNewViewData(currentPage:Int)
}

//MARK: - View Output (Presenter -> View)
protocol PresenterToViewOnBoardingProtocol {
    func setNewViewData(mainText:String,secondText:String,imageName:String,currentPage:Int)
}

//MARK: -  Interactor Input (Presenter -> Interactor)
protocol PresenterToInteractorOnBoardingProtocol {
    var presenter:InteractorToPresenterOnBoardingProtocol? {get set}
    func setIsOnBoarding(navigationController: UINavigationController?)
    func onShowNewViewData(currentPage:Int)
}

//MARK: - Interactor Output (Interactor -> Presenter)
protocol InteractorToPresenterOnBoardingProtocol {
    func successfulySettedIsOnBoarding(navigationController:UINavigationController?)
    func newViewData(mainText:String,secondText:String,imageName:String,currentPage:Int)
}

//MARK: - Router Input (Presenter -> Router)
protocol PresenterToRouterOnBoardingProtocol {
    static func createModule() -> OnBoardingViewController
    func onShowLoginScreen(navigationController:UINavigationController?)
}
