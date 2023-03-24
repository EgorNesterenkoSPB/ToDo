import UIKit

enum Resources {
    static let noteTextKey = "text"
    static let noteNameKey = "name"
    static let categoriesKeyCoreData = "categories"
    static let coreModelName = "CoreModel"
    static let headerColorIdentefier = "colorHeader"
    static let defaultHexColor = "b8b8b8"
    static let isDarkKeyTheme = "isDark"
    static let exampleNoteKey = "exampleKey"
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
    static let firstMainOnBoardingText = NSLocalizedString("THANK_YOU_FOR_DOWNLOADING", comment: "thank you for downloading")
    static let firstSecondOnBoardingText = NSLocalizedString("CREATE_AND_SAVE_TASKS,_WRITE_NOTES,_CHECK_PRODUCTIVITY_ON_CHARTS", comment: "first description onboarding")
    static let secondMainOnBoardingText = "Management your tasks offline or from account"
    static let secondSecondOnBoardingText = "Login in account or skip without registration"
    static let incomingProjectName = "Incoming"
    static let isIncomingKey = "isIncoming"
    static let taskNameKey = "name"
    static let taskDescriptionKey = "descriptionTask"
    static let taskDateKey = "time"
    static let avenirFontName = "Avenir Next Demi Bold"
    
    static let colorsData = [Color(hex: "b8256f", name: "Berry red"),Color(hex: "db4035", name: "Red"),Color(hex: "ff9933", name: "Orange"),Color(hex: "fad000", name: "Yellow"),Color(hex: "afb83b", name: "Olive green"),Color(hex: "7ecc49", name: "Lime green"),Color(hex: "299438", name: "Green"),Color(hex: "6accbc", name: "Mint green"),Color(hex: "158fad", name: "Teal"),Color(hex: "14aaf5", name: "Sky blue"),Color(hex: "96c3eb", name: "Light blue"),Color(hex: "4073ff", name: "Blue"),Color(hex: "884dff", name: "Grape"),Color(hex: "af38eb", name: "Violet"),Color(hex: "eb96eb", name: "Lavender"),Color(hex: "e05194", name: "Magenta"),Color(hex: "ff8d85", name: "Salmon"),Color(hex: "808080", name: "Charcoal"),Color(hex: "b8b8b8", name: "Grey"),Color(hex: "ccac93", name: "Taupe")]
    
    static let projectsModels:[CommonCellOption] = [CommonCellOption(title: Resources.incomingProjectName, icon: UIImage(systemName: Resources.Images.incoming,withConfiguration: Resources.Configurations.largeConfiguration), iconBackgroundColor: UIColor.blue, handler: {}), CommonCellOption(title: Resources.Titles.calendar, icon: UIImage(systemName: Resources.Images.calendar,withConfiguration: Resources.Configurations.largeConfiguration), iconBackgroundColor: UIColor.purple, handler: {}),CommonCellOption(title: Resources.Titles.productivity, icon: UIImage(systemName: Resources.Images.chartBar,withConfiguration: Resources.Configurations.largeConfiguration), iconBackgroundColor: UIColor.systemGreen, handler: {}) ,CommonCellOption(title: Resources.Titles.myNotesTitle, icon: UIImage(systemName: Resources.Images.folderFill, withConfiguration: Resources.Configurations.largeConfiguration), iconBackgroundColor: UIColor.systemIndigo, handler: {})]
    
//    static let settingsContent:[Section] = [Section(title: "", options: [CommonCellOption(title: Resources.Titles.account, icon: UIImage(systemName: Resources.Images.profileImage), iconBackgroundColor: .gray, handler: {}),CommonCellOption(title: Resources.Titles.writeInSupport, icon: UIImage(systemName: Resources.Images.mail), iconBackgroundColor: .systemIndigo, handler: {})])]
    
