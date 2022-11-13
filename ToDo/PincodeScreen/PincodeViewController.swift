import UIKit

final class PincodeViewController:BaseViewController {
    let otpView = OTPView()
    let confirmButton = UIButton()
}

extension PincodeViewController {
    override func addViews() {
        self.view.addView(otpView)
        self.view.addView(confirmButton)
    }
    
    
    override func configure() {
        super.configure()
        self.configureConfirmButton(confirmButton: confirmButton)
        self.confirmButton.isEnabled = true
        self.confirmButton.backgroundColor = .systemOrange
        confirmButton.addTarget(self, action: #selector(confirmButtonTapped(_:)), for: .touchUpInside)
    }
    
    override func layoutViews() {
        NSLayoutConstraint.activate([
            otpView.centerXAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.centerXAnchor),
            otpView.centerYAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.centerYAnchor),
            otpView.leftAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leftAnchor,constant: 50),
            otpView.rightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.rightAnchor,constant: -50),
            otpView.heightAnchor.constraint(equalToConstant: 50),
            confirmButton.centerXAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.centerXAnchor),
            confirmButton.topAnchor.constraint(equalTo: otpView.bottomAnchor, constant: 20)
        ])
    }
}

extension PincodeViewController {
    @objc private func confirmButtonTapped(_ sender:UIButton) {
        if otpView.pincode.count != 4 {
            let alert = createErrorAlert(errorText: Resources.pincodeErrorText)
            self.present(alert,animated: true)
        }
        else {
            let defaults = UserDefaults.standard
            let pincode = defaults.string(forKey: Resources.pincodeKey)
            guard let pincode = pincode else {
                return
            }
            if otpView.pincode == pincode{
                navigationController?.setViewControllers([MainRouter.createModule()], animated: true)
            }
            else {
                let alert = createErrorAlert(errorText: Resources.pincodeErrorText)
                self.present(alert, animated: true)
            }
        }
    }
}
