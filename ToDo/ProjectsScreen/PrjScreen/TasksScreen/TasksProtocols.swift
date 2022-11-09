import UIKit

//MARK: - View Input (View -> Presenter)
protocol ViewToPresenterTasksProtocol {
    var view: PresenterToViewTasksProtocol? {get set}
    var router: PresenterToRouterTasksProtocol? {get set}
    var interactor: PresenterToInteractorTasksProtocol? {get set}
}

//MARK: - View Output (Presenter -> View)
protocol PresenterToViewTasksProtocol {

}

//MARK: -  Interactor Input (Presenter -> Interactor)
protocol PresenterToInteractorTasksProtocol {
    var presenter:InteractorToPresenterTasksProtocol? {get set}

}

//MARK: - Interactor Output (Interactor -> Presenter)
protocol InteractorToPresenterTasksProtocol {

}

//MARK: - Router Input (Presenter -> Router)
protocol PresenterToRouterTasksProtocol {
    static func createModule(category:CategoryCoreData) -> TasksViewController

}
