import UIKit

final class PrjPresenter:ViewToPresenterPrjProtocol {

    var view: PresenterToViewPrjProtocol?
    var router: PresenterToRouterPrjProtocol?
    var interactor: PresenterToInteractorPrjProtocol?
    private var sectionsData = [CategorySection]()
    private var categories = [CategoryCoreData]()
    var commonTasks = [CommonTaskCoreData]()
    
    func getCategories(project: ProjectCoreData) {
        do {
            var newSectionsData = [CategorySection]()
            let categories = try DataManager.shared.categories(project: project)
            self.categories = categories
            for category in categories {
                var tasks = [TaskCoreData]()
                let savedTasks = try DataManager.shared.tasks(category: category)
                tasks = savedTasks
                let section = CategorySection(sectionTitle: category.name ?? "error get name", data: tasks, expandable: false)
                newSectionsData.append(section)
            }
            self.sectionsData = newSectionsData
            view?.updateTableView()
        } catch let error {
            view?.failedGetCoreData(errorText: "\(error)")
        }
    }
    
    func getCommonTasks(project: ProjectCoreData) {
        do {
            let _commonTasks = try DataManager.shared.commonTasks(project: project)
            self.commonTasks = _commonTasks
            view?.onUpdateCommonTasksTableView()
        } catch let error {
            view?.failedGetCoreData(errorText: "\(error)")
        }
    }
    
    func numberOfRowsInCommonTasksTable() -> Int {
        return commonTasks.count
    }
    
