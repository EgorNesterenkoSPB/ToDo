import UIKit

final class PrjPresenter:ViewToPresenterPrjProtocol {
    var view: PresenterToViewPrjProtocol?
    var router: PresenterToRouterPrjProtocol?
    var interactor: PresenterToInteractorPrjProtocol?
    private var categories:[CategoryCoreData]?
    
    func getCategories(project: ProjectCoreData) {
        do {
            let categories = try DataManager.shared.categories(project: project)
            self.categories = categories
            view?.updateTableView()
        } catch let error {
            view?.failedGetCoreData(errorText: "\(error)")
        }
    }
    
    func showEditAlert(project: ProjectCoreData) -> UIAlertController {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alertController.addAction(UIAlertAction(title: "Delete project", style: .destructive, handler: {[weak self] (action:UIAlertAction) -> Void in
            self?.interactor?.deleteProject(project: project)
        }))
        alertController.addAction(UIAlertAction(title: "Delete all categories", style: .destructive, handler: {[weak self] (action:UIAlertAction) -> Void in
            self?.interactor?.deleteAllCategories(project: project)
        }))
        alertController.addAction(UIAlertAction(title: Resources.Titles.cancelButton, style: .cancel, handler: nil))
        return alertController
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
    
    func numberOfRowsInSection() -> Int {
        self.categories?.count ?? 0
    }
    
    func cellForRowAt(tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Resources.Cells.categoryIdentefier, for: indexPath) as? CategoryTableViewCell else {return UITableViewCell()}
        guard let categories = categories else {return cell}
        cell.nameLabel.text = categories[indexPath.row].name
        cell.countOfTasksLabel.text = "\(categories[indexPath.row].tasks?.count ?? 0)"
        cell.category = categories[indexPath.row]
        return cell
    }
    
    func trailingSwipeActionsConfigurationForRowAt(tableView: UITableView, indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        guard let cell = tableView.cellForRow(at: indexPath) as? CategoryTableViewCell else {return nil}
        guard let category = cell.category else {return nil}
        let delete = UIContextualAction(style: .destructive, title: nil, handler: {[weak self] (action,swipeButtonView,completion) in
            self?.interactor?.deleteCategory(category: category)
            completion(true)
        })
        delete.image = UIImage(systemName: Resources.Images.trash,withConfiguration: Resources.Configurations.largeConfiguration)
        delete.image?.withTintColor(.white)
        delete.backgroundColor = .red

        let configuration = UISwipeActionsConfiguration(actions: [delete])
        return configuration
    }
    
}

extension PrjPresenter:InteractorToPresenterPrjProtocol {
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
        do {
            let newCategories = try DataManager.shared.categories(project: project)
            self.categories = newCategories
            view?.updateTableView()
        } catch let error {
            view?.failedGetCoreData(errorText: "\(error)")
        }
    }
}
