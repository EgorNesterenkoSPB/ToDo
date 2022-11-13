import UIKit

//MARK: - View Input (View -> Presenter)
protocol ViewToPresenterProfileProtocol {
    var view: PresenterToViewProfileProtocol? {get set}
    var router: PresenterToRouterProfileProtocol? {get set}
    var interactor: PresenterToInteractorProfileProtocol? {get set}
    func userTapProfileButton(profileViewController:ProfileViewController,accountImageButton: UIButton)
    func didFinishPickingMediaWithInfo(info:[UIImagePickerController.InfoKey : Any],picker: UIImagePickerController,accountImageButton: UIButton)
    func viewDidLoad(accountImageButton:UIButton)
    func showLogoutAlert(profileViewController:ProfileViewController,navigationController:UINavigationController?)
    func takePincode(textField:UITextField)
    func confirmButtonTapped()
    func checkDataState()
}

//MARK: - View Output (Presenter -> View)
protocol PresenterToViewProfileProtocol {
    func enabledConfirmButton()
    func disableConfirmButton()
    func removeTextFromPincodeTextField()
}

//MARK: -  Interactor Input (Presenter -> Interactor)
protocol PresenterToInteractorProfileProtocol {
    var presenter:InteractorToPresenterProfileProtocol? {get set}
    func removeEnteredUserDefKey()
    func storeLocalPincode(pincode:String)
}

//MARK: - Interactor Output (Interactor -> Presenter)
protocol InteractorToPresenterProfileProtocol {

}

//MARK: - Router Input (Presenter -> Router)
protocol PresenterToRouterProfileProtocol {
    static func createModule() -> ProfileViewController
    func onLogout(navigationController:UINavigationController?)
}
