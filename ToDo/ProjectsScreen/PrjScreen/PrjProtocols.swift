import UIKit

//MARK: - View Input (View -> Presenter)
protocol ViewToPresenterPrjProtocol {
    var view: PresenterToViewPrjProtocol? {get set}
    var router: PresenterToRouterPrjProtocol? {get set}
    var interactor: PresenterToInteractorPrjProtocol? {get set}
}

//MARK: - View Output (Presenter -> View)
protocol PresenterToViewPrjProtocol {

}

//MARK: -  Interactor Input (Presenter -> Interactor)
protocol PresenterToInteractorPrjProtocol {
    var presenter:InteractorToPresenterPrjProtocol? {get set}

}

//MARK: - Interactor Output (Interactor -> Presenter)
protocol InteractorToPresenterPrjProtocol {

}

//MARK: - Router Input (Presenter -> Router)
protocol PresenterToRouterPrjProtocol {
    static func createModule(project:ProjectCoreData) -> PrjViewController

}
