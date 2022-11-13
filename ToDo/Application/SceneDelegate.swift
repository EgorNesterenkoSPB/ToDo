import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {

        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene)
        window?.rootViewController = NavController(rootViewController: LoginRouter.createModule())
        window?.makeKeyAndVisible()
        
        let defaults = UserDefaults.standard
        let isDark = defaults.bool(forKey: Resources.isDarkKeyTheme)
        if isDark {
            window?.overrideUserInterfaceStyle = .dark
        }
        else {
            window?.overrideUserInterfaceStyle = .light
        }
        
    }
}

