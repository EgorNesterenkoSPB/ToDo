import Foundation

final class ProfileInteractor:PresenterToInteractorProfileProtocol {
    
    var presenter: InteractorToPresenterProfileProtocol?
    lazy var defaults = UserDefaults.standard
    
    func removeEnteredUserDefKey() {
        defaults.removeObject(forKey: Resources.isEnteredApplication)
    }
    
    func storeLocalPincode(pincode: String) {
        defaults.set(pincode, forKey: Resources.pincodeKey)
    }
    
}
