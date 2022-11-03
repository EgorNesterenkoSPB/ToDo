import Foundation

final class RegisterPresenter:ViewToPresenterRegisterProtocol {
    var view: PresenterToViewRegisterProtocol?
    var router: PresenterToRouterRegisterProtocol?
    var interactor: PresenterToInteractorRegisterProtocol?
    var user = RegisterUser(login: "", mail: "", password: "")
    let registerViewController:RegisterViewController
    
    init(registerViewController:RegisterViewController) {
        self.registerViewController = registerViewController
    }
    
    func setLogin(login: String?) {
        guard let login = login, login != "" && login != " " else {
            view?.errorRegister(errorText: "Login isnt correct", errorType: .login)
            user.login = ""
            return
        }
        self.user.login = login
    }
    
    func setMail(mail: String?) {
        guard let mail = mail, mail != "" && mail != " " else {
            view?.errorRegister(errorText: "Mail isnt correct", errorType: .mail)
            user.mail = ""
            return
        }
        self.user.mail = mail
    }
    
    func setPassword(password: String?) {
        guard let password = password, password != "" && password != " " else {
            view?.errorRegister(errorText: "Password isnt correct", errorType: .password)
            user.password = ""
            return
        }
        self.user.password = password
    }
    
    
    func checkConfirmPassword(confirmPassword: String?) {
        guard let confirmPassword = confirmPassword,confirmPassword != "" && confirmPassword != " " && confirmPassword == self.user.password else {
            view?.errorSimilarPassword()
            return
        }
        view?.enableConfirmButton()
    }
    
    func userTapConfirmButton() {
        interactor?.registeringUser(user: user)
    }
}

extension RegisterPresenter:InteractorToPresenterRegisterProtocol {
    func successfulyRegistered() {
        router?.showSignInScreen(registerViewController: registerViewController)
    }
    
    func failureRegistered(errorText: String) {
        view?.onFailureRegistered(errorText: errorText)
    }
    
    
}
