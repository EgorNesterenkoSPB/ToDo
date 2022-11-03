import UIKit

final class LoginViewController:BaseViewController {
    var presenter:(ViewToPresenterLoginProtocol & InteractorToPresenterLoginProtocol)?
    
    let signInButton = UIButton()
    let registerButton = UIButton()
    let skipButton = UIButton()
    
    private enum UIConstants {
        static let signinCenterYAnchor = -40.0
        static let registerCenterYAnchor = 40.0
        static let skipButtonTopAnchor = 10.0
        static let skipButtonTitleLabelFont = 15.0
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidLayoutSubviews() {
        signInButton.widthAnchor.constraint(equalToConstant: registerButton.bounds.width).isActive = true
    }
    
}

extension LoginViewController {
    override func addViews() {
        self.view.addView(signInButton)
        self.view.addView(registerButton)
        self.view.addView(skipButton)
    }
    
    override func layoutViews() {
        NSLayoutConstraint.activate([
            signInButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: 0),
            signInButton.centerYAnchor.constraint(equalTo: self.view.centerYAnchor, constant: UIConstants.signinCenterYAnchor),
            registerButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: 0),
            registerButton.centerYAnchor.constraint(equalTo: self.view.centerYAnchor, constant: UIConstants.registerCenterYAnchor),
            skipButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            skipButton.topAnchor.constraint(equalTo: registerButton.bottomAnchor, constant: UIConstants.skipButtonTopAnchor)
        ])
    }
    
    override func configure() {
        title = Resources.Titles.loginTitle
        
        signInButton.addTarget(self, action: #selector(signInButtonTapped), for: .touchUpInside)
        registerButton.addTarget(self, action: #selector(registerButtonTapped), for: .touchUpInside)
        
        self.configureButton(button: signInButton, text: Resources.Titles.signInTitle)
        self.configureButton(button: registerButton, text: Resources.Titles.registerButtonTitle)
        
        skipButton.setTitle(Resources.Titles.skipRegistrationButtonTitle, for: .normal)
        skipButton.setTitleColor(.gray, for: .normal)
        skipButton.titleLabel?.font = .systemFont(ofSize: UIConstants.skipButtonTitleLabelFont)
        skipButton.addTarget(self, action: #selector(skipButtonTapped), for: .touchUpInside)
    }
}

extension LoginViewController {
    private func configureButton(button:UIButton, text:String) {
        button.setTitle(text, for: .normal)
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 8
        button.backgroundColor = .systemOrange
        button.setTitleColor(.white, for: .normal)
        button.contentEdgeInsets = UIEdgeInsets(top: 15, left: 30, bottom: 15, right: 30)
    }
}


extension LoginViewController {
    @objc private func registerButtonTapped(_ sender:UIButton) {
        presenter?.touchRegisterButton(navigationController: navigationController)
    }
    
    @objc private func signInButtonTapped(_ sender:UIButton) {
        presenter?.touchSignInButton(navigationController: navigationController)
    }
    
    @objc private func skipButtonTapped(_ sender:UIButton) {
        presenter?.touchSkipButton(navigationController: navigationController)
    }
}

extension LoginViewController:PresenterToViewLoginProtocol {
    
}
