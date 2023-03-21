import UIKit
import CoreData

final class MainRouter:PresenterToRouterMainProtocol {
    func showTaskScreen(task: NSManagedObject, taskContent: TaskContent, mainViewController:MainViewController) {
        let taskViewController = TaskRouter.createModule(task: task, taskContent: taskContent)
        taskViewController.delegate = mainViewController
        mainViewController.navigationController?.pushViewController(taskViewController, animated: true)
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
        navigationController?.pushViewControllerFromLeft(controller: projectsViewController)
    }
    
    func showCreateTaskViewController(mainViewController: MainViewController) {
        let createTaskViewController = CreateTaskRouter.createModule(category: nil, section: nil, projectName: nil)
        createTaskViewController.modalPresentationStyle = .overCurrentContext
        createTaskViewController.delegate = mainViewController
        mainViewController.present(createTaskViewController,animated: false)
    }

}
