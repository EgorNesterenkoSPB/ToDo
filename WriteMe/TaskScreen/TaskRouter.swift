import UIKit
import CoreData

final class TaskRouter:PresenterToRouterTaskProtocol {
    static func createModule(task: NSManagedObject,taskContent:TaskContent) -> TaskViewController {
        let taskViewController = TaskViewController(task: task, taskContent: taskContent)
        
        let taskPresenter: (ViewToPresenterTaskProtocol & InteractorToPresenterTaskProtocol) = TaskPresenter()
        
        taskViewController.presenter = taskPresenter
        taskViewController.presenter?.view = taskViewController
        taskViewController.presenter?.interactor = TaskInteractor()
        taskViewController.presenter?.router = TaskRouter()
        taskViewController.presenter?.interactor?.presenter = taskPresenter
        return taskViewController
    }
    
    
}
