import UIKit
import CoreData

final class PrjRouter:PresenterToRouterPrjProtocol {
    func onShowCreateTaskViewController(projectName: String,projectID:NSManagedObjectID, prjViewController: PrjViewController) {
        let createTaskViewController = CreateTaskRouter.createModule(category: nil, section: nil, projectName: projectName)
        createTaskViewController.projectID = projectID
        createTaskViewController.delegate = prjViewController
        createTaskViewController.modalPresentationStyle = .overCurrentContext
        prjViewController.present(createTaskViewController,animated: false)
    }
    
    func showTaskScreen(task: NSManagedObject, taskContent: TaskContent, navigationController: UINavigationController?) {
        let taskViewController = TaskRouter.createModule(task: task, taskContent: taskContent)
        navigationController?.pushViewController(taskViewController, animated: true)
    }
    
    
    static func createModule(project:ProjectCoreData) -> PrjViewController {
        let prjViewController = PrjViewController(project: project)
        
        let prjPresenter: (ViewToPresenterPrjProtocol & InteractorToPresenterPrjProtocol) = PrjPresenter()
        
        prjViewController.presenter = prjPresenter
        prjViewController.presenter?.view = prjViewController
        prjViewController.presenter?.interactor = PrjInteractor()
        prjViewController.presenter?.router = PrjRouter()
        prjViewController.presenter?.interactor?.presenter = prjPresenter
        return prjViewController
    }
    
    
}
