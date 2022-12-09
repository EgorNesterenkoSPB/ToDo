import UIKit
import CoreData

final class MainPresenter: ViewToPresenterMainProtocol {

    var view: PresenterToViewMainProtocol?
    var router: PresenterToRouterMainProtocol?
    var interactor: PresenterToInteractorMainProtocol?
    var countOfSections = 2
    var todayTasks = [NSManagedObject]()
    var overdueTasks = [NSManagedObject]()
    var currentProjectID:NSManagedObjectID?
    
    private enum UIConstants {
        static let heightHeader = 40.0
        static let heightFooter = 2.0
    }
    
    func getData() {
        do {
            let projects = try DataManager.shared.projects()
            todayTasks.removeAll()
            overdueTasks.removeAll()
            for project in projects {
                var commonTasks = try DataManager.shared.commonTasks(project: project)
                commonTasks = commonTasks.filter{$0.isFinished == false}
                commonTasks.forEach({commonTask in
                    if let time = commonTask.time {
                        if isOverdue(taskDate: time) {
                            overdueTasks.append(commonTask)
                        } else if isToday(taskTime: time) {
                            todayTasks.append(commonTask)
                        }
                    }
                })
                let categories = try DataManager.shared.categories(project: project)
                for category in categories {
                    var categoryTasks = try DataManager.shared.tasks(category: category)
                    categoryTasks = categoryTasks.filter{$0.isFinished == false}
                    categoryTasks.forEach{categoryTask in
                        if let time = categoryTask.time {
                            if isOverdue(taskDate: time) {
                                overdueTasks.append(categoryTask)
                            } else if isToday(taskTime: time) {
                                todayTasks.append(categoryTask)
                            }
                        }
                    }
                }
            }
            self.view?.updateTableView()
        } catch let error {
            self.view?.errorGetCoreData(errorText: error.localizedDescription)
        }
    }
    
    private func isToday(taskTime:Date) -> Bool {
        let today = Date()
        if (Calendar.current.compare(today, to: taskTime, toGranularity: .year) == ComparisonResult.orderedSame && Calendar.current.compare(today, to: taskTime, toGranularity: .month) == ComparisonResult.orderedSame && Calendar.current.compare(today, to: taskTime, toGranularity: .day) == ComparisonResult.orderedSame) {
            return true
        } else {
            return false
        }
    }
    
    
    func userTapSettingsButton(navigationController: UINavigationController?) {
        router?.showSettingsScreen(navigationController: navigationController)
    }
    
    func userTapProjectsButton(navigationController:UINavigationController?) {
        router?.showProjectsScreen(navigationController:navigationController)
    }
    
    func userTapCreateTask(mainViewController: MainViewController) {
        self.router?.showCreateTaskViewController(mainViewController: mainViewController)
    }
    
    
    func numberOfSections() -> Int {
        self.countOfSections
    }
    
    func numberOfRowsInSection(section: Int) -> Int {
        switch section {
        case 0:
            return overdueTasks.count
        case 1:
            return todayTasks.count
        default:
            return 0
        }
    }
    
    func cellForRowAt(tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Resources.Cells.taskCellIdentefier, for: indexPath) as? TaskTableViewCell else {
            return UITableViewCell()
        }
        switch indexPath.section {
        case 0:
            if let commonTask =  overdueTasks[indexPath.row] as? CommonTaskCoreData {
                cell.setup(nameTitle: commonTask.name, descriptionTitle: commonTask.descriptionTask, projectTitle: commonTask.project?.name)
                self.configureOverdueCell(cell: cell, task: commonTask)
            }
            
            if let categoryTask = overdueTasks[indexPath.row] as? TaskCoreData {
                cell.setup(nameTitle: categoryTask.name, descriptionTitle: categoryTask.descriptionTask, projectTitle: categoryTask.category?.project?.name)
                self.configureOverdueCell(cell: cell, task: categoryTask)
            }
        case 1:
            if let commonTask = todayTasks[indexPath.row] as? CommonTaskCoreData {
                cell.setup(nameTitle: commonTask.name, descriptionTitle: commonTask.descriptionTask, projectTitle: commonTask.project?.name)
                cell.handleFinishTask = { [weak self] in
                    self?.interactor?.setFinishTask(task: commonTask)
                }
            }
            
            if let categoryTask = todayTasks[indexPath.row] as? TaskCoreData {
                cell.setup(nameTitle: categoryTask.name, descriptionTitle: categoryTask.descriptionTask, projectTitle: categoryTask.category?.project?.name)
                cell.handleFinishTask = { [weak self] in
                    self?.interactor?.setFinishTask(task: categoryTask)
                }
            }
        default:
            break
        }

