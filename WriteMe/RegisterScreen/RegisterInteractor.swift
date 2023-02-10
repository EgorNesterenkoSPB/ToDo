import Foundation

final class RegisterIneractor:PresenterToInteractorRegisterProtocol {
    
    var presenter: InteractorToPresenterRegisterProtocol?
    
    func registeringUser(user: RegisterBody) {
        
        DispatchQueue.global(qos: .userInitiated).async {
            Requester.shared.register(authBody: user, onResult: {[weak self] result in
                switch result {
                case .success(_):
                    self?.presenter?.successfulyRegistered()
                case .serverError(let err):
                    self?.presenter?.failureRegistered(errorText: Errors.messageFor(err: err.message))
                case .authError(let err):
                    self?.presenter?.failureRegistered(errorText: Errors.messageFor(err: err.message))
                case .networkError(let err):
                    self?.presenter?.failureRegistered(errorText: Errors.messageFor(err: err))
                }
            })
        }
    }
}
