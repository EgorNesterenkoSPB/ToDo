import UIKit

final class MainRouter:PresenterToRouterMainProtocol {
    
    static func createModule() -> MainViewController {
        let mainViewController = MainViewController()
        
        let mainPresenter: (ViewToPresenterMainProtocol & InteractorToPresenterMainProtocol) = MainPresenter()
        
        mainViewController.presenter = mainPresenter
        mainViewController.presenter?.view = mainViewController
        mainViewController.presenter?.interactor = MainInteractor()
        mainViewController.presenter?.router = MainRouter()
        mainViewController.presenter?.interactor?.presenter = mainPresenter
        return mainViewController
    }
    
    func showProjectsScreen(mainViewController: MainViewController) {
        let projectsViewController = ProjectsRouter.createModule()
        mainViewController.present(projectsViewController,animated: true)
    }
    
}
