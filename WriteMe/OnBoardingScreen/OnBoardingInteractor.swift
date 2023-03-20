import Foundation
import UIKit

final class OnBoardingInteractor:PresenterToInteractorOnBoardingProtocol {
    var presenter: InteractorToPresenterOnBoardingProtocol?
    let defaults = UserDefaults.standard
//    let contentOfView = [
//        ["image":Resources.Images.blog,"mainText":Resources.firstMainOnBoardingText,"secondText":Resources.firstSecondOnBoardingText],
//        ["image":Resources.Images.managements,"mainText":Resources.secondMainOnBoardingText,"secondText":Resources.secondSecondOnBoardingText]]
    let contentOfViewDemo = [
        ["image":Resources.Images.blog,"mainText":Resources.firstMainOnBoardingText,"secondText":Resources.firstSecondOnBoardingText],
        ["image":Resources.Images.managements,"mainText":"Welcome","secondText":"Use different projects to manage your tasks and keep track their on calendar"]
    ]
    
    func setIsOnBoarding(navigationController: UINavigationController?) {
        defaults.setValue(true, forKey: Resources.isOnBoardingKey)
        presenter?.successfulySettedIsOnBoarding(navigationController: navigationController)
    }
    
    func onShowNewViewData(currentPage: Int) {
        if currentPage <= contentOfViewDemo.count - 1 {
            guard let mainText = contentOfViewDemo[currentPage]["mainText"], let secondText = contentOfViewDemo[currentPage]["secondText"], let imageName = contentOfViewDemo[currentPage]["image"] else {return}
            self.presenter?.newViewData(mainText: mainText, secondText: secondText, imageName: imageName, currentPage: currentPage)
        } else {
            self.presenter?.newViewData(mainText: "Error", secondText: "Sorry, something went wrong", imageName: Resources.Images.errorImage, currentPage: currentPage)
        }
        
//        guard let mainText = contentOfViewDemo[currentPage]["mainText"], let secondText = contentOfViewDemo[currentPage]["secondText"], let imageName = contentOfViewDemo[currentPage]["image"] else {
//            self.presenter?.newViewData(mainText: "Error", secondText: "Sorry, something went wrong", imageName: Resources.Images.errorImage, currentPage: currentPage)
//            return
//        }
//        self.presenter?.newViewData(mainText: mainText, secondText: secondText, imageName: imageName, currentPage: currentPage)
    }
    
}
