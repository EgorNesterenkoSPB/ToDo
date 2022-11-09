import Foundation

final class TasksPresenter:ViewToPresenterTasksProtocol {
    var view: PresenterToViewTasksProtocol?    
    var router: PresenterToRouterTasksProtocol?
    var interactor: PresenterToInteractorTasksProtocol?
    
    
}

extension TasksPresenter:InteractorToPresenterTasksProtocol {
    
}
