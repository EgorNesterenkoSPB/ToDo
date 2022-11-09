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
        return cell
    }
    
}

extension PrjPresenter:InteractorToPresenterPrjProtocol {
    func failedCreateCategory(errorText: String) {
        view?.onFailedCreateCategory(errorText: errorText)
    }
    
    func successfultCreateCategory(project:ProjectCoreData) {
        do {
            let newCategories = try DataManager.shared.categories(project: project)
            self.categories = newCategories
            view?.updateTableView()
        } catch let error {
            view?.failedGetCoreData(errorText: "\(error)")
        }
    }
}
