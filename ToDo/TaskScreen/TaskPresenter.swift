import Foundation

final class TaskPresenter:ViewToPresenterTaskProtocol {
    var view: PresenterToViewTaskProtocol?
    var router: PresenterToRouterTaskProtocol?
    var interactor: PresenterToInteractorTaskProtocol?
    
    
}

extension TaskPresenter:InteractorToPresenterTaskProtocol {
    
}
