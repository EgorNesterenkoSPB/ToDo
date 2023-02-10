import Foundation
import UIKit

final class ProfilePresenter:ViewToPresenterProfileProtocol {

    var view: PresenterToViewProfileProtocol?
    var router: PresenterToRouterProfileProtocol?
    var interactor: PresenterToInteractorProfileProtocol?
    lazy var defaults = UserDefaults.standard
    var newPincode:String?
    var newLogin:String?
    var newMail:String?
    var newPassword:String?
    
    func userTapProfileButton(profileViewController: ProfileViewController,accountImageButton: UIButton) {
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        picker.delegate = profileViewController
        
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Take photo", style: .default, handler: { (action:UIAlertAction) -> Void in
            picker.sourceType = .camera
            profileViewController.present(picker,animated: true)
        }))
        alert.addAction(UIAlertAction(title: "Choose from photo gallery", style: .default, handler: { (action:UIAlertAction) -> Void in
            profileViewController.present(picker,animated: true)
        }))
        
        if let _ = defaults.url(forKey: Resources.imageProfilePathKey)?.path {
            alert.addAction(UIAlertAction(title: "Delete current photo", style: .destructive, handler: { [weak self] (action:UIAlertAction) -> Void in
                accountImageButton.setImage(UIImage(named: Resources.Images.user), for: .normal)
                self?.defaults.removeObject(forKey: Resources.imageProfilePathKey)
            }))
        }
        alert.addAction(UIAlertAction(title: Resources.Titles.cancelButton, style: .cancel, handler: nil))
        
        profileViewController.present(alert,animated: true)
    }
    
    func didFinishPickingMediaWithInfo(info: [UIImagePickerController.InfoKey : Any],picker: UIImagePickerController,accountImageButton: UIButton) {
        guard let image = info[.editedImage] as? UIImage else {return}
        let imageName = UUID().uuidString
        let imagePath = getDocumentsDirectory().appendingPathComponent(imageName)
        if let jpegData = image.jpegData(compressionQuality: 0.8) {
            try? jpegData.write(to: imagePath)
            defaults.set(imagePath, forKey: Resources.imageProfilePathKey)
            accountImageButton.setImage(image, for: .normal)
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    func viewDidLoad(accountImageButton: UIButton) {
        if let imagePath = defaults.url(forKey: Resources.imageProfilePathKey)?.path {
            let image = UIImage(contentsOfFile: imagePath)
            accountImageButton.setImage(image, for: .normal)
        }
        
    }
    
    func showLogoutAlert(profileViewController: ProfileViewController, navigationController: UINavigationController?) {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: Resources.Titles.cancelButton, style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: Resources.Titles.logout, style: .destructive, handler: { [weak self] (action:UIAlertAction) -> Void in
            self?.interactor?.removeEnteredUserDefKey()
            self?.router?.onLogout(navigationController: navigationController)
        }))
        profileViewController.present(alert,animated: true)
    }
    
    func takePincode(textField: UITextField) {
        guard let pincode = textField.text, pincode != "", pincode != " ",pincode.count == 4 else {
            return}
        self.newPincode = pincode
        self.checkDataState()
    }
    
    func checkDataState() {
        if newPincode != nil || newLogin != nil || newMail != nil || newPassword != nil {
            view?.enabledConfirmButton()
        }
        else {
            view?.disableConfirmButton()
        }
    }
    
    func confirmButtonTapped() {
        if let newPincode = newPincode {
            interactor?.storeLocalPincode(pincode: newPincode)
            self.newPincode = nil
            view?.removeTextFromPincodeTextField()
        }
    }
}

extension ProfilePresenter:InteractorToPresenterProfileProtocol {
    
}
