import Foundation

final class SignInPresenter:ViewToPresenterSignInProtocol {
    var interactor: PresenterToInteractorSignInProtocol?
    var view: PresenterToViewSignInProtocol?
    var router: PresenterToRouterSignInProtocol?
    
    
}

extension SignInPresenter:InteractorToPresenterSignInProtocol {
    
}
