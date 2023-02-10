import UIKit

final class LaunchPresenter:ViewToPresenterLaunchProtocol {
    var view: PresenterToViewLaunchProtocol?
    var router: PresenterToRouterLaunchProtocol?
    var interactor: PresenterToInteractorLaunchProtocol?
    var navController:UINavigationController?
    
    func configureShadow(label: UILabel, shadowView: UIView,navigationController:UINavigationController?) {
        self.navController = navigationController
        UIView.animate(withDuration: 0.75, delay: 0, options: .curveLinear) {
            label.alpha = 1
            let trig = self.calcTrig(segment: .h, size: 10, angle: 22.5)
            let x = trig[.x]
            let y = trig[.y]
            label.layer.shadowOffset = CGSize(width: x!, height: y!)
            shadowView.alpha = 0.5
        } completion: { success in
            self.rightBottomShadow(label: label, shadowView: shadowView)
        }
    }

    
}

extension LaunchPresenter {
    private func calcTrig(segment: segment, size: CGFloat, angle: CGFloat) -> [segment : CGFloat] {
        switch segment {
            case .x:
                let x = size
                let y = tan(angle * .pi/180) * x
                let h = x / cos(angle * .pi/180)
                return [ .x : x, .y : y, .h : h]
            case .y:
                let y = size
                let x = y / tan(angle * .pi/180)
                let h = y / sin(angle * .pi/180)
                return [ .x : x, .y : y, .h : h]
            case .h:
                let h = size
                let x = cos(angle * .pi/180) * h
                let y = sin(angle * .pi/180) * h
                return [ .x : x, .y : y, .h : h]
        }
    }
    
    // move shadow to bottom right, light effect view creates light effect
    private func rightBottomShadow(label: UILabel, shadowView: UIView) {
        UIView.animate(withDuration: 0.4, delay: 0, options: .curveLinear) {
            let trig = self.calcTrig(segment: .h, size: 10, angle: 45)
            let x = trig[.x]
            let y = trig[.y]
            label.layer.shadowOffset = CGSize(width: x!, height: y!)
            shadowView.alpha = 0.4
            
        } completion: { success in
            self.halfRightBottomShadow(label: label, shadowView: shadowView)
        }
    }
    
    // move shadow more to the bottom, light eeffect view gets lighter
    private func halfRightBottomShadow(label: UILabel, shadowView: UIView) {
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveLinear) {
            let trig = self.calcTrig(segment: .h, size: 10, angle: 67.5)
            let x = trig[.x]
            let y = trig[.y]
            label.layer.shadowOffset = CGSize(width: x!, height: y!)
            shadowView.alpha = 0.2
        } completion: { success in
            self.bottomShadow(label: label, shadowView: shadowView)
        }
    }
    
    // shadow is at the bottom, light effect view gets slightly darker
    private func bottomShadow(label: UILabel, shadowView: UIView) {
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveLinear) {
            let trig = self.calcTrig(segment: .h, size: 10, angle: 90)
            let x = trig[.x]
            let y = trig[.y]
            label.layer.shadowOffset = CGSize(width: x!, height: y!)
            shadowView.alpha = 0.3
        } completion: { success in
            self.halfLeftBottomShadow(label: label, shadowView: shadowView)
        }
    }
    
    // shadow moves to the left and light effect view makes view darker
    private func halfLeftBottomShadow(label: UILabel, shadowView: UIView) {
        UIView.animate(withDuration: 0.8, delay: 0, options: .curveLinear) {
            let trig = self.calcTrig(segment: .h, size: 10, angle: 112.5)
            let x = trig[.x]
            let y = trig[.y]
            label.layer.shadowOffset = CGSize(width: x!, height: y!)
            shadowView.alpha = 0.5
        } completion: { success in
            self.leftBottomShadow(label: label, shadowView: shadowView)
        }
    }
    
    // shadow moves to the bottom left and light effect view gets dark
    private func leftBottomShadow(label: UILabel, shadowView: UIView) {
        UIView.animate(withDuration: 2, delay: 0, options: .curveEaseOut) {
            let trig = self.calcTrig(segment: .h, size: 10, angle: 135)
            let x = trig[.x]
            let y = trig[.y]
            label.layer.shadowOffset = CGSize(width: x!, height: y!)
            shadowView.alpha = 0.7
        }
        self.interactor?.viewDidLoad(navigationController: self.navController)
    }
}

extension LaunchPresenter:InteractorToPresenterLaunchProtocol {
    func showOnBoardingViewController(navigationController: UINavigationController?) {
        self.router?.onShowOnBoardingViewConroller(navigationController: navigationController)
    }
    
    func showPincodeViewController(navigationController: UINavigationController?) {
        self.router?.onShowPincodeViewController(navigationController: navigationController)
    }
    
    func showLoginViewController(navigationController: UINavigationController?) {
        self.router?.onShowLoginViewController(navigationController: navigationController)
    }
    
    func showMainViewController(navigationController: UINavigationController?) {
        self.router?.onShowMainViewController(navigationController: navigationController)
    }
    
    
}
