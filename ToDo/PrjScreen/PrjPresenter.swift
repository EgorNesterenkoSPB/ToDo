import UIKit

final class PrjPresenter:ViewToPresenterPrjProtocol {

    var view: PresenterToViewPrjProtocol?
    var router: PresenterToRouterPrjProtocol?
    var interactor: PresenterToInteractorPrjProtocol?
    private var sectionsData = [CategorySection]()
    private var categories = [CategoryCoreData]()
    var commonTasks = [CommonTaskCoreData]()
    var isHiddedFinishedTasks:Bool = true
    
    func getCategories(project: ProjectCoreData) {
        do {
            var newSectionsData = [CategorySection]()
            
            let zeroSection = CategorySection(sectionTitle: nil, objectID: nil, categoryData: nil, commonTasks: self.commonTasks, expandable: nil)
            newSectionsData.append(zeroSection) // first section must be common tasks
            
            let categories = try DataManager.shared.categories(project: project)
            self.categories = categories
            for category in categories {
                let savedTasks = try DataManager.shared.tasks(category: category)
                let filteredArray = self.filteredTasks(inputTasks: savedTasks)
        
                let section = CategorySection(sectionTitle: category.name, objectID: category.objectID, categoryData: filteredArray, commonTasks: nil, expandable: false)
                newSectionsData.append(section)
            }
            self.sectionsData = newSectionsData
            view?.updateTableView()
        } catch let error {
            view?.failedCoreData(errorText: "\(error)")
        }
    }
    
    private func filteredTasks(inputTasks:[TaskCoreData]) -> [TaskCoreData] {
        var outputTasks = [TaskCoreData]()
        outputTasks = inputTasks
        
        if isHiddedFinishedTasks {
            outputTasks = outputTasks.filter({$0.isFinished == false})
        } else {
            for task in outputTasks{
                if task.isFinished {
                    outputTasks = outputTasks.filter({$0 != task})
                    outputTasks.append(task)
                }
            }
        }
        return outputTasks
    }
    
    private func filteredCommonTasks(inputTasks:[CommonTaskCoreData]) -> [CommonTaskCoreData] {
        var outputCommonTasks = [CommonTaskCoreData]()
        outputCommonTasks = inputTasks
        if isHiddedFinishedTasks {
            outputCommonTasks = outputCommonTasks.filter({$0.isFinished == false})
        } else {
            for task in outputCommonTasks{
                if task.isFinished {
                    outputCommonTasks = outputCommonTasks.filter({$0 != task})
                    outputCommonTasks.append(task)
                }
            }
        }
        return outputCommonTasks
    }
    
    func getCommonTasks(project: ProjectCoreData) {
        do {
            let _commonTasks = try DataManager.shared.commonTasks(project: project)
            let filteredCommonTasks = self.filteredCommonTasks(inputTasks: _commonTasks)
            self.commonTasks = filteredCommonTasks
            view?.reloadCommonTasksSection()
        } catch let error {
            view?.failedCoreData(errorText: "\(error)")
        }
    }
    
    private func configureCell(cell:TaskTableViewCell) {
        cell.circleButton.setImage(UIImage(systemName: Resources.Images.circle,withConfiguration: Resources.Configurations.largeConfiguration), for: .normal)
        cell.circleButton.tintColor = UIColor(named: Resources.Titles.labelAndTintColor)
        cell.nameTitle.attributedText = nil
        cell.nameTitle.textColor = UIColor(named: Resources.Titles.labelAndTintColor)
        cell.handleFinishTask = nil
    }
    
    
    func updateSection(category: CategoryCoreData,section:Int) {
        do {
            let savedTasks = try DataManager.shared.tasks(category: category)
            let filteredTasks = self.filteredTasks(inputTasks: savedTasks)

            if let row = self.sectionsData.firstIndex(where: {$0.objectID == category.objectID}) {
                sectionsData[row].categoryData = filteredTasks
                sectionsData[row].expandable = true
                view?.onUpdateSection(section: section)
            }
        } catch let error {
            view?.failedCoreData(errorText: "\(error)")
        }
    }
    
