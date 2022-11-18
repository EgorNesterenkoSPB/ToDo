import Foundation

enum ValidationErrors:Error {
    case emptyLogin
    case emptyPassword
}

extension ValidationErrors: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .emptyLogin:
            return "the login field is empty!"
        case .emptyPassword:
            return "the password field is empty!"
        }
    }
}
