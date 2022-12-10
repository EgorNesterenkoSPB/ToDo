import UIKit

//MARK: - View Input (View -> Presenter)
protocol ViewToPresenterLaunchProtocol {
    var view: PresenterToViewLaunchProtocol? {get set}
    var router: PresenterToRouterLaunchProtocol? {get set}
    var interactor: PresenterToInteractorLaunchProtocol? {get set}
    func configureShadow(label:UILabel,shadowView:UIView,navigationController:UINavigationController?)

}

//MARK: - View Output (Presenter -> View)
protocol PresenterToViewLaunchProtocol {
    
}

//MARK: -  Interactor Input (Presenter -> Interactor)
protocol PresenterToInteractorLaunchProtocol {
    var presenter:InteractorToPresenterLaunchProtocol? {get set}
    func viewDidLoad(navigationController:UINavigationController?)
}

//MARK: - Interactor Output (Interactor -> Presenter)
protocol InteractorToPresenterLaunchProtocol {
    func showPincodeViewController(navigationController:UINavigationController?)
    func showLoginViewController(navigationController:UINavigationController?)
    func showMainViewController(navigationController:UINavigationController?)
    func showOnBoardingViewController(navigationController:UINavigationController?)
}

//MARK: - Router Input (Presenter -> Router)
protocol PresenterToRouterLaunchProtocol {
    static func createModule() -> LaunchViewController
    func onShowPincodeViewController(navigationController:UINavigationController?)
    func onShowLoginViewController(navigationController:UINavigationController?)
    func onShowMainViewController(navigationController:UINavigationController?)
    func onShowOnBoardingViewConroller(navigationController:UINavigationController?)
}
