import UIKit

enum Resources {
    static let coreModelName = "CoreModel"
    
    enum Links {
        static let PostRequestURL = "http://127.0.0.1:8000/user"
    }
    enum Configurations {
        static let largeConfiguration = UIImage.SymbolConfiguration(scale: .large)
    }
    enum Titles {
        static let confirmButtonTitle = "Confirm"
        static let bottomSheetMainLabel = "New task"
        static let loginTitle = "Login"
        static let registerTopTitle = "Register"
        static let signInTitle = "Sign in"
        static let registerButtonTitle = "Register"
        static let skipRegistrationButtonTitle = "skip registration"
        static let loginLabel = "Login:"
        static let mailLabel = "Mail:"
        static let passwordLabel = "Password:"
        static let confirmPasswordLabel = "Confirm password:"
        static let errorTitle = "Error"
        static let errorActionTitle = "OK"
        static let loginOrMailTitle = "Login/Mail:"
        static let cancelButton = "Cancel"
    }
    enum Placeholders {
        static let textViewPlaceholder = "Description"
        static let textFieldPlaceholder = "Title"
        static let mailTextField = "Mail"
        static let passwordTextField = "Password"
        static let loginOrMailTextField = "Write login or mail"
    }
    enum Images {
        static let createTaskButtonImage = "arrow.up.circle.fill"
        static let chevronDown = "chevron.down"
        static let chevronRight = "chevron.right"
        static let profileImage = "person.crop.circle"
        static let plusImage = "plus.circle"
        static let settingsImage = "gearshape"
    }
    enum Cells {
        static let mainCell = "mainCell"
    }
}

enum ErrorType {
    case login
    case mail
    case password
}
