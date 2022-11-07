import UIKit

final class ProjectsRouter:PresenterToRouterProjectsProtocol {
    func onShowErrorAlert(errorText: String, projectsViewController: ProjectsViewController) {
        let alertController = UIAlertController(title: Resources.Titles.errorTitle, message: errorText, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: Resources.Titles.errorActionTitle, style: .default, handler: nil))
        projectsViewController.present(alertController,animated: true)
    }
    
    static func createModule() -> ProjectsViewController {
        let projectsViewController = ProjectsViewController()
        
        let projectsPresenter: (ViewToPresenterProjectsProtocol & InteractorToPresenterProjectsProtocol) = ProjectsPresenter()
        
        projectsViewController.presenter = projectsPresenter
        projectsViewController.presenter?.view = projectsViewController
        projectsViewController.presenter?.interactor = ProjectsInteractor()
        projectsViewController.presenter?.router = ProjectsRouter()
        projectsViewController.presenter?.interactor?.presenter = projectsPresenter
        return projectsViewController
    }
}
