import UIKit

final class CalendarRouter:PresenterToRouterCalendarProtocol {
    static func createModule() -> CalendarViewController {
        let calendarViewController = CalendarViewController()
        
        let calendarPresenter: (ViewToPresenterCalendarProtocol & InteractorToPresenterCalendarProtocol) = CalendarPresenter()
        
        calendarViewController.presenter = calendarPresenter
        calendarViewController.presenter?.view = calendarViewController
        calendarViewController.presenter?.interactor = CalendarInteractor()
        calendarViewController.presenter?.router = CalendarRouter()
        calendarViewController.presenter?.interactor?.presenter = calendarPresenter
        return calendarViewController
    }
    
    
}
