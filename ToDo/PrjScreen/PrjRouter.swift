import UIKit

final class PrjRouter:PresenterToRouterPrjProtocol {
    func onShowCreateCommonTaskViewController(project: ProjectCoreData,prjViewController:PrjViewController) {
        let createCommonTaskViewController = CreateCommonTaskRouter.createModule(project: project)
        createCommonTaskViewController.modalPresentationStyle = .overCurrentContext
        createCommonTaskViewController.delegate = prjViewController
        prjViewController.present(createCommonTaskViewController,animated: false)
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
