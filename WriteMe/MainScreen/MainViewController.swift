import UIKit

final class MainViewController:BaseViewController {
    var presenter:(InteractorToPresenterMainProtocol & ViewToPresenterMainProtocol)?
    
    let tableView = UITableView()
    let createTaskButton = UIButton()
    let projectsButton = UIButton()
    let settingsButton = UIButton()
    var token:Token?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter?.creatyIncomingProject()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        presenter?.getData()
    }
}

//MARK: - Setup UI
extension MainViewController {
    override func addViews() {
        self.view.addView(tableView)
        self.view.addView(projectsButton)
        self.view.addView(settingsButton)
        self.view.addView(createTaskButton)
    }
    
    override func configure() {
        super.configure()
        
        let rightSwipe = UISwipeGestureRecognizer(target: self, action: #selector(projectsButtonTapped))
        rightSwipe.direction = .right
        self.view.addGestureRecognizer(rightSwipe)
        
        createTaskButton.setTitle(Resources.Titles.createTask, for: .normal)
        createTaskButton.setTitleColor(.white, for: .normal)
        createTaskButton.backgroundColor = .systemOrange
        createTaskButton.contentEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        createTaskButton.layer.cornerRadius = 12
        createTaskButton.clipsToBounds = true
        createTaskButton.addTarget(self, action: #selector(addTaskButtonTapped), for: .touchUpInside)
        
        self.configureActionButton(button: projectsButton, imageName:  Resources.Images.projectsImage)
        
        projectsButton.addTarget(self, action: #selector(projectsButtonTapped), for: .touchUpInside)
        projectsButton.tintColor = UIColor(named: Resources.Titles.labelAndTintColor)
        
        self.configureActionButton(button: settingsButton, imageName: Resources.Images.settingsImage)
        
        settingsButton.addTarget(self, action: #selector(settingsButtonTapped(_:)), for: .touchUpInside)
        settingsButton.tintColor = UIColor(named: Resources.Titles.labelAndTintColor)
        
        tableView.backgroundColor = .clear
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(TaskTableViewCell.self, forCellReuseIdentifier: Resources.Cells.taskCellIdentefier)
        tableView.tableFooterView = UIView()
        tableView.separatorStyle = .none
    }
    
    override func layoutViews() {
        NSLayoutConstraint.activate([
            projectsButton.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor,constant: 15),
            projectsButton.leftAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leftAnchor, constant: 15),
            settingsButton.topAnchor.constraint(equalTo: projectsButton.topAnchor),
            settingsButton.rightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.rightAnchor, constant: -15),
            tableView.topAnchor.constraint(equalTo: projectsButton.bottomAnchor),
            tableView.rightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.rightAnchor,constant: -10),
            tableView.leftAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leftAnchor,constant: 10),
            tableView.bottomAnchor.constraint(equalTo: createTaskButton.topAnchor),
            createTaskButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            createTaskButton.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -10)
        ])
    }
}


//MARK: - Buttons methods
extension MainViewController {
    @objc private func addTaskButtonTapped(_ sender:UIButton) {
        presenter?.userTapCreateTask(mainViewController: self)
    }
        
    @objc private func projectsButtonTapped(_ sender:UIButton) {
        presenter?.userTapProjectsButton(navigationController: navigationController)
    }
    
    @objc private func settingsButtonTapped(_ sender:UIButton) {
        presenter?.userTapSettingsButton(navigationController: navigationController)
    }
}

extension MainViewController {
    private func configureActionButton(button:UIButton, imageName:String) {
        button.setImage(UIImage(systemName: imageName,withConfiguration: Resources.Configurations.largeConfiguration), for: .normal)
        button.tintColor = .darkGray
    }
}

//MARK: - PresenterToViewMethods
extension MainViewController:PresenterToViewMainProtocol {
    func errorGetCoreData(errorText: String) {
        self.present(createInfoAlert(messageText: Resources.Titles.errorTitle, titleText: errorText), animated: true)
    }
    
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        presenter?.didSelectRowAt(tableView: tableView, indexPath: indexPath, mainViewController:self)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        presenter?.trailingSwipeActionsConfigurationForRowAt(tableView: tableView, indexPath: indexPath, mainViewController: self)
    }
}

//MARK: CreateTaskVCProtocol
extension MainViewController:CreateTaskViewControllerProtocol {
    func refreshView(category: CategoryCoreData, section: Int) {return}
    
    func refreshCommonTasksTable() {
        self.presenter?.getData()
    }
}

//MARK: - TaskVCProtocol
extension MainViewController:TaskViewControllerProtocol {
    func refreshView() {
        self.presenter?.getData()
    }
}
