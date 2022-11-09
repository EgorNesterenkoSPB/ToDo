import Foundation

final class TasksRouter:PresenterToRouterTasksProtocol {
    static func createModule(category: CategoryCoreData) -> TasksViewController {
        let tasksViewController = TasksViewController(category: category)
        
        let tasksPresenter: (ViewToPresenterTasksProtocol & InteractorToPresenterTasksProtocol) = TasksPresenter()
        
        tasksViewController.presenter = tasksPresenter
        tasksViewController.presenter?.view = tasksViewController
        tasksViewController.presenter?.interactor = TasksInteractor()
        tasksViewController.presenter?.router = TasksRouter()
        tasksViewController.presenter?.interactor?.presenter = tasksPresenter
        
        return tasksViewController
    }
    
    
}