    static let settingsContentDemo:[Section] = [Section(title: "", options: [CommonCellOption(title: Resources.Titles.writeInSupport, icon: UIImage(systemName: Resources.Images.mail), iconBackgroundColor: .systemIndigo, handler: {})])]
    
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
        static let color = NSLocalizedString("COLOR", comment: "color")
        static let createNote = NSLocalizedString("CREATE_NOTE", comment: "create note")
        static let done = NSLocalizedString("DONE", comment: "done")
        static let addPhoto = NSLocalizedString("ADD_PHOTO", comment: "add photo")
        static let close = NSLocalizedString("CLOSE", comment: "close")
        static let example = NSLocalizedString("EXAMPLE", comment: "example")
        static let select = NSLocalizedString("SELECT", comment: "select")
        static let unselect = NSLocalizedString("UNSELECT", comment: "unselect")
        static let myNotesTitle = NSLocalizedString("MY_NOTES", comment: "my notes")
        static let applicationName = "WriteMe: Notebook"
        static let confirmButtonTitle = NSLocalizedString("CONFIRM", comment: "confirm")
        static let bottomSheetMainLabel = NSLocalizedString("NEW_TASK", comment: "new task")
        static let loginTitle = NSLocalizedString("LOGIN", comment: "login")
        static let registerTopTitle = NSLocalizedString("REGISTER", comment: "register")
        static let signInTitle = NSLocalizedString("SIGNIN", comment: "signin")
        static let registerButtonTitle = NSLocalizedString("REGISTER", comment: "register")
        static let skipRegistrationButtonTitle = NSLocalizedString("SKIP_REGISTRATION", comment: "skip registration")
        static let loginLabel = NSLocalizedString("LOGIN:", comment: "login:")
        static let mailLabel = NSLocalizedString("MAIL:", comment: "mail:")
        static let passwordLabel = NSLocalizedString("PASSWORD:", comment: "password:")
        static let confirmPasswordLabel = NSLocalizedString("CONFIRM_PASSWORD:", comment: "confirm password")
        static let errorTitle = NSLocalizedString("ERROR", comment: "error")
        static let okActionTitle = "OK"
        static let loginOrMailTitle = NSLocalizedString("LOGIN/MAIL:", comment: "login or mail")
        static let cancelButton = NSLocalizedString("CANCEL", comment: "cancel")
        static let createProjectTitle = NSLocalizedString("NEW_PROJECT", comment: "new project")
        static let addToFavorite = NSLocalizedString("ADD_TO_FAVORITE", comment: "add to favorite")
        static let favoriteSection = NSLocalizedString("FAVORITE", comment: "favorite")
        static let projectsSection = NSLocalizedString("PROJECTS", comment: "projects")
        static let addCategory = NSLocalizedString("ADD_CATEGORY", comment: "add category")
        static let addTask = NSLocalizedString("ADD_TASK", comment: "add task")
        static let today = NSLocalizedString("TODAY", comment: "today")
        static let createCategory = NSLocalizedString("CREATE_CATEGORY", comment: "create category")
        static let writeName = NSLocalizedString("WRITE_NAME", comment: "write name")
        static let name = NSLocalizedString("NAME", comment: "name")
        static let create = NSLocalizedString("CREATE", comment: "create")
        static let categoriesTitle = NSLocalizedString("CATEGORIES:", comment: "categories:")
        static let deleteProject = NSLocalizedString("DELETE_PROJECT", comment: "delete project")
        static let deleteAllCategories = NSLocalizedString("DELETE_ALL_CATEGORIES", comment: "delete all categories")
        static let account = NSLocalizedString("ACCOUNT", comment: "account")
        static let support = NSLocalizedString("SUPPORT", comment: "support")
        static let colorTheme = NSLocalizedString("DARK_THEME", comment: "dark theme")
        static let settings = NSLocalizedString("SETTINGS", comment: "settings")
        static let labelAndTintColor = "labelColor"
        static let logout = NSLocalizedString("LOGOUT", comment: "logout")
        static let pincode = NSLocalizedString("PINCODE:", comment: "pincode:")
        static let changePincode = NSLocalizedString("CHANGE_PINCODE:", comment: "change pincode")
        static let deleteAccount = NSLocalizedString("DELETE_ACCOUNT", comment: "delete account")
        static let confirmAction = NSLocalizedString("ARE_YOU_SURE_?", comment: "are you sure?")
        static let renameProject = NSLocalizedString("RENAME_PROJECT", comment: "rename project")
        static let newName = NSLocalizedString("NEW_NAME", comment: "new name")
        static let renameSection = NSLocalizedString("RENAME_SECTION", comment: "rename section")
        static let deleteSection = NSLocalizedString("DELETE_SECTION", comment: "delete section")
        static let showFinishedTasks = NSLocalizedString("SHOW_FINISHED_TASKS", comment: "show finished tasks")
        static let hideFinishedTasks = NSLocalizedString("HIDE_FINISHED_TASKS", comment: "hide finished tasks")
        static let changeProjectColor = NSLocalizedString("CHANGE_PROJECT_COLOR", comment: "change project color")
        static let deleteDate = NSLocalizedString("DELETE_DATE", comment: "delete date")
        static let setDate = NSLocalizedString("SET_DATE", comment: "set date")
        static let setTime = NSLocalizedString("SET_TIME", comment: "set time")
        static let writeInSupport = NSLocalizedString("WRITE_IN_SUPPORT", comment: "write in support")
        static let mailServiceError = NSLocalizedString("MAIL_SERVICES_ARE_NOT_AVAILABLE", comment: "mail service not available")
        static let successSavedLetter = NSLocalizedString("THE_LETTER_WAS_SAVED", comment: "the letter was saved")
        static let successSendLetter =  NSLocalizedString("THE_LETTER_WAS_SENT", comment: "the letter was sent")
        static let failedSendLetter = NSLocalizedString("FAILED_TO_SEND_THE_LETTER,TRY_AGAIN!", comment: "failed to send the letter try again")
        static let unknownError = NSLocalizedString("UNKWOWN_FEATURE", comment: "unknown feature")
        static let forgotPassword = NSLocalizedString("FORGOT_PASSWORD", comment: "forgot password")
        static let removeFromFavorites = NSLocalizedString("REMOVE_FROM_FAVORITES", comment: "remove from favorites")
        static let skip = NSLocalizedString("SKIP", comment: "skip")
        static let back = NSLocalizedString("BACK", comment: "back")
        static let next = NSLocalizedString("NEXT", comment: "next")
        static let getStarted = NSLocalizedString("GET_STARTED", comment: "get started")
        static let calendar = NSLocalizedString("CALENDAR", comment: "calendar")
        static let openCalendar = NSLocalizedString("OPEN_CALENDAR", comment: "open calendar")
        static let hideCalendar = NSLocalizedString("HIDE_CALENDAR", comment: "hide calendar")
        static let productivity = NSLocalizedString("PRODUCTIVITY", comment: "productivity")
        static let pieChartNoData = NSLocalizedString("FINISH_ANY_TASK", comment: "finish any task")
        static let pieChartCenterText = NSLocalizedString("COUNT_OF_FINISHED_TASKS", comment: "count of finished tasks")
        static let chooseFromGallery = NSLocalizedString("CHOOSE_FROM_PHOTO_GALLERY", comment: "choose from photo gallery")
        static let takePhoto = NSLocalizedString("TAKE_PHOTO", comment: "take photo")
        static let createTask = NSLocalizedString("CREATE_TASK", comment: "create task")
        static let welcome = NSLocalizedString("WELCOME", comment: "welcome")
        static let secondTextOnboarding = NSLocalizedString("USE_DIFFERENT_PROJECTS_TO_MANAGE_YOUR_TASKS_AND_KEEP_TRACK_THEIR_ON_CALENDAR", comment: "second text")
        static let overdue = NSLocalizedString("OVERDUE", comment: "overdue")
    }
    enum Placeholders {
        static let textViewPlaceholder = NSLocalizedString("DESCRIPTION", comment: "description")
        static let textFieldPlaceholder = NSLocalizedString("TITLE", comment: "title")
        static let mailTextField = NSLocalizedString("MAIL", comment: "mail")
        static let passwordTextField = NSLocalizedString("PASSWORD", comment: "password")
        static let confirmPassword = NSLocalizedString("CONFIRM_PASSWORD", comment: "confirm password")
        static let loginOrMailTextField = NSLocalizedString("WRITE_LOGIN_OR_MAIL", comment: "write login or mail")
        static let pincodeTextField = NSLocalizedString("LENGTH_IS_4_SYMBOL", comment: "length is 4 symbol")
        static let noteTextViewPlaceholder = NSLocalizedString("WRITE_ANYTHINK_HERE", comment: "write anythink here")
    }
    enum Images {
        static let noData = "noData"
        static let checkmark = "checkmark"
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
        static let noteListCellIdentefier = "noteCell"
        static let photoCellIdentefier = "photoCell"
    }
}


