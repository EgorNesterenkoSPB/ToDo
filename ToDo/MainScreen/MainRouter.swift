import UIKit
import CoreData

final class MainRouter:PresenterToRouterMainProtocol {
    func showTaskScreen(task: NSManagedObject, taskContent: TaskContent, navigationController: UINavigationController?) {
        let taskViewController = TaskRouter.createModule(task: task, taskContent: taskContent)
        navigationController?.pushViewController(taskViewController, animated: true)
    }
    
    func showSettingsScreen(navigationController: UINavigationController?) {
        let settingsViewController = SettingsRouter.createModule()
        navigationController?.pushViewController(settingsViewController, animated: true)
    }
    

    static func createModule(token:Token?) -> MainViewController {
        let mainViewController = MainViewController()
        mainViewController.token = token
        
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
