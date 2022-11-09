import UIKit

//MARK: - View Input (View -> Presenter)
protocol ViewToPresenterProfileProtocol {
    var view: PresenterToViewProfileProtocol? {get set}
    var router: PresenterToRouterProfileProtocol? {get set}
    var interactor: PresenterToInteractorProfileProtocol? {get set}
}

//MARK: - View Output (Presenter -> View)
protocol PresenterToViewProfileProtocol {

}

//MARK: -  Interactor Input (Presenter -> Interactor)
protocol PresenterToInteractorProfileProtocol {
    var presenter:InteractorToPresenterProfileProtocol? {get set}

}

//MARK: - Interactor Output (Interactor -> Presenter)
protocol InteractorToPresenterProfileProtocol {

}

//MARK: - Router Input (Presenter -> Router)
protocol PresenterToRouterProfileProtocol {
    static func createModule() -> ProfileViewController

}
