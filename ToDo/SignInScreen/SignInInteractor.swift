import UIKit

final class SignInInteractor: PresenterToInteractorSignInProtocol {
    
    var presenter: InteractorToPresenterSignInProtocol?

    func loginUser(authBody: AuthBody,navigationController: UINavigationController?) {
        DispatchQueue.global(qos: .userInitiated).async {
            Requester.shared.login(authBody: authBody, onResult: {[weak self] result in
                switch result {
                case .success(let token):
                    self?.presenter?.succussfulyLogin(token: token, navigationController: navigationController)
                case .serverError(let err):
                    self?.presenter?.failedLogin(errorText: Errors.messageFor(err: err.message))
                case .authError(let err):
                    self?.presenter?.failedLogin(errorText: Errors.messageFor(err: err.message))
                case .networkError(let err):
                    self?.presenter?.failedLogin(errorText: Errors.messageFor(err: err))
                }
            })
        }
    }
    
}
