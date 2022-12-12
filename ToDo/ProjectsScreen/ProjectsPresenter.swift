import UIKit

final class ProjectsPresenter:ViewToPresenterProjectsProtocol {

    var view: PresenterToViewProjectsProtocol?
    var router: PresenterToRouterProjectsProtocol?
    var interactor: PresenterToInteractorProjectsProtocol?
    var sectionsData = [
        ProjectsSection(sectionTitle: nil, projectsData: nil, expandable: nil, modelsData: Resources.projectsModels),
        ProjectsSection(sectionTitle: Resources.Titles.favoriteSection, projectsData: [], expandable: false, modelsData: nil),
        ProjectsSection(sectionTitle: Resources.Titles.projectsSection, projectsData: [], expandable: true, modelsData: nil)
    ]
    
    func getData() throws {
        do {
            let projects = try DataManager.shared.projects()
            sectionsData[1].projectsData = getFavoriteProjects(projects: projects) // second section must be favorite
            sectionsData[2].projectsData = projects.filter({$0.name != Resources.incomingProjectName}) // third section must be projects
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
        
        switch section{
        case 0:
            guard let modelsData = sectionsData[section].modelsData else {return 0}
            return modelsData.count
        default:
            guard let expandable = sectionsData[section].expandable, let projectsData = sectionsData[section].projectsData else {return 0}
            if expandable {
                return projectsData.count
            }
            else {
                return 0
            }
        }
    }
    
    func cellForRowAt(tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Resources.Cells.projectCellIdentefier,for: indexPath) as? ProjectTableViewCell else {
            return UITableViewCell()
        }
        
        switch indexPath.section {
        case 0:
            guard let modelsData = sectionsData[indexPath.section].modelsData else {return UITableViewCell()}
            let model = modelsData[indexPath.row]
            guard let cell = tableView.dequeueReusableCell(withIdentifier: Resources.Cells.commonTableCellIdentefier, for: indexPath) as? CommonTableViewCell else {return UITableViewCell()}
            cell.setup(with: model)
            return cell
        default:
            guard let projectsData = sectionsData[indexPath.section].projectsData else {return UITableViewCell()}
            let project = projectsData[indexPath.row]
            cell.project = project
            cell.nameTitle.text = project.name
            do {
                let countOfTasks = try countOfProjectTasks(project: project)
                cell.countOfTasksLabel.text = "\(countOfTasks)"
            } catch let error {
                view?.onFailedCoreData(errorText: "\(error)")
            }
            cell.circleImageView.tintColor = UIColor(hexString: project.hexColor ?? Resources.defaultHexColor)
            return cell
        }
    }
    
    private func countOfProjectTasks(project:ProjectCoreData) throws -> Int {
        var count:Int = 0
        do {
            let categories = try DataManager.shared.categories(project: project)
            for category in categories {
                do {
                    let tasks = try DataManager.shared.tasks(category: category)
                    count += tasks.filter({$0.isFinished == false}).count
                } catch let error {
                    throw CoreManagerError.failedFetchTasks(text: "\(error)")
                }
            }
            let commonTasks = try DataManager.shared.commonTasks(project: project)
            count += commonTasks.filter({$0.isFinished == false}).count
        } catch let error {
            throw CoreManagerError.failedFetchCategories(text: "\(error)")
        }
        return count
    }
    
    func heightForHeaderInSection(section:Int) -> CGFloat {
        switch section {
        case 0:
            return 0
        default:
            return 60
        }
    }
    
    func heightForFooterInSection() -> CGFloat {
        2
    }
    
    
    func viewForHeaderInSection(projectsViewController:ProjectsViewController,tableView: UITableView, section: Int) -> UIView? {
        
        switch section {
        case 0:
            return UIView()
        default:
            guard let titleText = sectionsData[section].sectionTitle, let expandable = sectionsData[section].expandable else {return nil}
            
            switch section {
            case 1:
                let headerView = BaseTableSectionHeaderView(titleText: titleText, section: section, expandable: expandable)
                headerView.delegate = self
                headerView.addButton.isHidden = true
                return headerView
            default:
                let headerView = ProjectsTableSectionHeaderView(titleText: titleText, section: section, expandable: expandable, projectsViewController: projectsViewController)
                headerView.delegate = self
                return headerView
            }
        }
    }
    
    
    func didSelectRowAt(tableView: UITableView, indexPath: IndexPath,projectsViewController:ProjectsViewController) {
        
        switch indexPath.section {
        case 0:
            guard let modelsData = sectionsData[indexPath.section].modelsData else {return}
            let model = modelsData[indexPath.row]
            switch model.title {
            case Resources.incomingProjectName:
                self.interactor?.getIncomingProject(projectsViewController:projectsViewController)
            case Resources.Titles.calendar:
                self.router?.showCalendarScreen(projectsViewController:projectsViewController)
            case Resources.Titles.productivity:
                self.router?.showProductivityScreen(projectsViewController: projectsViewController)
//            case Resources.Titles.myBlog:
//
            default:
                break
            }
        default:
            guard let cell = tableView.cellForRow(at: indexPath) as? ProjectTableViewCell else {return}
            guard let project = cell.project else {return}
            router?.showProjectScreen(projectsViewController:projectsViewController,project: project)
        }
    }
    
    
    func trailingSwipeActionsConfigurationForRowAt(tableView: UITableView, indexPath: IndexPath,projectsViewController:ProjectsViewController) -> UISwipeActionsConfiguration? {
        guard let cell = tableView.cellForRow(at: indexPath) as? ProjectTableViewCell else {return nil}
        guard let project = cell.project else {return nil}
        
        let delete = createDeleteTaskContextualAction(title: Resources.Titles.confirmAction, viewController: projectsViewController, with: { [weak self] in
            self?.interactor?.deleteProject(project: project)
        })

        let configuration = UISwipeActionsConfiguration(actions: [delete])
        return configuration
    }
}

extension ProjectsPresenter:InteractorToPresenterProjectsProtocol {
    func successfulyGetIncomingProject(project: ProjectCoreData, projectsViewController: ProjectsViewController) {
        self.router?.showIncomingProject(project: project, projectsViewController: projectsViewController)
    }
    
    func failedGetIncomingProject(errorText: String) {
        self.view?.onFailedGetIncomingProject(errorText: errorText)
    }
    
    func successfulyDeleteProject() {
        do {
            try self.getData()
        } catch let error {
            view?.onFailedCoreData(errorText: "\(error)")
        }
        view?.updateTableView()
    }
    
    func failedCoreData(errorText: String) {
        view?.onFailedCoreData(errorText: errorText)
    }
}

extension ProjectsPresenter:BaseTableSectionHeaderViewProtocol {
    
    func updateExpandable(sectionIndex: Int) {
        sectionsData[sectionIndex].expandable?.toggle()
        view?.updateTableView()
    }
}
