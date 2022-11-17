import UIKit

final class CalendarPresenter:ViewToPresenterCalendarProtocol {
    var view: PresenterToViewCalendarProtocol?
        var router: PresenterToRouterCalendarProtocol?
    var interactor: PresenterToInteractorCalendarProtocol?
    
    
}

extension CalendarPresenter: InteractorToPresenterCalendarProtocol {
    
    
}
