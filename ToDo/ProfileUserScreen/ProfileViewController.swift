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
    let confirmButton = UIButton()
    let scrollView = UIScrollView()
    let verticalStackView = UIStackView()
    
    private enum UIConstans {
        static let topSpacing = 20.0
        static let accountImageButtonWidth = 100.0
        static let textFieldWidth = 200.0
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //TODO: - Check if user is setted pin code, check if user was login
        presenter?.viewDidLoad(accountImageButton: accountImageButton)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        accountImageButton.imageView?.layer.cornerRadius = accountImageButton.bounds.height / 2.0
        scrollView.contentSize = CGSize(width: UIScreen.main.bounds.width, height: verticalStackView.frame.height + UIConstans.topSpacing)
    }
}

extension ProfileViewController {
    override func addViews() {
        self.view.addView(scrollView)
        scrollView.addSubview(verticalStackView)
    }
    
    override func configure() {
        super.configure()
        navigationController?.navigationBar.isHidden = false
        title = Resources.Titles.account
        scrollView.showsVerticalScrollIndicator = false
        
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
        
        let loginHorizontalStackView = self.createHorizontalStackView(subviews: [loginLabel,loginTextField])
        let mailHorizontalStackView = self.createHorizontalStackView(subviews: [mailLabel,mailTextField])
        let passwordHorizontalStackView = self.createHorizontalStackView(subviews: [passwordLabel,passwordTextField])
        let pincodeHorizontalStackView = self.createHorizontalStackView(subviews: [pincodeLabel,pincodeTextField])
        
        
        logoutButton.setTitle(Resources.Titles.logout, for: .normal)
        logoutButton.setTitleColor(.red, for: .normal)
        logoutButton.titleLabel?.font = .systemFont(ofSize: 20)
        logoutButton.addTarget(self, action: #selector(logoutButtonTapped(_:)), for: .touchUpInside)
        
        deleteAccountButton.setTitle(Resources.Titles.deleteAccount, for: .normal)
        deleteAccountButton.setTitleColor(.gray, for: .normal)
        deleteAccountButton.addTarget(self, action: #selector(deleteAccountButtonTapped), for: .touchUpInside)
        deleteAccountButton.isEnabled = false
        
        self.configureConfirmButton(confirmButton: confirmButton)
        
        verticalStackView.axis = .vertical
        verticalStackView.alignment = .center
        verticalStackView.distribution = .equalSpacing
        verticalStackView.spacing = 20
        verticalStackView.addArrangedSubviews([accountImageButton,loginHorizontalStackView,mailHorizontalStackView,passwordHorizontalStackView,pincodeHorizontalStackView,confirmButton,logoutButton,deleteAccountButton])
    }
    
    override func layoutViews() {
        NSLayoutConstraint.activate([
            scrollView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            scrollView.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor),
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            verticalStackView.topAnchor.constraint(equalTo: scrollView.topAnchor,constant: UIConstans.topSpacing),
            verticalStackView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            verticalStackView.rightAnchor.constraint(equalTo: scrollView.rightAnchor,constant: -10),
            verticalStackView.leftAnchor.constraint(equalTo: scrollView.leftAnchor,constant: 10),
            accountImageButton.widthAnchor.constraint(equalToConstant: UIConstans.accountImageButtonWidth),
            accountImageButton.heightAnchor.constraint(equalToConstant: UIConstans.accountImageButtonWidth),
            loginTextField.widthAnchor.constraint(equalToConstant: UIConstans.textFieldWidth),
            mailTextField.widthAnchor.constraint(equalToConstant: UIConstans.textFieldWidth),
            passwordTextField.widthAnchor.constraint(equalToConstant: UIConstans.textFieldWidth),
            pincodeTextField.widthAnchor.constraint(equalToConstant: UIConstans.textFieldWidth),
        ])
    }
}

extension ProfileViewController {
    private func createHorizontalStackView(subviews:[UIView]) -> UIStackView {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .fillEqually
        stackView.addArrangedSubviews(subviews)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView 
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
