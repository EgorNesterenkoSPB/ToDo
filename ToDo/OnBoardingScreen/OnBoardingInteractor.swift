import Foundation
import UIKit

final class OnBoardingInteractor:PresenterToInteractorOnBoardingProtocol {
    var presenter: InteractorToPresenterOnBoardingProtocol?
    let defaults = UserDefaults.standard
    let contentOfView = [
        ["image":Resources.Images.blog,"mainText":Resources.firstMainOnBoardingText,"secondText":Resources.firstSecondOnBoardingText],
        ["image":Resources.Images.managements,"mainText":Resources.secondMainOnBoardingText,"secondText":Resources.secondSecondOnBoardingText]]
    
    func setIsOnBoarding(navigationController: UINavigationController?) {
        defaults.setValue(true, forKey: Resources.isOnBoardingKey)
        presenter?.successfulySettedIsOnBoarding(navigationController: navigationController)
    }
    
    func onShowNewViewData(currentPage: Int) {
        
        guard let mainText = contentOfView[currentPage]["mainText"], let secondText = contentOfView[currentPage]["secondText"], let imageName = contentOfView[currentPage]["image"] else {
            self.presenter?.newViewData(mainText: "Error", secondText: "Sorry, something went wrong", imageName: Resources.Images.errorImage, currentPage: currentPage)
            return
        }
        self.presenter?.newViewData(mainText: mainText, secondText: secondText, imageName: imageName, currentPage: currentPage)
    }
    
}
