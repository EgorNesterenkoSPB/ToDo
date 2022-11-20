import UIKit

final class SignInViewController:BaseViewController {
    var presenter: (ViewToPresenterSignInProtocol & InteractorToPresenterSignInProtocol)?
    let loginOrMailLabel = UILabel()
    let loginOrMailTextField = UITextField()
    let passwordLabel = UILabel()
    let passwordTextField = UITextField()
    let confirmButton = UIButton()
    let scrollView = UIScrollView()
    
}

extension SignInViewController {
    
    override func addViews() {
        self.view.addView(scrollView)
        scrollView.addSubview(loginOrMailLabel)
        scrollView.addSubview(loginOrMailTextField)
        scrollView.addSubview(passwordLabel)
        scrollView.addSubview(passwordTextField)
        scrollView.addSubview(confirmButton)
    }
    
    override func layoutViews() {
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 0),
            scrollView.leftAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leftAnchor, constant: 0),
            scrollView.rightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.rightAnchor, constant: 0),
            scrollView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: 0),
            loginOrMailTextField.centerYAnchor.constraint(equalTo: scrollView.centerYAnchor, constant: -50),
            loginOrMailTextField.rightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.rightAnchor,constant: -10),
            loginOrMailTextField.heightAnchor.constraint(equalToConstant: 30),
            loginOrMailTextField.leftAnchor.constraint(equalTo: loginOrMailLabel.rightAnchor, constant: 10),
            loginOrMailTextField.widthAnchor.constraint(equalToConstant: 200),
            loginOrMailLabel.centerYAnchor.constraint(equalTo: loginOrMailTextField.centerYAnchor),
            loginOrMailLabel.leftAnchor.constraint(equalTo: scrollView.leftAnchor,constant: 20),
            passwordTextField.rightAnchor.constraint(equalTo: loginOrMailTextField.rightAnchor),
            passwordTextField.leftAnchor.constraint(equalTo: loginOrMailTextField.leftAnchor),
            passwordTextField.topAnchor.constraint(equalTo: loginOrMailTextField.bottomAnchor,constant: 20),
            passwordTextField.heightAnchor.constraint(equalTo: loginOrMailTextField.heightAnchor),
            passwordLabel.centerYAnchor.constraint(equalTo: passwordTextField.centerYAnchor),
            passwordLabel.leftAnchor.constraint(equalTo: loginOrMailLabel.leftAnchor),
            confirmButton.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor,constant: 20),
            confirmButton.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor)
        ])
    }
    
    override func configure() {
        super.configure()
        title = Resources.Titles.signInTitle
        
        scrollView.contentSize = CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        scrollView.showsVerticalScrollIndicator = false
        
        self.configureTextField(textField: loginOrMailTextField, placeholderText: Resources.Placeholders.loginOrMailTextField)
        self.configureTextField(textField: passwordTextField, placeholderText: Resources.Placeholders.passwordTextField,isSecury: true)
        
        self.configureLabel(label: loginOrMailLabel, text: Resources.Titles.loginOrMailTitle)
        self.configureLabel(label: passwordLabel, text: Resources.Titles.passwordLabel)
        
        self.configureConfirmButton(confirmButton: confirmButton)
        
        loginOrMailTextField.textContentType = .username
        loginOrMailTextField.delegate = self
        loginOrMailTextField.returnKeyType = .next
        passwordTextField.delegate = self
        passwordTextField.textContentType = .password
        passwordTextField.returnKeyType = .done
        
    }
}

extension SignInViewController:PresenterToViewSignInProtocol {
    
}

extension SignInViewController:UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case loginOrMailTextField:
            passwordTextField.becomeFirstResponder()
        case passwordTextField:
            passwordTextField.resignFirstResponder()
        default:
            break
        }
        
        return true
    }
    
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
    }
}
