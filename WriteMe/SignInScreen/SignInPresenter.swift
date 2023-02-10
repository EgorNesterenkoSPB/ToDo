import UIKit

final class SignInPresenter:ViewToPresenterSignInProtocol {
        
    var interactor: PresenterToInteractorSignInProtocol?
    var view: PresenterToViewSignInProtocol?
    var router: PresenterToRouterSignInProtocol?
    var authBody = AuthBody(username: "", password: "")
    
    func setLogin(login: String?) {
        guard let login = login, !login.isEmpty else {
            self.authBody.username = ""
            view?.disableConfirmButton()
            return
        }
        self.authBody.username = login
    }
    
    func setPassword(password: String?) {
        guard let password = password,!password.isEmpty else {
            self.authBody.password = ""
            view?.disableConfirmButton()
            return
        }
        self.authBody.password = password
    }
    
    func checkFields() {
        if authBody.username != "" && authBody.password != "" {
            view?.unableConfirmButton()
        }
        else {
            view?.disableConfirmButton()
        }
    }
    
    func userTapConfirmButton(navigationController: UINavigationController?) {
        interactor?.loginUser(authBody: self.authBody, navigationController: navigationController)
    }
    
    func userTapQuestionButton(questionButton: UIButton, signinViewController: SignInViewController,presentedViewController:UIViewController?) {
        let popOverViewController = SignInPopOverViewController()
        popOverViewController.modalPresentationStyle = .popover
        popOverViewController.preferredContentSize = CGSize(width: popOverViewController.contentTableView.contentSize.width, height: 50)
        
        guard let presentationViewController = popOverViewController.popoverPresentationController else {return}
        presentationViewController.delegate = signinViewController
        presentationViewController.sourceView = questionButton
        presentationViewController.permittedArrowDirections = .down
        presentationViewController.sourceRect = CGRect(x: questionButton.bounds.midX, y: questionButton.bounds.minY - 5, width: 0, height: 0)
        presentationViewController.passthroughViews = [questionButton]
        
        if let image = questionButton.imageView?.image, image == UIImage(systemName: Resources.Images.questionFill,withConfiguration: Resources.Configurations.largeConfiguration) {
            questionButton.setImage(UIImage(systemName: Resources.Images.xCircleFill,withConfiguration: Resources.Configurations.largeConfiguration), for: .normal)
            signinViewController.present(popOverViewController,animated: true)
        } else {
            questionButton.setImage(UIImage(systemName: Resources.Images.questionFill,withConfiguration: Resources.Configurations.largeConfiguration), for: .normal)
            presentedViewController?.dismiss(animated: true, completion:nil)
        }
    }
    
}

extension SignInPresenter:InteractorToPresenterSignInProtocol {
    func succussfulyLogin(token:Token,navigationController: UINavigationController?) {
        router?.openMainScreen(navigationController: navigationController, token: token)
    }
    
    func failedLogin(errorText: String) {
        view?.onFailedLogin(errorText: errorText)
    }
    
    
}
