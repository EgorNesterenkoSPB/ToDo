import UIKit

final class MainViewController:BaseViewController {
    var presenter:(InteractorToPresenterMainProtocol & ViewToPresenterMainProtocol)?
    
    let tableView = UITableView()
    let bottomBackgroundView = CustomizedShapeView()
    let circleButton = UIButton()
    let topTitle = UILabel()
    let projectsButton = UIButton()
    let settingsButton = UIButton()
    
    override func viewDidLayoutSubviews() {
        circleButton.clipsToBounds = true
        circleButton.layer.cornerRadius = circleButton.frame.width / 2
    }
}

//MARK: - Setup UI
extension MainViewController {
    override func addViews() {
        self.view.addView(bottomBackgroundView)
        self.view.addView(circleButton)
        self.view.addView(tableView)
        self.view.addView(topTitle)
        bottomBackgroundView.addView(projectsButton)
        bottomBackgroundView.addView(settingsButton)
    }
    
    override func configure() {
        navigationController?.navigationBar.isHidden = true
        self.view.backgroundColor = .white
        
        topTitle.text = "Today"
        topTitle.font = .boldSystemFont(ofSize: 30)
        
        circleButton.backgroundColor = .systemOrange
        circleButton.setImage(UIImage(systemName: Resources.Images.plusImage,withConfiguration: Resources.Configurations.largeConfiguration), for: .normal)
        circleButton.tintColor = .white
        circleButton.addTarget(self, action: #selector(addTaskButtonTapped(_:)), for: .touchUpInside)
        
        self.configureBottomButton(button: projectsButton, imageName:  Resources.Images.projectsImage)
        projectsButton.addTarget(self, action: #selector(projectsButtonTapped), for: .touchUpInside)
        self.configureBottomButton(button: settingsButton, imageName: Resources.Images.settingsImage)
        
        
        tableView.backgroundColor = .clear
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(TaskTableViewCell.self, forCellReuseIdentifier: Resources.Cells.taskCellIdentefier)
        tableView.tableFooterView = UIView()
        tableView.separatorStyle = .none
        
        
    }
    
    override func layoutViews() {
        NSLayoutConstraint.activate([
            topTitle.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor,constant: 10),
            topTitle.leftAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leftAnchor,constant: 15),
            bottomBackgroundView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor),
            bottomBackgroundView.rightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.rightAnchor),
            bottomBackgroundView.leftAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leftAnchor),
            bottomBackgroundView.heightAnchor.constraint(equalToConstant: 55),
            tableView.topAnchor.constraint(equalTo: topTitle.bottomAnchor,constant: 10),
            tableView.bottomAnchor.constraint(equalTo: circleButton.topAnchor),
            tableView.rightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.rightAnchor),
            tableView.leftAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leftAnchor),
            circleButton.centerXAnchor.constraint(equalTo: bottomBackgroundView.centerXAnchor),
            circleButton.bottomAnchor.constraint(equalTo: bottomBackgroundView.bottomAnchor,constant: -20),
            circleButton.widthAnchor.constraint(equalToConstant: 70),
            circleButton.heightAnchor.constraint(equalToConstant: 70),
            projectsButton.centerYAnchor.constraint(equalTo: bottomBackgroundView.centerYAnchor),
            projectsButton.leftAnchor.constraint(equalTo: bottomBackgroundView.leftAnchor, constant: 20),
            settingsButton.rightAnchor.constraint(equalTo: bottomBackgroundView.rightAnchor, constant: -20),
            settingsButton.centerYAnchor.constraint(equalTo: bottomBackgroundView.centerYAnchor)
        ])
    }
}


//MARK: - Buttons methods
extension MainViewController {
    @objc private func addTaskButtonTapped(_ sender:UIButton) {
        presenter?.userTapCreateTask(mainViewController: self)
    }
        
    @objc private func projectsButtonTapped(_ sender:UIButton) {
        presenter?.userTapProjectsButton(navigationController:navigationController)
    }
}

extension MainViewController {
    private func configureBottomButton(button:UIButton, imageName:String) {
        button.setImage(UIImage(systemName: imageName,withConfiguration: Resources.Configurations.largeConfiguration), for: .normal)
        button.tintColor = .darkGray
    }
}

//MARK: - PresenterToViewMethods
extension MainViewController:PresenterToViewMainProtocol {
    func updateTableView() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
}

//MARK: - TableViewMethods
extension MainViewController:UITableViewDelegate,UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return presenter?.numberOfSections() ?? 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter?.numberOfRowsInSection(section: section) ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        presenter?.cellForRowAt(tableView: tableView, cellForRowAt: indexPath) ?? UITableViewCell()
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        presenter?.viewForHeaderInSection(tableView: tableView, section: section) ?? UIView()
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        presenter?.heightForHeaderInSection() ?? 0
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        presenter?.heightForFooterInSection() ?? 0
    }
    
}

