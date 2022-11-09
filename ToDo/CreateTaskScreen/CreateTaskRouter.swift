import UIKit

final class CreateTaskRouter:PresenterToRouterCreateTaskProtocol {
    static func createModule() -> CreateTaskViewController {
        let createTaskViewController = CreateTaskViewController()
        
        let createTaskPresenter: (ViewToPresenterCreateTaskProtocol & InteractorToPresenterCreateTaskProtocol) = CreateTaskPresenter()
        
        createTaskViewController.presenter = createTaskPresenter
        createTaskViewController.presenter?.view = createTaskViewController
        createTaskViewController.presenter?.interactor = CreateTaskInteractor()
        createTaskViewController.presenter?.router = CreateTaskRouter()
        createTaskViewController.presenter?.interactor?.presenter = createTaskPresenter
        return createTaskViewController
    }
    
    
}
