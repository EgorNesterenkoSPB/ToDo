import UIKit
import FSCalendar
import CoreData

final class CalendarPresenter:ViewToPresenterCalendarProtocol {

    var view: PresenterToViewCalendarProtocol?
    var router: PresenterToRouterCalendarProtocol?
    var interactor: PresenterToInteractorCalendarProtocol?
    var tasks = [NSManagedObject]()
    var currentDate:Date?
    
    func updateTasksDay(date: Date) {
        self.currentDate = date
        interactor?.onGetTasks(date: date)
    }
    
    func getCurrentDateTasks() {
        guard let currentDate = currentDate else {return}
        interactor?.onGetTasks(date: currentDate)
    }
    
    func getTasks(date: Date) {
        self.currentDate = date // hold it to update data at table view when user delete task
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
        let currentTask = tasks[indexPath.row]
        
        if let commonTask = currentTask as? CommonTaskCoreData {
            if let taskName = commonTask.name, let projectName = commonTask.project?.name {
                self.pushToTaskScreen(name: taskName, description: commonTask.descriptionTask, priority: commonTask.priority, path: "\(projectName)/\(taskName)", isFinished: commonTask.isFinished, time: commonTask.time, calendarViewController:calendarViewController, task: commonTask)
            }
        } else if let categoryTask = currentTask as? TaskCoreData {
            if let name = categoryTask.name, let category = categoryTask.category, let projectName = category.project?.name, let categoryName = category.name {
                self.pushToTaskScreen(name: name, description: categoryTask.descriptionTask, priority: categoryTask.priority, path:  "\(projectName)/\(categoryName)/", isFinished: categoryTask.isFinished, time: categoryTask.time, calendarViewController:calendarViewController, task: categoryTask)
            }
        }
    }
    
    private func pushToTaskScreen(name:String,description:String?,priority:Int64?,path:String,isFinished:Bool,time:Date?,calendarViewController:CalendarViewController,task:NSManagedObject) {
        let taskContent = TaskContent(name: name, description: description, priority: priority, path: path, isFinished: isFinished, time: time)
        self.router?.showTaskScreen(task: task, taskContent: taskContent, calendarViewController:calendarViewController)
    }
    
    func trailingSwipeActionsConfigurationForRowAt(tableView: UITableView, indexPath: IndexPath, calendarViewController: CalendarViewController) -> UISwipeActionsConfiguration?{
        var completionHandler:((_ task:NSManagedObject) -> Void)
        
        guard let interactor = interactor else {return nil}

        completionHandler = interactor.deleteTask
        let currentTask = tasks[indexPath.row]
        
        let delete = createDeleteTaskContextualAction(title: Resources.Titles.confirmAction, viewController: calendarViewController, with: {
            completionHandler(currentTask)
        })
        
        let configuration = UISwipeActionsConfiguration(actions: [delete])
        return configuration
    }
    
}

extension CalendarPresenter:InteractorToPresenterCalendarProtocol {
    func successfulyDeleteTask() {
        guard let currentDate = currentDate else {return}
        interactor?.onGetTasks(date: currentDate)
    }
    
    func failureCoreData(errorText: String) {
        self.view?.onFailureCoreData(errorText: errorText)
    }
    
    func failureGetTasks(errorText: String) {
        self.view?.onFailureGetTasks(errorText: errorText)
    }
    
    func successfulyGetTasks(tasks: [NSManagedObject]) {
        self.tasks = tasks
        self.view?.updateTableView()
    }
    
    
}