        return cell
    }
    
    private func configureOverdueCell(cell:TaskTableViewCell,task:NSManagedObject) {
        cell.nameTitle.textColor = .red
        cell.handleFinishTask = { [weak self] in
            self?.interactor?.setFinishTask(task: task)
        }
    }
    
    func didSelectRowAt(tableView: UITableView, indexPath: IndexPath, navigationController: UINavigationController?) {
        
        switch indexPath.section {
        case 0:
            if let commonTask = overdueTasks[indexPath.row] as? CommonTaskCoreData {
                if let taskName = commonTask.name, let projectName = commonTask.project?.name {
                    self.pushToTaskScreen(name: taskName, description: commonTask.descriptionTask, priority: commonTask.priority, path: "\(projectName)/\(taskName)", isFinished: commonTask.isFinished, time: commonTask.time, navigationController: navigationController, task: commonTask)
                }
            }
            
            if let categoryTask = overdueTasks[indexPath.row] as? TaskCoreData {
                if let name = categoryTask.name, let category = categoryTask.category, let projectName = category.project?.name, let categoryName = category.name {
                    self.pushToTaskScreen(name: name, description: categoryTask.descriptionTask, priority: categoryTask.priority, path:  "\(projectName)/\(categoryName)/", isFinished: categoryTask.isFinished, time: categoryTask.time, navigationController: navigationController, task: categoryTask)
                }
            }
        case 1:
            
            if let commonTask = todayTasks[indexPath.row] as? CommonTaskCoreData {
                if let taskName = commonTask.name, let projectName = commonTask.project?.name {
                    self.pushToTaskScreen(name: taskName, description: commonTask.descriptionTask, priority: commonTask.priority, path: "\(projectName)/\(taskName)", isFinished: commonTask.isFinished, time: commonTask.time, navigationController: navigationController, task: commonTask)
                }
            }
            
            if let categoryTask = todayTasks[indexPath.row] as? TaskCoreData {
                if let name = categoryTask.name, let category = categoryTask.category, let projectName = category.project?.name, let categoryName = category.name {
                    self.pushToTaskScreen(name: name, description: categoryTask.descriptionTask, priority: categoryTask.priority, path:  "\(projectName)/\(categoryName)/", isFinished: categoryTask.isFinished, time: categoryTask.time, navigationController: navigationController, task: categoryTask)
                }
            }
            
        default:
            break
        }
    }
    
    func trailingSwipeActionsConfigurationForRowAt(tableView: UITableView, indexPath: IndexPath, mainViewController: MainViewController) -> UISwipeActionsConfiguration? {
        var completionHandler:((_ task:NSManagedObject) -> Void)
        
        guard let interactor = self.interactor else {return nil }
        completionHandler = interactor.deleteTask
        
        var currentTask = NSManagedObject()

        switch indexPath.section {
        case 0:
            if let commonTask = overdueTasks[indexPath.row] as? CommonTaskCoreData {
                currentTask = commonTask
            }
            
            if let categoryTask = overdueTasks[indexPath.row] as? TaskCoreData {
                currentTask = categoryTask
            }
            
        case 1:
            if let commonTask = overdueTasks[indexPath.row] as? CommonTaskCoreData {
                currentTask = commonTask
            }
            
            if let categoryTask = overdueTasks[indexPath.row] as? TaskCoreData {
                currentTask = categoryTask
            }
        default:
            return nil
        }
        
        let delete = createDeleteTaskContextualAction(title: Resources.Titles.confirmAction, viewController: mainViewController, with: {
            completionHandler(currentTask)
        })
        
        let configuration = UISwipeActionsConfiguration(actions: [delete])
        return configuration
    }
    
    private func pushToTaskScreen(name:String,description:String?,priority:Int64?,path:String,isFinished:Bool,time:Date?,navigationController:UINavigationController?,task:NSManagedObject) {
        let taskContent = TaskContent(name: name, description: description, priority: priority, path: path, isFinished: isFinished, time: time)
        self.router?.showTaskScreen(task: task, taskContent: taskContent, navigationController: navigationController)
    }
    
    func viewForHeaderInSection(tableView: UITableView, section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = .systemBackground
        
        let date = Date()
        let calendar = NSCalendar.current
        let day = calendar.component(.day, from: date)
        let month = calendar.component(.month, from: date)
        
        let title:UILabel = {
           let label = UILabel()
            label.font = .systemFont(ofSize: 24)
            label.text = section == 1 ? "\(day).\(month) \u{2022} Today" : "Overdue"
            return label
        }()
        headerView.addView(title)
        
        NSLayoutConstraint.activate([
            title.bottomAnchor.constraint(equalTo: headerView.bottomAnchor),
            title.leftAnchor.constraint(equalTo: headerView.leftAnchor,constant: 20)
        ])
        
        return headerView
    }
    
    func heightForHeaderInSection() -> CGFloat {
        UIConstants.heightHeader
    }
    
    func heightForFooterInSection() -> CGFloat {
        UIConstants.heightFooter
    }
    
    
}

extension MainPresenter:InteractorToPresenterMainProtocol {
    func successfulyCreateTask() {
        self.getData()
    }
    
    func failureCreateTask(errorText: String) {
        self.view?.errorGetCoreData(errorText: errorText)
    }
    
    func successfulyDeleteTask() {
        self.getData()
    }
    
    func failureDeleteTask(errorText:String) {
        self.view?.errorGetCoreData(errorText: errorText)
    }
    
    func successfulyFinishedTask() {
        self.getData()
    }
    
    func failureFinishedTask(errorText: String) {
        view?.errorGetCoreData(errorText: errorText)
    }
    
    
}

