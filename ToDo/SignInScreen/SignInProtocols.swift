import Foundation
import UIKit

//MARK: - View Input (View -> Presenter)
protocol ViewToPresenterSignInProtocol {
    var view: PresenterToViewSignInProtocol? {get set}
    var router: PresenterToRouterSignInProtocol? {get set}
    var interactor: PresenterToInteractorSignInProtocol? {get set}
}

//MARK: - View Output (Presenter -> View)
protocol PresenterToViewSignInProtocol {

}

//MARK: -  Interactor Input (Presenter -> Interactor)
protocol PresenterToInteractorSignInProtocol {
    var presenter:InteractorToPresenterSignInProtocol? {get set}

}

//MARK: - Interactor Output (Interactor -> Presenter)
protocol InteractorToPresenterSignInProtocol {

}

//MARK: - Router Input (Presenter -> Router)
protocol PresenterToRouterSignInProtocol {
    static func createModule() -> SignInViewController
}
