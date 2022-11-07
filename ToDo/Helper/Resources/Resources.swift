import UIKit

enum Resources {
    static let coreModelName = "CoreModel"
    static let headerColorIdentefier = "colorHeader"
    static let colorsData = [Color(hex: "b8256f", name: "Berry red"),Color(hex: "db4035", name: "Red"),Color(hex: "ff9933", name: "Orange"),Color(hex: "fad000", name: "Yellow"),Color(hex: "afb83b", name: "Olive green"),Color(hex: "7ecc49", name: "Lime green"),Color(hex: "299438", name: "Green"),Color(hex: "6accbc", name: "Mint green"),Color(hex: "158fad", name: "Teal"),Color(hex: "14aaf5", name: "Sky blue"),Color(hex: "96c3eb", name: "Light blue"),Color(hex: "4073ff", name: "Blue"),Color(hex: "884dff", name: "Grape"),Color(hex: "af38eb", name: "Violet"),Color(hex: "eb96eb", name: "Lavender"),Color(hex: "e05194", name: "Magenta"),Color(hex: "ff8d85", name: "Salmon"),Color(hex: "808080", name: "Charcoal"),Color(hex: "b8b8b8", name: "Grey"),Color(hex: "ccac93", name: "Taupe")]
    
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
        static let createProjectTitle = "New project"
        static let addToFavorite = "Add to favorite"
        static let favoriteSection = "Favorite"
        static let projectsSection = "Projects"
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
        static let plusImage = "plus"
        static let settingsImage = "gear"
        static let circle = "circle"
        static let circleFill = "circle.fill"
        static let projectsImage = "text.justify"
        static let heart = "suit.heart"
    }
    enum Cells {
        static let taskCellIdentefier = "taskCell"
        static let projectCellIdentefier = "projectCell"
        static let colorCellIdentefier = "colorCell"
    }
}

enum ErrorType {
    case login
    case mail
    case password
}
