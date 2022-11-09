import UIKit

final class ProfileViewController:BaseViewController {
    var presenter:(ViewToPresenterProfileProtocol & InteractorToPresenterProfileProtocol)?
    
}

extension ProfileViewController:PresenterToViewProfileProtocol {
    
}
