import UIKit

final class ProjectsPresenter:ViewToPresenterProjectsProtocol {
    var view: PresenterToViewProjectsProtocol?
    var router: PresenterToRouterProjectsProtocol?
    var interactor: PresenterToInteractorProjectsProtocol?
//    var sectionsData = [
//        ProjectsSection(sectionTitle: "Favorite", data: [
//            Project(name: "Application", categories: [
//                Category(name: "test Category", tasks: [
//                    Task(name: "first task", description: "test description", priority: "hight", time: "test Time", isOverdue: false)])], hexColor: "644AFF")],
//                        expandable: false),
//        ProjectsSection(sectionTitle: "Projects", data: [
//            Project(name: "Application", categories: [
//                Category(name: "test Category", tasks: [
//                    Task(name: "first task", description: "test description", priority: "hight", time: "test Time", isOverdue: false)])], hexColor: "644AFF"),
//            Project(name: "Desktop", categories: [
//                Category(name: "test Category", tasks: [
//                    Task(name: "first task", description: "test description", priority: "hight", time: "test Time", isOverdue: false)])], hexColor: "3FFF34")],
//                        expandable: false)]
    var sectionsData = [
        ProjectsSection(sectionTitle: Resources.Titles.favoriteSection,
                        data: [],
                        expandable: false),
        ProjectsSection(sectionTitle: Resources.Titles.projectsSection,
                        data: [],
                        expandable: false)
    ]
    
    func viewDidLoad() throws {
        do {
            let projects = try DataManager.shared.projects()
            sectionsData[1].data = projects
            sectionsData[0].data = getFavoriteProjects(projects: projects)
        } catch let error {
            throw CoreManagerError.failedFetchProjects(text: "\(error)")
        }
    }
    
    private func getFavoriteProjects(projects:[ProjectCoreData]) -> [ProjectCoreData] {
        var favoriteProjects = [ProjectCoreData]()
        for project in projects {
            if project.isFavorite {
                favoriteProjects.append(project)
            }
        }
        return favoriteProjects
    }

    func showErrorAlert(errorText: String, projectsViewController: ProjectsViewController) {
        router?.onShowErrorAlert(errorText: errorText, projectsViewController: projectsViewController)
    }
    
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
        //cell.countOfTasksLabel.text = "\(countOfProjectTasks(project: project))"
        do {
            let countOfTasks = try countOfProjectTasks(project: project)
            cell.countOfTasksLabel.text = "\(countOfTasks)"
        } catch let error {
            view?.failedGetCoreData(errorText: "\(error)")
        }
        cell.circleImageView.tintColor = UIColor(hexString: project.hexColor ?? "b8b8b8")
        return cell
    }
    
    private func countOfProjectTasks(project:ProjectCoreData) throws -> Int {
        var count:Int = 0
        do {
            let categories = try DataManager.shared.categories(project: project)
            for category in categories {
                do {
                    let tasks = try DataManager.shared.tasks(category: category)
                    count += tasks.count
                } catch let error {
                    throw CoreManagerError.failedFetchTasks(text: "\(error)")
                }
            }
        } catch let error {
            throw CoreManagerError.failedFetchCategories(text: "\(error)")
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
    
    func createProject(name: String, hexColor: String,isFavorite:Bool) {
        interactor?.onCreateProject(name: name, hexColor: hexColor,isFavorite:isFavorite)
    }
    
}

extension ProjectsPresenter:InteractorToPresenterProjectsProtocol {
    func successfulyCreateProject(projects:[ProjectCoreData]) {
        sectionsData[1].data = projects
        sectionsData[0].data = getFavoriteProjects(projects: projects)
        view?.updateTableView()
    }
    
    func failureCreateProject(errorText: String) {
        view?.onFailureCreateProject(errorText: errorText)
    }
    
    
}

extension ProjectsPresenter:BaseTableSectionHeaderViewProtocol {
    
    func updateExpandable(sectionIndex: Int) {
        sectionsData[sectionIndex].expandable.toggle()
        view?.updateTableView()
    }
}