    func showCreateCommonTaskScreen(project: ProjectCoreData,prjViewController:PrjViewController) {
        router?.onShowCreateCommonTaskViewController(project: project,prjViewController:prjViewController)
    }
    
    
    func showEditAlert(project: ProjectCoreData,prjViewController:PrjViewController) {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
    
        alertController.addAction(UIAlertAction(title: Resources.Titles.renameProject, style: .default, handler: {[weak self] _ in
            guard let renameProjectAlert = self?.showActionAlert(title: Resources.Titles.newName, message: Resources.Titles.writeName, with: { text in
                self?.interactor?.renameProject(project: project, newName: text)
            }) else {return}
            prjViewController.present(renameProjectAlert,animated: true)
        }))
        
        alertController.addAction(UIAlertAction(title: Resources.Titles.changeProjectColor, style: .default, handler: { _ in
            let colorPopOverViewController = ColorsViewController(project: project)
            colorPopOverViewController.delegate = self
            prjViewController.present(colorPopOverViewController,animated: true)
        }))
        
        alertController.addAction(UIAlertAction(title: Resources.Titles.createCategory, style: .default, handler: { [weak self] _ in
            guard let createCategoryAlert = self?.showActionAlert(title: Resources.Titles.createCategory, message: Resources.Titles.writeName, with: { text in
                self?.interactor?.createCategory(name: text, project: project)
            }) else {return}
            prjViewController.present(createCategoryAlert,animated: true)
        }))
        
        alertController.addAction(UIAlertAction(title: isHiddedFinishedTasks ? Resources.Titles.showFinishedTasks : Resources.Titles.hideFinishedTasks, style: .default, handler: { [weak self] _ in
            self?.isHiddedFinishedTasks.toggle()
            self?.getCategories(project: project)
            self?.getCommonTasks(project: project)
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
    
    private func showActionAlert(title:String,message:String,with completion: @escaping (_ text:String) -> Void) -> UIAlertController{
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        alertController.addTextField(configurationHandler: { (textField:UITextField) -> Void in
            textField.placeholder = Resources.Titles.name
        })
        
        alertController.addAction(UIAlertAction(title: Resources.Titles.confirmButtonTitle, style: .default, handler: { _ in
            let textField = alertController.textFields![0] as UITextField
            guard let text = textField.text, text != " ", text != "" else {return}
            completion(text)
        }))
        alertController.addAction(UIAlertAction(title: Resources.Titles.cancelButton, style: .cancel, handler: nil))
        
        return alertController
    }
    
    func numberOfRowsInSection(section:Int) -> Int {
        
        switch section {
        case 0:
            return commonTasks.count
        default:
            guard let expandable = sectionsData[section].expandable else {return 0}
            if expandable{
                return sectionsData[section].categoryData?.count ?? 0
            }
            else {
                return 0
            }
        }
    }
    
    func numberOfSections() -> Int {
        self.sectionsData.count
    }
    
    func cellForRowAt(tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Resources.Cells.taskCellIdentefier, for: indexPath) as? TaskTableViewCell else {return UITableViewCell()}
        self.configureCell(cell: cell)
        if indexPath.section == 0 {
            let commonTask = commonTasks[indexPath.row]
            cell.nameTitle.text = commonTask.name
            cell.descriptionTitle.text = commonTask.descriptionTask
            cell.handleFinishTask = { [weak self] in
                self?.interactor?.setFinishTask(task:commonTask, indexPath: nil, unfinished: commonTask.isFinished ? true : false)
            }
            
            if !isHiddedFinishedTasks && commonTask.isFinished {
                throughLineCell(cell: cell, indexPath: indexPath)
            }
        } else {
            guard let task = sectionsData[indexPath.section].categoryData?[indexPath.row] else {return UITableViewCell()}
            cell.nameTitle.text = task.name
            cell.descriptionTitle.text = task.descriptionTask
            cell.handleFinishTask = { [weak self] in
                self?.interactor?.setFinishTask(task: task, indexPath: indexPath, unfinished: task.isFinished ? true : false)
            }
            if !isHiddedFinishedTasks && task.isFinished {
                throughLineCell(cell: cell, indexPath: indexPath)
            }
        }
        return cell
    }

    
    func didSelectRowAt(tableView: UITableView, indexPath: IndexPath,navigationController:UINavigationController?) {
        switch indexPath.section {
        case 0:
            let commonTask = commonTasks[indexPath.row]
            guard let taskName = commonTask.name, let projectName = commonTask.project?.name else {return}
            
            let taskContent = TaskContent(name: taskName, description: commonTask.descriptionTask, priority: commonTask.priority, path: "\(projectName)/\(taskName)", isFinished: commonTask.isFinished, time: commonTask.time)
            self.router?.showTaskScreen(task: commonTask, taskContent: taskContent, navigationController: navigationController)
        default:
            
            break
        }
        
    }
    
    private func createDeleteTaskContextualAction(indexPath:IndexPath,with completion: @escaping() -> Void) -> UIContextualAction {
        let delete = UIContextualAction(style: .destructive, title: nil, handler: { _,_,_  in
            completion()
        })
        delete.image = UIImage(systemName: Resources.Images.trash,withConfiguration: Resources.Configurations.largeConfiguration)
        delete.image?.withTintColor(.white)
        delete.backgroundColor = .red
        return delete
    }
    
    func trailingSwipeActionsConfigurationForRowAt(tableView: UITableView, indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let delete = createDeleteTaskContextualAction(indexPath: indexPath) {
            
            if indexPath.section == 0 {
                let task = self.commonTasks[indexPath.row]
                self.interactor?.deleteCommonTask(commonTask: task)
            } else {
                guard let task = self.sectionsData[indexPath.section].categoryData?[indexPath.row] else {return}
                guard let category = task.category else {return}
                self.interactor?.deleteTask(task: task, category: category , section: indexPath.section)
            }
        }
        let configuration = UISwipeActionsConfiguration(actions: [delete])
        return configuration
    }

    func heightForHeaderInSection(section:Int) -> CGFloat {
        if section == 0 {
            return 0
        } else {
            return 60
        }
        
    }
    
    func heightForFooterInSection() -> CGFloat {
        2
    }
    
    func viewForHeaderInSection(prjViewController:PrjViewController, tableView: UITableView, section: Int) -> UIView? {
        
        if section == 0 {
            return UIView()
        }
        
        guard let objectID = sectionsData[section].objectID, let expandable = sectionsData[section].expandable, let title =  sectionsData[section].sectionTitle else {return nil}
        
        var currentCategory:CategoryCoreData?
        
        for category in categories {
            if category.objectID == objectID {
                currentCategory = category
            }
        }
        guard let currentCategory = currentCategory else {
            return nil
        }
        let headerView = CategoryTableSectionHeaderView(titleText: title, section: section, expandable: expandable, prjViewController: prjViewController, category:currentCategory, projectName: prjViewController.title ?? Resources.Titles.errorTitle)
        headerView.delegate = self
        headerView.categoryDelegate = self
        return headerView
    }

}

extension PrjPresenter:BaseTableSectionHeaderViewProtocol {
    func updateExpandable(sectionIndex: Int) {
        sectionsData[sectionIndex].expandable?.toggle()
        view?.onUpdateSection(section: sectionIndex)
    }
}

extension PrjPresenter:CategoryTableSectionHeaderViewProtocol {
    func renameSection(category: CategoryCoreData) {
        let alert = showActionAlert(title: Resources.Titles.newName, message: Resources.Titles.writeName, with: { [weak self] text in
            guard let self = self else {return}
            self.interactor?.onRenameCategory(category: category,sectionsData: self.sectionsData, newName: text)
        })
        view?.showRenameCategoryAlert(alert: alert)
    }
    
    func deleteSection(category: CategoryCoreData) {
        interactor?.deleteCategory(category: category)
    }
}

extension PrjPresenter:ColorsViewControllerProtocol {
    func getColor(hexColor: String,project:ProjectCoreData) {
        self.interactor?.changeProjectColor(hexColor: hexColor, project: project)
    }
}


extension PrjPresenter:InteractorToPresenterPrjProtocol {
    func onfailedCoreData(errorText: String) {
        view?.failedCoreData(errorText: errorText)
    }
    
    func successfulyFinishedCatagoryTask(category:CategoryCoreData?,section:Int) {
        guard let category = category else {
            return
        }
        self.updateSection(category: category, section: section)
    }
    
    func successfulyFinishedCommonTask(project:ProjectCoreData?) {
        guard let project = project else {
            return
        }
        self.getCommonTasks(project: project)
    }
    
    
    func successfulyDeleteCommonTask() {
        view?.updateDataCommonTasks()
    }

    
    func successfulyRenamedCategory(section:Int,newName:String) {
        self.sectionsData[section].sectionTitle = newName
        view?.onUpdateSection(section: section)
    }
    
    func successfulyRenameProject() {
        view?.onSuccessfulyRenameProject()
    }
    
    func successfulyDeleteTask(category:CategoryCoreData,section:Int) {
        self.updateSection(category: category, section: section)
    }
    
    func successfulyDeleteCategory() {
        view?.onSuccessfulyDeleteCategory()
    }
    
    func successfulyDeleteProject() {
        view?.hideViewController()
    }
    
    func successfulyDeleteAllCategories(project:ProjectCoreData) {
        self.getCategories(project: project)
    }
    
    func successfulyCreateCategory(project:ProjectCoreData) {
        self.getCategories(project: project)
    }
}
