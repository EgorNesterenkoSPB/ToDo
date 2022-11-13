import UIKit

class RegisterViewController: BaseViewController {
    var presenter:(ViewToPresenterRegisterProtocol & InteractorToPresenterRegisterProtocol)?
    
    let scrollView = UIScrollView()
    let loginTextField = ShakingTextField()
    let mailTextField = ShakingTextField()
    let passwordTextField = ShakingTextField()
    let confirmPasswordTextField = ShakingTextField()
    let loginLabel = UILabel()
    let mailLabel = UILabel()
    let passwordLabel = UILabel()
    let confirmPasswordLabel = UILabel()
    let confirmButton = LoaderButton()
    let errorLabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

extension RegisterViewController {
    
    
    override func addViews() {
        self.view.addView(scrollView)
        scrollView.addSubview(loginLabel)
        scrollView.addSubview(loginTextField)
        scrollView.addSubview(mailLabel)
        scrollView.addSubview(mailTextField)
        scrollView.addSubview(passwordLabel)
        scrollView.addSubview(passwordTextField)
        scrollView.addSubview(confirmPasswordLabel)
        scrollView.addSubview(confirmPasswordTextField)
        scrollView.addSubview(confirmButton)

    }
    
    override func configure() {
        super.configure()
        title = Resources.Titles.registerTopTitle
        
        scrollView.contentSize = CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        scrollView.showsVerticalScrollIndicator = false
        
        self.configureLabel(label: loginLabel, text: Resources.Titles.loginLabel)
        self.configureLabel(label: mailLabel, text: Resources.Titles.mailLabel)
        self.configureLabel(label: passwordLabel, text: Resources.Titles.passwordLabel)
        self.configureLabel(label: confirmPasswordLabel, text: Resources.Titles.confirmPasswordLabel)
        
        self.configureTextField(textField: loginTextField, placeholderText: Resources.Titles.loginTitle)
        self.configureTextField(textField: mailTextField, placeholderText: Resources.Placeholders.mailTextField)
        self.configureTextField(textField: passwordTextField, placeholderText: Resources.Placeholders.passwordTextField,isSecury: true)
        self.configureTextField(textField: confirmPasswordTextField, placeholderText: Resources.Placeholders.passwordTextField,isSecury: true)
        
        self.loginTextField.delegate = self
        self.mailTextField.delegate = self
        self.passwordTextField.delegate = self
        self.confirmPasswordTextField.delegate = self
                
        self.configureConfirmButton(confirmButton: confirmButton)
        confirmButton.addTarget(self, action: #selector(confirmButtonTapped), for: .touchUpInside)
    }
    
    override func layoutViews() {
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 0),
            scrollView.leftAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leftAnchor, constant: 0),
            scrollView.rightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.rightAnchor, constant: 0),
            scrollView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: 0),
            loginTextField.centerYAnchor.constraint(equalTo: scrollView.centerYAnchor, constant: -50),
            loginTextField.rightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.rightAnchor,constant: -10),
            loginTextField.heightAnchor.constraint(equalToConstant: 30),
           loginTextField.leftAnchor.constraint(equalTo: loginLabel.rightAnchor, constant: 10),
            loginTextField.widthAnchor.constraint(equalToConstant: 200),
            loginLabel.centerYAnchor.constraint(equalTo: loginTextField.centerYAnchor),
            loginLabel.leftAnchor.constraint(equalTo: scrollView.leftAnchor,constant: 20),
            mailTextField.rightAnchor.constraint(equalTo: loginTextField.rightAnchor),
            mailTextField.leftAnchor.constraint(equalTo: loginTextField.leftAnchor),
            mailTextField.topAnchor.constraint(equalTo: loginTextField.bottomAnchor,constant: 20),
            mailTextField.heightAnchor.constraint(equalTo: loginTextField.heightAnchor),
            mailLabel.centerYAnchor.constraint(equalTo: mailTextField.centerYAnchor),
            mailLabel.leftAnchor.constraint(equalTo: loginLabel.leftAnchor),
            mailLabel.rightAnchor.constraint(equalTo: loginTextField.leftAnchor,constant: -5),
            passwordTextField.rightAnchor.constraint(equalTo: loginTextField.rightAnchor),
            passwordTextField.leftAnchor.constraint(equalTo: loginTextField.leftAnchor),
            passwordTextField.topAnchor.constraint(equalTo: mailTextField.bottomAnchor,constant: 20),
            passwordTextField.heightAnchor.constraint(equalTo: loginTextField.heightAnchor),
            passwordLabel.centerYAnchor.constraint(equalTo: passwordTextField.centerYAnchor),
            passwordLabel.leftAnchor.constraint(equalTo: loginLabel.leftAnchor),
            passwordLabel.rightAnchor.constraint(equalTo: passwordTextField.leftAnchor,constant: -5),
            confirmPasswordTextField.rightAnchor.constraint(equalTo: loginTextField.rightAnchor),
            confirmPasswordTextField.leftAnchor.constraint(equalTo: loginTextField.leftAnchor),
            confirmPasswordTextField.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor,constant: 20),
            confirmPasswordTextField.heightAnchor.constraint(equalTo: loginTextField.heightAnchor),
            confirmPasswordLabel.centerYAnchor.constraint(equalTo: confirmPasswordTextField.centerYAnchor),
            confirmPasswordLabel.leftAnchor.constraint(equalTo: loginLabel.leftAnchor),
            confirmButton.topAnchor.constraint(equalTo: confirmPasswordTextField.bottomAnchor,constant: 20),
            confirmButton.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor)
        ])
    }
}


