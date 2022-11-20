import UIKit

final class SettingsViewController:BaseViewController {

    let contentTableView = UITableView()
    let themeSwitcher = UISwitch()
    let themeLabel = UILabel()
    var contentTableHeight:NSLayoutConstraint?
    var presenter:(ViewToPresenterSettingsProtocol & InteractorToPresenterSettingsProtocol)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter?.viewDidLoad(themeSwitcher: themeSwitcher)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        self.contentTableHeight?.constant = self.contentTableView.contentSize.height
    }
}

extension SettingsViewController {
    override func addViews() {
        self.view.addView(contentTableView)
        self.view.addView(themeSwitcher)
        self.view.addView(themeLabel)
    }
        
    override func configure() {
        super.configure()
        navigationController?.navigationBar.isHidden = false
        title = Resources.Titles.settings

        themeLabel.text = Resources.Titles.colorTheme
        themeLabel.font = .systemFont(ofSize: 18)
        
        themeSwitcher.addTarget(self, action: #selector(themeSwitcherTapped(_:)), for: .valueChanged)
        
        contentTableView.isScrollEnabled = false
        contentTableView.register(CommonTableViewCell.self, forCellReuseIdentifier: Resources.Cells.commonTableCellIdentefier)
        contentTableView.delegate = self
        contentTableView.dataSource = self
        contentTableView.tableFooterView = UIView()
        contentTableView.separatorStyle = .none
        contentTableView.backgroundColor = .clear
    }
    
    override func layoutViews() {
        NSLayoutConstraint.activate([
            contentTableView.centerXAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.centerXAnchor),
            contentTableView.centerYAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.centerYAnchor),
            contentTableView.rightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.rightAnchor, constant: -30),
            contentTableView.leftAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leftAnchor, constant: 30),
            themeLabel.leftAnchor.constraint(equalTo: contentTableView.leftAnchor),
            themeLabel.topAnchor.constraint(equalTo: contentTableView.bottomAnchor, constant: 10),
            themeSwitcher.centerYAnchor.constraint(equalTo: themeLabel.centerYAnchor),
            themeSwitcher.rightAnchor.constraint(equalTo: contentTableView.rightAnchor)
        ])
        contentTableHeight = contentTableView.heightAnchor.constraint(equalToConstant: 100)
        contentTableHeight?.isActive = true
    }
}

extension SettingsViewController:UITableViewDataSource,UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        Resources.settingsContent[section].options.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        Resources.settingsContent.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = Resources.settingsContent[indexPath.section].options[indexPath.row]
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Resources.Cells.commonTableCellIdentefier, for: indexPath) as? CommonTableViewCell else {return UITableViewCell()}
        cell.setup(with: model)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var model = Resources.settingsContent[indexPath.section].options[indexPath.row]
        
        switch model.title {
        case Resources.Titles.account:
            model.handler = { [weak self] in
                self?.presenter?.userTapProfileView(navigationController:self?.navigationController)
            }
        default:
            break
        }
        model.handler()
    }
    
}

extension SettingsViewController {
    @objc private func themeSwitcherTapped(_ sender:UISwitch) {
        presenter?.switchTheme(isOn: sender.isOn)
    }
}

extension SettingsViewController:PresenterToViewSettingsProtocol {
    
}

