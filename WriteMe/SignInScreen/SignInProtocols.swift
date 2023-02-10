import Foundation
import UIKit

//MARK: - View Input (View -> Presenter)
protocol ViewToPresenterSignInProtocol {
    var view: PresenterToViewSignInProtocol? {get set}
    var router: PresenterToRouterSignInProtocol? {get set}
    var interactor: PresenterToInteractorSignInProtocol? {get set}
    func setLogin(login:String?)
    func setPassword(password:String?)
    func checkFields()
    func userTapConfirmButton(navigationController: UINavigationController?)
    func userTapQuestionButton(questionButton:UIButton,signinViewController:SignInViewController,presentedViewController:UIViewController?)
}

//MARK: - View Output (Presenter -> View)
protocol PresenterToViewSignInProtocol {
    func unableConfirmButton()
    func disableConfirmButton()
    func onFailedLogin(errorText:String)
}

//MARK: -  Interactor Input (Presenter -> Interactor)
protocol PresenterToInteractorSignInProtocol {
    var presenter:InteractorToPresenterSignInProtocol? {get set}
    func loginUser(authBody:AuthBody,navigationController: UINavigationController?)
}

//MARK: - Interactor Output (Interactor -> Presenter)
protocol InteractorToPresenterSignInProtocol {
    func succussfulyLogin(token:Token,navigationController: UINavigationController?)
    func failedLogin(errorText:String)
}

//MARK: - Router Input (Presenter -> Router)
protocol PresenterToRouterSignInProtocol {
    static func createModule() -> SignInViewController
    func openMainScreen(navigationController: UINavigationController?,token:Token)
}
