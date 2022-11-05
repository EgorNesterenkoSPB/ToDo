import Foundation

final class ProjectsRouter:PresenterToRouterProjectsProtocol {
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
