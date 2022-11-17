import UIKit

final class CreateCommonTaskRouter:PresenterToRouterCreateCommonTaskProtocol {
    static func createModule(project:ProjectCoreData) -> CreateCommonTaskViewController {
        let createCommonTaskViewController = CreateCommonTaskViewController(project: project)
        
        let createCommonTaskPresenter: (ViewToPresenterCreateCommonTaskProtocol & InteractorToPresenterCreateCommonTaskProtocol) = CreateCommonTaskPresenter()
        
        createCommonTaskViewController.presenter = createCommonTaskPresenter
        createCommonTaskViewController.presenter?.view = createCommonTaskViewController
        createCommonTaskViewController.presenter?.interactor = CreateCommonTaskInteractor()
        createCommonTaskViewController.presenter?.router = CreateCommonTaskRouter()
        createCommonTaskViewController.presenter?.interactor?.presenter = createCommonTaskPresenter
        return createCommonTaskViewController
    }
    
    
}
