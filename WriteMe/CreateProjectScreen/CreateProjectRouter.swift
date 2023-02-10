import UIKit

final class CreateProjectRouter:PresenterToRouterCreateProjectProtocol{
    static func createModule() -> CreateProjectViewController {
        let createProjectViewController = CreateProjectViewController()
        
        let createProjectPresenter: (ViewToPresenterCreateProjectProtocol & InteractorToPresenterCreateProjectProtocol) = CreateProjectPresenter()
        
        createProjectViewController.presenter = createProjectPresenter
        createProjectViewController.presenter?.view = createProjectViewController
        createProjectViewController.presenter?.interactor = CreateProjectInteractor()
        createProjectViewController.presenter?.router = CreateProjectRouter()
        createProjectViewController.presenter?.interactor?.presenter = createProjectPresenter
        return createProjectViewController
    }
    
    
}
