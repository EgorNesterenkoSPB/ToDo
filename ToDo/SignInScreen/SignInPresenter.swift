import UIKit

final class SignInPresenter:ViewToPresenterSignInProtocol {
    
    var interactor: PresenterToInteractorSignInProtocol?
    var view: PresenterToViewSignInProtocol?
    var router: PresenterToRouterSignInProtocol?
    var authBody = AuthBody(username: "", password: "")
    
    func setLogin(login: String?) {
        guard let login = login, !login.isEmpty else {
            self.authBody.username = ""
            view?.disableConfirmButton()
            return
        }
        self.authBody.username = login
    }
    
    func setPassword(password: String?) {
        guard let password = password,!password.isEmpty else {
            self.authBody.password = ""
            view?.disableConfirmButton()
            return
        }
        self.authBody.password = password
    }
    
    func checkFields() {
        if authBody.username != "" && authBody.password != "" {
            view?.unableConfirmButton()
        }
        else {
            view?.disableConfirmButton()
        }
    }
    
    func userTapConfirmButton(navigationController: UINavigationController?) {
        interactor?.loginUser(authBody: self.authBody, navigationController: navigationController)
    }
    
}

extension SignInPresenter:InteractorToPresenterSignInProtocol {
    func succussfulyLogin(token:Token,navigationController: UINavigationController?) {
        router?.openMainScreen(navigationController: navigationController, token: token)
    }
    
    func failedLogin(errorText: String) {
        view?.onFailedLogin(errorText: errorText)
    }
    
    
}
