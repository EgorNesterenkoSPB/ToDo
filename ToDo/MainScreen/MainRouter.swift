import UIKit

final class MainRouter:PresenterToRouterMainProtocol {
    func showSettingsScreen(navigationController: UINavigationController?) {
        let settingsViewController = SettingsRouter.createModule()
        navigationController?.pushViewController(settingsViewController, animated: true)
    }
    

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
    
    func showProjectsScreen(navigationController:UINavigationController?) {
        let projectsViewController = ProjectsRouter.createModule()
        navigationController?.pushViewController(projectsViewController, animated: true)
    }
    
    func showCreateTaskViewController(mainViewController: MainViewController) {
        let createTaskViewController = CreateTaskBaseController()
        createTaskViewController.modalPresentationStyle = .overCurrentContext
        mainViewController.present(createTaskViewController,animated: false)
    }

}