extension RegisterViewController {
    @objc private func confirmButtonTapped(_ sender:UIButton) {
        self.removeErrorState()
        confirmButton.isLoading = true
        presenter?.userTapConfirmButton()
    }
}


//MARK: - TextFieldDelegate
extension RegisterViewController:UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        switch textField {
        case loginTextField:
            presenter?.setLogin(login: textField.text)
        case mailTextField:
            presenter?.setMail(mail: textField.text)
        case passwordTextField:
            presenter?.setPassword(password: textField.text)
        case confirmPasswordTextField:
            presenter?.checkConfirmPassword(confirmPassword: textField.text)
        default:
            return
        }
    }
    
}

//MARK: - PresenterToView
extension RegisterViewController:PresenterToViewRegisterProtocol {
    func onFailureRegistered(errorText: String) {
        confirmButton.isLoading = false
        present(createErrorAlert(errorText: errorText),animated: true)
    }
    
    func enableConfirmButton() {
        self.confirmButton.isEnabled = true
        self.confirmButton.backgroundColor = .systemOrange
    }
    
    func errorRegister(errorText: String,errorType:ErrorType) {
        switch errorType {
        case .login:
            loginTextField.shake()
        case .mail:
            mailTextField.shake()
        case .password:
            passwordTextField.shake()
        }
        
        self.setupErrorLabel(errorText: errorText)
        self.disableConfirmButton()
    }
    
    func errorSimilarPassword() {
        self.confirmPasswordTextField.layer.borderColor = UIColor.red.cgColor
        self.confirmPasswordTextField.shake()
        self.disableConfirmButton()
    }
}

extension RegisterViewController {
    private func setupErrorLabel(errorText:String) {
        errorLabel.translatesAutoresizingMaskIntoConstraints = false
        errorLabel.text = errorText
        errorLabel.textColor = .red
        errorLabel.font = .systemFont(ofSize: 15)
        self.scrollView.addSubview(errorLabel)
        
        NSLayoutConstraint.activate([
            errorLabel.centerXAnchor.constraint(equalTo: self.confirmButton.centerXAnchor),
            errorLabel.topAnchor.constraint(equalTo: self.confirmButton.bottomAnchor, constant: 15)
        ])
    }
    
    private func removeErrorState() {
        self.errorLabel.removeFromSuperview()
        self.confirmPasswordTextField.layer.borderColor = UIColor.black.cgColor
        self.confirmPasswordTextField.placeholder = Resources.Placeholders.passwordTextField
    }
    
    private func disableConfirmButton() {
        confirmButton.isEnabled = false
        confirmButton.backgroundColor = .gray
    }
}
