import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {

        guard let windowScene = (scene as? UIWindowScene) else { return }
        let defaults = UserDefaults.standard
        
        window = UIWindow(windowScene: windowScene)
        let isEntered = defaults.bool(forKey: Resources.isEnteredApplication)
        switch isEntered {
        case true:
            window?.rootViewController = NavController(rootViewController: MainRouter.createModule())
        case false:
            window?.rootViewController = NavController(rootViewController: LoginRouter.createModule())
        }
        window?.makeKeyAndVisible()
        
        let isDark = defaults.bool(forKey: Resources.isDarkKeyTheme)
        switch isDark {
        case true:
            window?.overrideUserInterfaceStyle = .dark
        case false:
            window?.overrideUserInterfaceStyle = .light
        }
        
    }
}

