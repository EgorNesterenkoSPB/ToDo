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
        guard let login = login, !login.isEmpty else {
            view?.errorRegister(errorText: "login field is empty!", errorType: .login)
            return
        }
        guard login.count > 5 else {
            view?.errorRegister(errorText: "login must be more 5 symbols", errorType: .login)
            return
        }
        view?.validField(field: .login)
        self.user.login = login
    }
    
    func setMail(mail: String?) {
        guard let mail = mail, !mail.isEmpty else {
            view?.errorRegister(errorText: "mail field is empty!", errorType: .mail)
            return
        }
        //TODO: - logic to check valid mail
        
        view?.validField(field: .mail)
        self.user.mail = mail
    }
    
    func setPassword(password: String?) {
        guard let password = password, !password.isEmpty else {
            view?.errorRegister(errorText: "password field is empty!", errorType: .password)
            return
        }
        guard password.count > 6 else {
            view?.errorRegister(errorText: "password must be more 6 symbols!", errorType: .password)
            return
        }
        view?.validField(field: .password)
        self.user.password = password
    }
    
    
    func checkConfirmPassword(confirmPassword: String?) {
        guard let confirmPassword = confirmPassword, confirmPassword == self.user.password else {
            view?.errorRegister(errorText: "passwords dont match", errorType: .conflictPasswords)
            return
        }
        view?.validField(field: .confirmPassword)
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