    func cellForRowAtCommonTasksTable(tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Resources.Cells.commonTaskCellIdentefier, for: indexPath) as? TaskTableViewCell else {return UITableViewCell()}
        let commonTask = commonTasks[indexPath.row]
        cell.nameTitle.text = commonTask.name
        cell.descriptionTitle.text = commonTask.descriptionTask
        return cell
    }
    
    func trailingSwipeActionsConfigurationForRowAtCommonTasksTable(tableView: UITableView, indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        return nil
    }
    
    func updateSection(category: CategoryCoreData,section:Int) {
        do {
            let tasks = try DataManager.shared.tasks(category: category)
            if let row = self.sectionsData.firstIndex(where: {$0.sectionTitle == category.name}) {
                sectionsData[row].data = tasks
                sectionsData[row].expandable = true
                view?.onUpdateSection(section: section)
            }
        } catch let error {
            view?.failedGetCoreData(errorText: "\(error)")
        }
        
    }
    
    func showCreateCommonTaskScreen(project: ProjectCoreData,prjViewController:PrjViewController) {
        router?.onShowCreateCommonTaskViewController(project: project,prjViewController:prjViewController)
    }
    
    
    func showEditAlert(project: ProjectCoreData,prjViewController:PrjViewController) {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
    
        alertController.addAction(UIAlertAction(title: Resources.Titles.renameProject, style: .default, handler: {[weak self] _ in
            
        }))
        
        alertController.addAction(UIAlertAction(title: Resources.Titles.createCategory, style: .default, handler: { [weak self] _ in
            guard let alert = self?.showCreateCategoryAlert(project: project) else {return}
            prjViewController.present(alert,animated: true)
        }))
        
        alertController.addAction(UIAlertAction(title: Resources.Titles.deleteProject, style: .destructive, handler: {[weak self] (action:UIAlertAction) -> Void in
            self?.interactor?.deleteProject(project: project)
        }))
        
        alertController.addAction(UIAlertAction(title: Resources.Titles.deleteAllProjects, style: .destructive, handler: {[weak self] (action:UIAlertAction) -> Void in
            self?.interactor?.deleteAllCategories(project: project)
        }))
        
        alertController.addAction(UIAlertAction(title: Resources.Titles.cancelButton, style: .cancel, handler: nil))
        
        prjViewController.present(alertController,animated: true)
    }
    
    func showCreateCategoryAlert(project:ProjectCoreData) -> UIAlertController {
        let createAlertController = UIAlertController(title: Resources.Titles.createCategory, message: Resources.Titles.writeName, preferredStyle: .alert)
        
        createAlertController.addTextField(configurationHandler: { (textField:UITextField) -> Void in
            textField.placeholder = Resources.Titles.name
        })
        
        createAlertController.addAction(UIAlertAction(title: Resources.Titles.create, style: .default, handler: {[weak self] (action:UIAlertAction) -> Void in
            let textField = createAlertController.textFields![0] as UITextField
            guard let text = textField.text, text != " ", text != "" else {return}
            self?.interactor?.createCategory(name: text, project: project)
        }))
        
        createAlertController.addAction(UIAlertAction(title: Resources.Titles.cancelButton, style: .cancel, handler: nil))
        
        return createAlertController
    }
    
    func numberOfRowsInSection(section:Int) -> Int {
        if sectionsData[section].expandable {
            return sectionsData[section].data.count
        }
        else {
            return 0
        }
    }
    
    func numberOfSections() -> Int {
        self.sectionsData.count
    }
    
    func cellForRowAt(tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Resources.Cells.taskCellIdentefier, for: indexPath) as? TaskTableViewCell else {return UITableViewCell()}
        let task = sectionsData[indexPath.section].data[indexPath.row]
        cell.nameTitle.text = task.name
        cell.descriptionTitle.text = task.descriptionTask
        return cell
    }
    
    func trailingSwipeActionsConfigurationForRowAt(tableView: UITableView, indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let delete = UIContextualAction(style: .destructive, title: nil, handler: {[weak self] (action,swipeButtonView,completion) in
            guard let task = self?.sectionsData[indexPath.section].data[indexPath.row], let category = task.category else {return}
            self?.interactor?.deleteTask(task: task, category: category , section: indexPath.section)
            completion(true)
        })
        delete.image = UIImage(systemName: Resources.Images.trash,withConfiguration: Resources.Configurations.largeConfiguration)
        delete.image?.withTintColor(.white)
        delete.backgroundColor = .red

        let configuration = UISwipeActionsConfiguration(actions: [delete])
        return configuration
    }
    
    func heightForHeaderInSection() -> CGFloat {
        60
    }
    
    func heightForFooterInSection() -> CGFloat {
        2
    }
    
    func viewForHeaderInSection(prjViewController:PrjViewController, tableView: UITableView, section: Int) -> UIView? {
        let titleText = sectionsData[section].sectionTitle
        let expandable = sectionsData[section].expandable
        var currentCategory:CategoryCoreData?
        
        for category in categories {
            if category.name == titleText {
                currentCategory = category
            }
        }
        guard let currentCategory = currentCategory else {
            return nil
        }
        let headerView = CategoryTableSectionHeaderView(titleText: titleText, section: section, expandable: expandable, prjViewController: prjViewController, category:currentCategory, projectName: prjViewController.title ?? Resources.Titles.errorTitle)
        headerView.delegate = self
        return headerView
    }
    
}

extension PrjPresenter:BaseTableSectionHeaderViewProtocol {
    func updateExpandable(sectionIndex: Int) {
        sectionsData[sectionIndex].expandable.toggle()
        view?.updateTableView()
    }
    
    
}


extension PrjPresenter:InteractorToPresenterPrjProtocol {
    func failedDeleteTask(errorText: String) {
        view?.onFailedDeleteTask(errorText: errorText)
    }
    
    func successfulyDeleteTask(category:CategoryCoreData,section:Int) {
        self.updateSection(category: category, section: section)
    }
    
    func successfulyDeleteCategory() {
        view?.onSuccessfulyDeleteCategory()
    }
    
    func failedDeleteCategory(errorText: String) {
        view?.onFailedDeleteCategory(errorText: errorText)
    }
    
    func failedDeleteProject(errorText: String) {
        view?.onFailedDeleteProject(errorText: errorText)
    }
    
    func failedDeleteAllCategories(errorText: String) {
        view?.onFailedDeleteAllCategories(errorText: errorText)
    }
    
    func successfulyDeleteProject() {
        view?.hideViewController()
    }
    
    func successfulyDeleteAllCategories(project:ProjectCoreData) {
        self.getCategories(project: project)
    }
    
    func failedCreateCategory(errorText: String) {
        view?.onFailedCreateCategory(errorText: errorText)
    }
    
    func successfulyCreateCategory(project:ProjectCoreData) {
        self.getCategories(project: project)
    }
}
