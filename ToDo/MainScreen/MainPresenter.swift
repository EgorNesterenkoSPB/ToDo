import UIKit

final class MainPresenter: ViewToPresenterMainProtocol {
    var view: PresenterToViewMainProtocol?
    var router: PresenterToRouterMainProtocol?
    var interactor: PresenterToInteractorMainProtocol?
//    var todayProject = Project(name: "Today", categories: [Category(name: "", tasks: [Task(name: "FastAPI", description: "test description", priority: "high", time: "test time", isOverdue: false),Task(name: "2 videos OOP", description: "watch it", priority: "medium", time: "test time", isOverdue: false),Task(name: "Oruel", description: "read book", priority: "low", time: "test time", isOverdue: false)])], hexColor: "644AFF").self
    var countOfSections = 2
    
    private enum UIConstants {
        static let heightHeader = 40.0
        static let heightFooter = 2.0
        static let heightForRow = 45.0
    }
    
    func heightForRowAt() -> CGFloat {
        UIConstants.heightForRow
    }
    
    func userTapSettingsButton(navigationController: UINavigationController?) {
        router?.showSettingsScreen(navigationController: navigationController)
    }
    
    func userTapProjectsButton(navigationController:UINavigationController?) {
        router?.showProjectsScreen(navigationController:navigationController)
    }
    
    func userTapCreateTask(mainViewController: MainViewController) {
        router?.showCreateTaskViewController(mainViewController: mainViewController)
    }
    
    func numberOfSections() -> Int {
        self.countOfSections
    }
    
    func numberOfRowsInSection(section: Int) -> Int {
//        var countOverdueTasks = 0
//        if section == 0 {
//            for task in todayProject.categories[0].tasks {
//                if task.isOverdue {
//                    countOverdueTasks += 1
//                }
//            }
//            if countOverdueTasks == 0 {
//                countOfSections = 1
//                return todayProject.categories[0].tasks.count
//            }
//            return countOverdueTasks
//        }
//        else {
//            return todayProject.categories[0].tasks.count
//        }
        0
    }
    
    func cellForRowAt(tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Resources.Cells.taskCellIdentefier, for: indexPath) as? TaskTableViewCell else {
            return UITableViewCell()
        }
//        cell.nameTitle.text = todayProject.categories[0].tasks[indexPath.row].name
//        cell.projectTitle.text = todayProject.name
        return cell
    }
    
    func viewForHeaderInSection(tableView: UITableView, section: Int) -> UIView? {
        let headerView = UIView()
        
        let date = Date()
        let calendar = NSCalendar.current
        let day = calendar.component(.day, from: date)
        let month = calendar.component(.month, from: date)
        
        let title:UILabel = {
           let label = UILabel()
            label.font = .systemFont(ofSize: 24)
            label.text = countOfSections == 1 ? "\(day).\(month) \u{2022} Today" : "Overdue"
            return label
        }()
        headerView.addView(title)
        
        NSLayoutConstraint.activate([
            title.centerXAnchor.constraint(equalTo: headerView.centerXAnchor),
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
    
}

