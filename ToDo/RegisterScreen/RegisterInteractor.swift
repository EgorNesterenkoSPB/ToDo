import Foundation

final class RegisterIneractor:PresenterToInteractorRegisterProtocol {
    
    var presenter: InteractorToPresenterRegisterProtocol?
    
    func registeringUser(user: RegisterUser) {
        let url = URL(string: Resources.Links.PostRequestURL)!
        let registerRequest = RegisterRequest()
        registerRequest.postRequest(parameters: ["login":user.login,"mail":user.mail,"password":user.password], url: url) {statusCode, errorText in
            if let errorText = errorText {
                DispatchQueue.main.async {
                    self.presenter?.failureRegistered(errorText: errorText)
                }
                return
            }
            else if statusCode != nil {
                DispatchQueue.main.async {
                    self.presenter?.successfulyRegistered()
                }
                return
            }
        }
    }
}
