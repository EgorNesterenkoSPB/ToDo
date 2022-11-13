import UIKit

final class SettingsViewController:BaseViewController {

    let verticalStackView = UIStackView()
    let themeSwitcher = UISwitch()
    let themeLabel = UILabel()
    var presenter:(ViewToPresenterSettingsProtocol & InteractorToPresenterSettingsProtocol)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter?.viewDidLoad(themeSwitcher: themeSwitcher)
    }
}

extension SettingsViewController {
    override func addViews() {
        self.view.addView(verticalStackView)
        self.view.addView(themeSwitcher)
        self.view.addView(themeLabel)
        
    }
        
    override func configure() {
        super.configure()
        navigationController?.navigationBar.isHidden = false
        title = Resources.Titles.settings
        
        verticalStackView.axis = .vertical
        verticalStackView.alignment = .center
        verticalStackView.distribution = .equalSpacing
        verticalStackView.spacing = 40
        
        themeLabel.text = Resources.Titles.colorTheme
        themeLabel.font = .systemFont(ofSize: 18)
        
        themeSwitcher.addTarget(self, action: #selector(themeSwitcherTapped(_:)), for: .valueChanged)
        
        let accountHorizontalStackView = self.createHorizontalStackView(imageName: Resources.Images.profileImage, titleName: Resources.Titles.account)
        let supportHorizontalStackView = self.createHorizontalStackView(imageName: Resources.Images.question, titleName: Resources.Titles.support)
        let websiteHorizontalStackView = self.createHorizontalStackView(imageName: Resources.Images.globe, titleName: Resources.Titles.website)
        
        let accountGesture = UITapGestureRecognizer(target: self, action: #selector(accountViewTapped))
        accountHorizontalStackView.addGestureRecognizer(accountGesture)
        
        let supportGesture = UITapGestureRecognizer(target: self, action: #selector(supportViewTapped))
        supportHorizontalStackView.addGestureRecognizer(supportGesture)
        
        let weebsiteGesture = UITapGestureRecognizer(target: self, action: #selector(websiteViewTapped))
        websiteHorizontalStackView.addGestureRecognizer(weebsiteGesture)
        
        
        verticalStackView.addArrangedSubview(accountHorizontalStackView)
        verticalStackView.addArrangedSubview(supportHorizontalStackView)
        verticalStackView.addArrangedSubview(websiteHorizontalStackView)
        
    }
    
    override func layoutViews() {
        NSLayoutConstraint.activate([
            verticalStackView.centerYAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.centerYAnchor),
            verticalStackView.centerXAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.centerXAnchor),
            themeLabel.topAnchor.constraint(equalTo: verticalStackView.bottomAnchor, constant: 30),
            themeLabel.leftAnchor.constraint(equalTo: verticalStackView.leftAnchor),
            themeSwitcher.centerYAnchor.constraint(equalTo: themeLabel.centerYAnchor),
            themeSwitcher.rightAnchor.constraint(equalTo: verticalStackView.rightAnchor)
        ])
    }
}

extension SettingsViewController {
    private func createHorizontalStackView(imageName:String,titleName:String) ->UIStackView {
        let leftImageView = UIImageView(image: UIImage(systemName: imageName,withConfiguration: Resources.Configurations.largeConfiguration))
        leftImageView.tintColor = UIColor(named: Resources.Titles.labelAndTintColor)
        let rightImageView = UIImageView(image: UIImage(systemName: Resources.Images.chevronRight,withConfiguration: Resources.Configurations.largeConfiguration))
        rightImageView.tintColor = .gray
        
        let titleLabel:UILabel = {
           let label = UILabel()
            label.text = titleName
            label.font = .systemFont(ofSize: 18)
            return label
        }()
        
        let horizontalStackView:UIStackView = {
           let stackView = UIStackView()
            stackView.axis = .horizontal
            stackView.alignment = .center
            stackView.distribution = .equalSpacing
            stackView.spacing = 50
            stackView.translatesAutoresizingMaskIntoConstraints = false
            return stackView
        }()
        
        horizontalStackView.addArrangedSubview(leftImageView)
        horizontalStackView.addArrangedSubview(titleLabel)
        horizontalStackView.addArrangedSubview(rightImageView)
        return horizontalStackView
    }
}

extension SettingsViewController {
    @objc private func accountViewTapped(_ gesture: UITapGestureRecognizer) {
        presenter?.userTapProfileView(navigationController:navigationController)
    }
    
    @objc private func supportViewTapped(_ gesture: UITapGestureRecognizer) {

    }
    
    @objc private func websiteViewTapped(_ gesture: UITapGestureRecognizer) {

    }
    
    @objc private func themeSwitcherTapped(_ sender:UISwitch) {
        presenter?.switchTheme(isOn: sender.isOn)
    }
}

extension SettingsViewController:PresenterToViewSettingsProtocol {
    
}

