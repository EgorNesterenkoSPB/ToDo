import UIKit

final class MainPresenter: ViewToPresenterMainProtocol {
    var view: PresenterToViewMainProtocol?
    var router: PresenterToRouterMainProtocol?
    var interactor: PresenterToInteractorMainProtocol?
    var todayProject = Project(name: "Today", categories: [Category(name: "", tasks: [Task(name: "FastAPI", description: "test description", priority: "high", time: "test time", isOverdue: false),Task(name: "2 videos OOP", description: "watch it", priority: "medium", time: "test time", isOverdue: false),Task(name: "Oruel", description: "read book", priority: "low", time: "test time", isOverdue: false)])], hexColor: "644AFF").self
    
    private enum UIConstants {
        static let heightHeader = 60.0
        static let heightFooter = 2.0
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
        2
    }
    
    func numberOfRowsInSection(section: Int) -> Int {
        var countOverdueTasks = 0
        if section == 0 {
            for task in todayProject.categories[0].tasks {
                if task.isOverdue {
                    countOverdueTasks += 1
                }
            }
            return countOverdueTasks
        }
        else {
            return todayProject.categories[0].tasks.count
        }
    }
    
    func cellForRowAt(tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Resources.Cells.taskCellIdentefier, for: indexPath) as? TaskTableViewCell else {
            return UITableViewCell()
        }
        cell.nameTitle.text = todayProject.categories[0].tasks[indexPath.row].name
        cell.projectTitle.text = todayProject.name
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
            label.font = .boldSystemFont(ofSize: 24)
            label.text = section == 0 ? "Overdue" : "\(day).\(month) \u{2022} Today"
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

