import UIKit

final class ProjectsPresenter:ViewToPresenterProjectsProtocol {
    var view: PresenterToViewProjectsProtocol?
    var router: PresenterToRouterProjectsProtocol?
    var interactor: PresenterToInteractorProjectsProtocol?
    var sectionsData = [
        ProjectsSection(sectionTitle: "Favorite", data: [
            Project(name: "Application", categories: [
                Category(name: "test Category", tasks: [
                    Task(name: "first task", description: "test description", priority: "hight", time: "test Time", isOverdue: false)])], hexColor: "644AFF")],
                        expandable: false),
        ProjectsSection(sectionTitle: "Projects", data: [
            Project(name: "Application", categories: [
                Category(name: "test Category", tasks: [
                    Task(name: "first task", description: "test description", priority: "hight", time: "test Time", isOverdue: false)])], hexColor: "644AFF"),
            Project(name: "Desktop", categories: [
                Category(name: "test Category", tasks: [
                    Task(name: "first task", description: "test description", priority: "hight", time: "test Time", isOverdue: false)])], hexColor: "3FFF34")],
                        expandable: false)]
    
    func numberOfSections() -> Int {
        sectionsData.count
    }
    
    func numberOfRowsInSection(section: Int) -> Int {
        if sectionsData[section].expandable {
            return sectionsData[section].data.count
        }
        else {
            return 0
        }
    }
    
    func cellForRowAt(tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Resources.Cells.projectCellIdentefier,for: indexPath) as? ProjectTableViewCell else {
            return UITableViewCell()
        }
        let project = sectionsData[indexPath.section].data[indexPath.row]
        cell.nameTitle.text = project.name
        cell.countOfTasksLabel.text = "\(countOfProjectTasks(project: project))"
        cell.circleImageView.tintColor = UIColor(hexString: project.hexColor)
        return cell
    }
    
    private func countOfProjectTasks(project:Project) -> Int {
        var count:Int = 0
        for category in project.categories {
            count += category.tasks.count
        }
        return count
    }
    
    func heightForHeaderInSection() -> CGFloat {
        60
    }
    
    func heightForFooterInSection() -> CGFloat {
        2
    }
    
    
    func viewForHeaderInSection(projectsViewController:ProjectsViewController,tableView: UITableView, section: Int) -> UIView? {
        let titleText = sectionsData[section].sectionTitle
        let expandable = sectionsData[section].expandable
        switch section {
        case 0:
            let headerView = BaseTableSectionHeaderView(titleText: titleText, section: section, expandable: expandable)
            headerView.delegate = self
            return headerView
        default:
            let headerView = ProjectsTableSectionHeaderView(titleText: titleText, section: section, expandable: expandable, projectsViewController: projectsViewController)
            headerView.delegate = self
            return headerView
        }
        
    }
}

extension ProjectsPresenter:InteractorToPresenterProjectsProtocol {
    
}

extension ProjectsPresenter:BaseTableSectionHeaderViewProtocol {
    
    func updateExpandable(sectionIndex: Int) {
        sectionsData[sectionIndex].expandable.toggle()
        view?.updateTableView()
    }
}
