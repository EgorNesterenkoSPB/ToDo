import UIKit

enum Resources {
    static let categoriesKeyCoreData = "categories"
    static let coreModelName = "CoreModel"
    static let headerColorIdentefier = "colorHeader"
    static let defaultHexColor = "b8b8b8"
    static let isDarkKeyTheme = "isDark"
    static let pincodeKey = "pincodeKey"
    static let isEnteredApplication = "isEntered"
    static let imageProfilePathKey = "imagePath"
    static let textFieldBackColor = "textFieldBackground"
    static let numberOfPincodeDigit = 4
    static let pincodeErrorText = "The pincode is wrong, try again!"
    static let projectNameKey = "name"
    static let categoryNameKey = "name"
    static let isFinishedTaskKey = "isFinished"
    static let timeFinishedTaskKey = "timeFinished"
    static let favoriteProjectKey = "isFavorite"
    static let hexColorProjectKey = "hexColor"
    static let supportMail = "nesterenkoegorbussines@gmail.com"
    static let mailSubject = "HELP!"
    static let lozalizedKey = "Localizable"
    static let launchColorName = "launchColor"
    static let isOnBoardingKey = "onBoarding"
    static let firstMainOnBoardingText = "Thank you for downloading and welcome to Zero notebook!"
    static let firstSecondOnBoardingText = "Create,save tasks, write your personal blog"
    static let secondMainOnBoardingText = "Management your tasks offline or from account"
    static let secondSecondOnBoardingText = "Login in account or skip without registration"
    static let incomingProjectName = "Incoming"
    static let isIncomingKey = "isIncoming"
    static let taskNameKey = "name"
    static let taskDescriptionKey = "descriptionTask"
    static let taskDateKey = "time"
    static let avenirFontName = "Avenir Next Demi Bold"
    
    static let colorsData = [Color(hex: "b8256f", name: "Berry red"),Color(hex: "db4035", name: "Red"),Color(hex: "ff9933", name: "Orange"),Color(hex: "fad000", name: "Yellow"),Color(hex: "afb83b", name: "Olive green"),Color(hex: "7ecc49", name: "Lime green"),Color(hex: "299438", name: "Green"),Color(hex: "6accbc", name: "Mint green"),Color(hex: "158fad", name: "Teal"),Color(hex: "14aaf5", name: "Sky blue"),Color(hex: "96c3eb", name: "Light blue"),Color(hex: "4073ff", name: "Blue"),Color(hex: "884dff", name: "Grape"),Color(hex: "af38eb", name: "Violet"),Color(hex: "eb96eb", name: "Lavender"),Color(hex: "e05194", name: "Magenta"),Color(hex: "ff8d85", name: "Salmon"),Color(hex: "808080", name: "Charcoal"),Color(hex: "b8b8b8", name: "Grey"),Color(hex: "ccac93", name: "Taupe")]
    
    static let projectsModels:[CommonCellOption] = [CommonCellOption(title: Resources.incomingProjectName, icon: UIImage(systemName: Resources.Images.incoming,withConfiguration: Resources.Configurations.largeConfiguration), iconBackgroundColor: UIColor.blue, handler: {}), CommonCellOption(title: Resources.Titles.calendar, icon: UIImage(systemName: Resources.Images.calendar,withConfiguration: Resources.Configurations.largeConfiguration), iconBackgroundColor: UIColor.purple, handler: {}),CommonCellOption(title: Resources.Titles.productivity, icon: UIImage(systemName: Resources.Images.chartBar,withConfiguration: Resources.Configurations.largeConfiguration), iconBackgroundColor: UIColor.systemGreen, handler: {}) ,CommonCellOption(title: Resources.Titles.myBlog, icon: UIImage(systemName: Resources.Images.folderFill, withConfiguration: Resources.Configurations.largeConfiguration), iconBackgroundColor: UIColor.systemIndigo, handler: {})]
    
    static let settingsContent:[Section] = [Section(title: "", options: [CommonCellOption(title: Resources.Titles.account, icon: UIImage(systemName: Resources.Images.profileImage), iconBackgroundColor: .gray, handler: {}),CommonCellOption(title: Resources.Titles.writeInSupport, icon: UIImage(systemName: Resources.Images.mail), iconBackgroundColor: .systemIndigo, handler: {})])]
    
    enum Endpoint {
        static let baseURL: String = "http://127.0.0.1:8003/main/"
        case register
        case login
        case refreshTokens
        case getInfo

