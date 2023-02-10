import CoreData

final class CalendarRouter:PresenterToRouterCalendarProtocol {
    func showTaskScreen(task: NSManagedObject, taskContent: TaskContent, calendarViewController: CalendarViewController) {
        let taskViewController = TaskRouter.createModule(task: task, taskContent: taskContent)
        taskViewController.delegate = calendarViewController
        calendarViewController.navigationController?.pushViewController(taskViewController, animated: true)
    }
    
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
