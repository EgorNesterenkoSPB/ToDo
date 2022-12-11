import UIKit
import FSCalendar
import CoreData

//MARK: - View Input (View -> Presenter)
protocol ViewToPresenterCalendarProtocol {
    var view: PresenterToViewCalendarProtocol? {get set}
    var router: PresenterToRouterCalendarProtocol? {get set}
    var interactor: PresenterToInteractorCalendarProtocol? {get set}
    func editeCalendarHeight(calendar:FSCalendar,showHideButton:UIButton)
    func numberOfSections() -> Int
    func numberOfRowsInSection(section: Int) -> Int
    func cellForRowAt(tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    func didSelectRowAt(tableView: UITableView, indexPath: IndexPath, calendarViewController:CalendarViewController)
    func trailingSwipeActionsConfigurationForRowAt(tableView: UITableView, indexPath: IndexPath, calendarViewController: CalendarViewController) -> UISwipeActionsConfiguration?
    func updateTasksDay(date:Date)
    func numberOfEvents(date:Date) -> Int
    func getTasks(date:Date)
}

//MARK: - View Output (Presenter -> View)
protocol PresenterToViewCalendarProtocol {
    func updateTableView()
    func onFailureCoreData(errorText:String)
    func onFailureGetTasks(errorText:String)
}

//MARK: -  Interactor Input (Presenter -> Interactor)
protocol PresenterToInteractorCalendarProtocol {
    var presenter:InteractorToPresenterCalendarProtocol? {get set}
    func onGetTasks(date:Date)
    func getNumberOfDateEvents(date:Date) -> Int
}

//MARK: - Interactor Output (Interactor -> Presenter)
protocol InteractorToPresenterCalendarProtocol {
    func successfulyGetTasks(tasks:[NSManagedObject])
    func failureGetTasks(errorText:String)
}

//MARK: - Router Input (Presenter -> Router)
protocol PresenterToRouterCalendarProtocol {
    static func createModule() -> CalendarViewController
}
