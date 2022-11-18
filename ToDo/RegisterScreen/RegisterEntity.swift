import Foundation

struct RegisterUser {
    var login:String
    var mail:String
    var password:String
}

enum ErrorType {
    case login
    case mail
    case password
    case conflictPasswords
}

enum RegisterField {
    case login
    case mail
    case password
    case confirmPassword
}
