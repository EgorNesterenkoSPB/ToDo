import UIKit
import FSCalendar
import CoreData

final class CalendarPresenter:ViewToPresenterCalendarProtocol {

    var view: PresenterToViewCalendarProtocol?
    var router: PresenterToRouterCalendarProtocol?
    var interactor: PresenterToInteractorCalendarProtocol?
    var tasks = [NSManagedObject]()
    
    func updateTasksDay(date: Date) {
        interactor?.onGetTasks(date: date)
    }
    
    func getTasks(date: Date) {
        interactor?.onGetTasks(date: date)
    }
    
    func numberOfEvents(date: Date) -> Int {
        interactor?.getNumberOfDateEvents(date: date) ?? 0
    }
    
    func editeCalendarHeight(calendar: FSCalendar, showHideButton: UIButton) {
        if calendar.scope == .week {
            calendar.setScope(.month, animated: true)
            showHideButton.setTitle(Resources.Titles.hideCalendar, for: .normal)
        } else {
            calendar.setScope(.week, animated: true)
            showHideButton.setTitle(Resources.Titles.openCalendar, for: .normal)
        }
    }
    
    func numberOfSections() -> Int {
        1
    }
    
    func numberOfRowsInSection(section: Int) -> Int {
        tasks.count
    }
    
    func cellForRowAt(tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Resources.Cells.taskCellIdentefier, for: indexPath) as? TaskTableViewCell else {
            return UITableViewCell()
        }
        let task = tasks[indexPath.row]
        if let commonTask = task as? CommonTaskCoreData {
            cell.setup(nameTitle: commonTask.name, descriptionTitle: commonTask.descriptionTask, projectTitle: commonTask.project?.name)
        } else if let categoryTask = task as? TaskCoreData {
            cell.setup(nameTitle: categoryTask.name, descriptionTitle: categoryTask.descriptionTask, projectTitle: categoryTask.category?.project?.name)
        }
        return cell
    }
    
    func didSelectRowAt(tableView: UITableView, indexPath: IndexPath, calendarViewController: CalendarViewController) {
        
    }
    
    func trailingSwipeActionsConfigurationForRowAt(tableView: UITableView, indexPath: IndexPath, calendarViewController: CalendarViewController) -> UISwipeActionsConfiguration?{
        nil
    }
    
}

extension CalendarPresenter:InteractorToPresenterCalendarProtocol {
    func failureGetTasks(errorText: String) {
        self.view?.onFailureGetTasks(errorText: errorText)
    }
    
    func successfulyGetTasks(tasks: [NSManagedObject]) {
        self.tasks = tasks
        self.view?.updateTableView()
    }
    
    
}
