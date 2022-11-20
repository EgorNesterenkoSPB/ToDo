import UIKit

final class ProjectsPresenter:ViewToPresenterProjectsProtocol {

    var view: PresenterToViewProjectsProtocol?
    var router: PresenterToRouterProjectsProtocol?
    var interactor: PresenterToInteractorProjectsProtocol?
    var sectionsData = [
        ProjectsSection(sectionTitle: Resources.Titles.favoriteSection,
                        data: [],
                        expandable: false),
        ProjectsSection(sectionTitle: Resources.Titles.projectsSection,
                        data: [],
                        expandable: false)
    ]
    
    func getData() throws {
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
    
    func cellForRowAtTopTableView(tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = Resources.projectsModels[indexPath.section].options[indexPath.row]
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Resources.Cells.commonTableCellIdentefier, for: indexPath) as? CommonTableViewCell else {return UITableViewCell()}
        cell.setup(with: model)
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
            headerView.addButton.isHidden = true
            return headerView
        default:
            let headerView = ProjectsTableSectionHeaderView(titleText: titleText, section: section, expandable: expandable, projectsViewController: projectsViewController)
            headerView.delegate = self
            return headerView
        }
        
    }
    
    
    func didSelectRowAt(tableView: UITableView, indexPath: IndexPath,projectsViewController:ProjectsViewController) {
        guard let cell = tableView.cellForRow(at: indexPath) as? ProjectTableViewCell else {return}
        guard let project = cell.project else {return}
        router?.showProjectScreen(projectsViewController:projectsViewController,project: project)
    }
    
    func didSelectRowAtTopTableView(tableView: UITableView, indexPath: IndexPath) {
        let model = Resources.projectsModels[indexPath.section].options[indexPath.row]
        model.handler()
    }
    
    func trailingSwipeActionsConfigurationForRowAt(tableView: UITableView, indexPath: IndexPath,projectsViewController:ProjectsViewController) -> UISwipeActionsConfiguration? {
        guard let cell = tableView.cellForRow(at: indexPath) as? ProjectTableViewCell else {return nil}
        guard let project = cell.project else {return nil}
        let delete = UIContextualAction(style: .destructive, title: nil, handler: {[weak self] (action,swipeButtonView,completion) in
            let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
            alert.addAction(UIAlertAction(title: Resources.Titles.confirmAction, style: .destructive, handler: { [weak self] _ in
                self?.interactor?.deleteProject(project: project)
            }))
            alert.addAction(UIAlertAction(title: Resources.Titles.cancelButton, style: .cancel, handler: nil))
            projectsViewController.present(alert,animated: true)
            completion(true)
        })
        delete.image = UIImage(systemName: Resources.Images.trash,withConfiguration: Resources.Configurations.largeConfiguration)
        delete.image?.withTintColor(.white)
        delete.backgroundColor = .red

        let configuration = UISwipeActionsConfiguration(actions: [delete])
        return configuration
    }
}

extension ProjectsPresenter:InteractorToPresenterProjectsProtocol {
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
        sectionsData[sectionIndex].expandable.toggle()
        view?.updateTableView()
    }
}
