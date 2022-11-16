import UIKit

final class PincodeViewController:BaseViewController {
    let otpView = OTPView()
}

extension PincodeViewController {
    override func addViews() {
        self.view.addView(otpView)
    }

    
    override func configure() {
        super.configure()
        navigationController?.navigationBar.isHidden = true
        otpView.delegate = self
    }
    
    override func layoutViews() {
        NSLayoutConstraint.activate([
            otpView.centerXAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.centerXAnchor),
            otpView.centerYAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.centerYAnchor),
            otpView.leftAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leftAnchor,constant: 50),
            otpView.rightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.rightAnchor,constant: -50),
            otpView.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
}

extension PincodeViewController:OTPViewProtocol {
    func showErrorAlert(errorText: String) {
        self.present(createErrorAlert(errorText: errorText),animated: true)
    }
    
    func showMainViewController() {
        let mainViewController = MainRouter.createModule()
        navigationController?.setViewControllers([mainViewController], animated: true)
    }
}
