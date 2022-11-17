import UIKit

//MARK: - View Input (View -> Presenter)
protocol ViewToPresenterCalendarProtocol {
    var view: PresenterToViewCalendarProtocol? {get set}
    var router: PresenterToRouterCalendarProtocol? {get set}
    var interactor: PresenterToInteractorCalendarProtocol? {get set}

}

//MARK: - View Output (Presenter -> View)
protocol PresenterToViewCalendarProtocol {

}

//MARK: -  Interactor Input (Presenter -> Interactor)
protocol PresenterToInteractorCalendarProtocol {
    var presenter:InteractorToPresenterCalendarProtocol? {get set}

}

//MARK: - Interactor Output (Interactor -> Presenter)
protocol InteractorToPresenterCalendarProtocol {

}

//MARK: - Router Input (Presenter -> Router)
protocol PresenterToRouterCalendarProtocol {
    static func createModule() -> CalendarViewController

}
