import Foundation

final class PrjPresenter:ViewToPresenterPrjProtocol {
    var view: PresenterToViewPrjProtocol?
    var router: PresenterToRouterPrjProtocol?
    var interactor: PresenterToInteractorPrjProtocol?
    
    
}

extension PrjPresenter:InteractorToPresenterPrjProtocol {
    
}