        func path() -> String {
            switch self {
            case .register:
                return "user"
            case .login:
                return "token"
            case .refreshTokens:
                return "refresh_tokens"
            case .getInfo:
                return "user"
        }
    }

        var absoluteURL: URL {
    URL(string: Endpoint.baseURL + self.path())!
        }
    }
    
    enum Links {
        static let PostRequestURL = "http://127.0.0.1:8003/main/user"
    }
    enum Configurations {
        static let largeConfiguration = UIImage.SymbolConfiguration(scale: .large)
    }
    enum Titles {
        static let applicationName = "Zero notebook"
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
        static let okActionTitle = "OK"
        static let loginOrMailTitle = "Login/Mail:"
        static let cancelButton = "Cancel"
        static let createProjectTitle = "New project"
        static let addToFavorite = "Add to favorite"
        static let favoriteSection = "Favorite"
        static let projectsSection = "Projects"
        static let addCategory = "Add category"
        static let addTask = "Add task"
        static let today = "Today"
        static let createCategory = "Create category"
        static let writeName = "Write name"
        static let name = "Name"
        static let create = "Create"
        static let categoriesTitle = "Categories:"
        static let deleteProject = "Delete project"
        static let deleteAllCategories = "Delete all categories"
        static let account = "Account"
        static let support = "Support"
        static let colorTheme = "Dark theme"
        static let settings = "Settings"
        static let labelAndTintColor = "labelColor"
        static let logout = "Logout"
        static let pincode = "Pincode:"
        static let changePincode = "Change pincode:"
        static let deleteAccount = "Delete account"
        static let confirmAction = "Are you sure ?"
        static let renameProject = "Rename project"
        static let newName = "New name"
        static let renameSection = "Rename section"
        static let deleteSection = "Delete section"
        static let showFinishedTasks = "Show finished tasks"
        static let hideFinishedTasks = "Hide finished tasks"
        static let changeProjectColor = "Change project color"
        static let deleteDate = "Delete date"
        static let setDate = "Set date"
        static let setTime = "Set time"
        static let writeInSupport = "Write in support"
        static let mailServiceError = "Mail services are not available"
        static let successSavedLetter = "The letter was saved!"
        static let successSendLetter =  "The letter was sent!"
        static let failedSendLetter = "Failed to send the letter,try again!"
        static let unknownError = "Unknown feature"
        static let forgotPassword = "Forgot password"
        static let removeFromFavorites = "Remove from favorites"
        static let skip = "Skip"
        static let back = "Back"
        static let next = "Next"
        static let getStarted = "Get started"
        static let calendar = "Calendar"
        static let myBlog = "My blog"
        static let openCalendar = "Open calendar"
        static let hideCalendar = "Hide calendar"
        static let productivity = "Productivity"
        static let pieChartNoData = "Finish any task"
        static let pieChartCenterText = "Count of finished tasks"
    }
    enum Placeholders {
        static let textViewPlaceholder = "Description"
        static let textFieldPlaceholder = "Title"
        static let mailTextField = "Mail"
        static let passwordTextField = "Password"
        static let confirmPassword = "Confirm password"
        static let loginOrMailTextField = "Write login or mail"
        static let pincodeTextField = "length is 4 symbol"
        
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
        static let trash = "trash"
        static let plusSquare = "plus.square"
        static let edite = "ellipsis"
        static let question = "questionmark.circle"
        static let questionFill = "questionmark.circle.fill"
        static let profileImageFill = "person.crop.circle.fill"
        static let user = "user"
        static let incoming = "tray.fill"
        static let calendar = "calendar"
        static let mail = "envelope.fill"
        static let checkmarkCircleFill = "checkmark.circle.fill"
        static let xCircleFill = "x.circle.fill"
        static let createNote = "square.and.pencil"
        static let folderFill = "folder.fill"
        static let managements = "managements"
        static let blog = "blog"
        static let errorImage = "errorImage"
        static let chartBar = "chart.bar"
    }
    enum Cells {
        static let taskCellIdentefier = "taskCell"
        static let projectCellIdentefier = "projectCell"
        static let colorCellIdentefier = "colorCell"
        static let projectTaskIdentefier = "projectTaskCell"
        static let categoryIdentefier = "categoryCell"
        static let calendarIdentefier = "calendarCell"
        static let commonTableCellIdentefier = "common cell"
        static let commonTaskCellIdentefier = "commonTask cell"
        static let popOverCellIdentegfier = "popOver"
    }
}


