import Foundation

final class ProfilePresenter:ViewToPresenterProfileProtocol {
    var view: PresenterToViewProfileProtocol?
    var router: PresenterToRouterProfileProtocol?
    var interactor: PresenterToInteractorProfileProtocol?
    
    
}

extension ProfilePresenter:InteractorToPresenterProfileProtocol {
    
}
