import UIKit

final class ProfileViewController:BaseViewController {
    
    let accountImageButton = UIButton()
    let logoutButton = UIButton()
    let deleteAccountButton = UIButton()
    let loginLabel = UILabel()
    let mailLabel = UILabel()
    let passwordLabel = UILabel()
    let pincodeLabel = UILabel()
    let pincodeTextField = UITextField()
    let passwordTextField = UITextField()
    let loginTextField = UITextField()
    let mailTextField = UITextField()
    var presenter:(ViewToPresenterProfileProtocol & InteractorToPresenterProfileProtocol)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //TODO: - Check if user is setted pin code, check if user was login
        presenter?.viewDidLoad(accountImageButton: accountImageButton)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        accountImageButton.imageView?.layer.cornerRadius = accountImageButton.bounds.height / 2.0
    }
}

extension ProfileViewController {
    override func addViews() {
        self.view.addView(accountImageButton)
        self.view.addView(logoutButton)
        self.view.addView(deleteAccountButton)
        self.view.addView(loginLabel)
        self.view.addView(mailLabel)
        self.view.addView(pincodeLabel)
        self.view.addView(pincodeTextField)
        self.view.addView(passwordLabel)
        self.view.addView(passwordTextField)
        self.view.addView(loginTextField)
        self.view.addView(mailTextField)
    }
    
    override func configure() {
        super.configure()
        navigationController?.navigationBar.isHidden = false
        title = Resources.Titles.account
        
        accountImageButton.setImage(UIImage(named: Resources.Images.user), for: .normal)
        accountImageButton.tintColor = UIColor(named: Resources.Titles.labelAndTintColor)
        accountImageButton.addTarget(self, action: #selector(accountImageButtonTapped(_:)), for: .touchUpInside)
        
        self.configureLabel(label: loginLabel, text: Resources.Titles.loginLabel)
        self.configureLabel(label: mailLabel, text: Resources.Titles.mailLabel)
        self.configureLabel(label: passwordLabel, text: Resources.Titles.passwordLabel)
        
        self.configureTextField(textField: loginTextField, placeholderText: Resources.Titles.loginTitle)
        loginTextField.isEnabled = false
        self.configureTextField(textField: mailTextField, placeholderText: Resources.Placeholders.mailTextField)
        mailTextField.isEnabled = false
        self.configureTextField(textField: passwordTextField, placeholderText: Resources.Placeholders.passwordTextField,isSecury: true)
        passwordTextField.isEnabled = false
        
        self.configureLabel(label: pincodeLabel, text: Resources.Titles.pincode)
        self.configureTextField(textField: pincodeTextField, placeholderText: Resources.Placeholders.pincodeTextField,isSecury: true)
        pincodeTextField.keyboardType = .asciiCapableNumberPad
        
        logoutButton.setTitle(Resources.Titles.logout, for: .normal)
        logoutButton.setTitleColor(.red, for: .normal)
        logoutButton.titleLabel?.font = .systemFont(ofSize: 20)
        logoutButton.addTarget(self, action: #selector(logoutButtonTapped(_:)), for: .touchUpInside)
        
        deleteAccountButton.setTitle(Resources.Titles.deleteAccount, for: .normal)
        deleteAccountButton.setTitleColor(.gray, for: .normal)
        deleteAccountButton.addTarget(self, action: #selector(deleteAccountButtonTapped), for: .touchUpInside)
        deleteAccountButton.isEnabled = false
        

    }
    
    override func layoutViews() {
        NSLayoutConstraint.activate([
            accountImageButton.centerXAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.centerXAnchor),
            accountImageButton.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 30),
            accountImageButton.widthAnchor.constraint(equalToConstant: 100),
            accountImageButton.heightAnchor.constraint(equalToConstant: 100),
            loginLabel.topAnchor.constraint(equalTo: accountImageButton.bottomAnchor, constant: 20),
            loginLabel.leftAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leftAnchor, constant: 30),
            loginTextField.centerYAnchor.constraint(equalTo: loginLabel.centerYAnchor),
            loginTextField.rightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.rightAnchor, constant: -10),
            loginTextField.leftAnchor.constraint(equalTo: loginLabel.rightAnchor, constant: 10),
            loginTextField.widthAnchor.constraint(equalToConstant: 200),
            mailLabel.leftAnchor.constraint(equalTo: loginLabel.leftAnchor),
            mailLabel.topAnchor.constraint(equalTo: loginTextField.bottomAnchor, constant: 30),
            mailTextField.centerYAnchor.constraint(equalTo: mailLabel.centerYAnchor),
            mailTextField.rightAnchor.constraint(equalTo: loginTextField.rightAnchor),
            mailTextField.leftAnchor.constraint(equalTo: loginTextField.leftAnchor),
            passwordLabel.leftAnchor.constraint(equalTo: mailLabel.leftAnchor),
            passwordLabel.topAnchor.constraint(equalTo: mailTextField.bottomAnchor, constant: 30),
            passwordTextField.centerYAnchor.constraint(equalTo: passwordLabel.centerYAnchor),
            passwordTextField.rightAnchor.constraint(equalTo: loginTextField.rightAnchor),
            passwordTextField.leftAnchor.constraint(equalTo: loginTextField.leftAnchor),
            pincodeLabel.leftAnchor.constraint(equalTo: loginLabel.leftAnchor),
            pincodeLabel.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor,constant: 30),
            pincodeTextField.centerYAnchor.constraint(equalTo: pincodeLabel.centerYAnchor),
            pincodeTextField.leftAnchor.constraint(equalTo: loginTextField.leftAnchor),
            pincodeTextField.rightAnchor.constraint(equalTo: loginTextField.rightAnchor),
            logoutButton.centerXAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.centerXAnchor),
            logoutButton.topAnchor.constraint(equalTo: pincodeTextField.bottomAnchor, constant: 10),
            deleteAccountButton.topAnchor.constraint(equalTo: logoutButton.bottomAnchor, constant: 10),
            deleteAccountButton.centerXAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.centerXAnchor)
        ])
    }
}



extension ProfileViewController {
    @objc private func accountImageButtonTapped(_ sender:UIButton) {
        presenter?.userTapProfileButton(profileViewController: self,accountImageButton: accountImageButton)
    }
    
    @objc private func logoutButtonTapped(_ sender:UIButton) {
        presenter?.showLogoutAlert(profileViewController: self, navigationController: navigationController)
    }
    
    @objc private func deleteAccountButtonTapped(_ sener:UIButton) {
        
    }
}

extension ProfileViewController:PresenterToViewProfileProtocol {
    
}

extension ProfileViewController:UINavigationControllerDelegate,UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        presenter?.didFinishPickingMediaWithInfo(info: info,picker: picker ,accountImageButton: accountImageButton)
    }
}
