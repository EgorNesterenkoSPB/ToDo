import UIKit

final class ProductivityRouter:PresenterToRouterProductivityProtocol {
    static func createModule() -> ProductivityViewController {
        let productivityViewController = ProductivityViewController()
        
        let productivityPresenter: (ViewToPresenterProductivityProtocol & InteractorToPresenterProductivityProtocol) = ProductivityPresenter()
        
        productivityViewController.presenter = productivityPresenter
        productivityViewController.presenter?.view = productivityViewController
        productivityViewController.presenter?.interactor = ProductivityInteractor()
        productivityViewController.presenter?.router = ProductivityRouter()
        productivityViewController.presenter?.interactor?.presenter = productivityPresenter
        return productivityViewController
    }
    
    
}
