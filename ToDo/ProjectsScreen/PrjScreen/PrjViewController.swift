import UIKit

final class PrjViewController:BaseViewController {
    
    let tasksTableView = UITableView()
    let topTitle = UILabel()
    let editButton = UIButton()
    var presenter:(ViewToPresenterPrjProtocol & InteractorToPresenterPrjProtocol)?
    private var project:ProjectCoreData
    
    init(project:ProjectCoreData) {
        self.project = project
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        presenter?.getCategories(project: self.project)
    }
}

extension PrjViewController {
    override func addViews() {
        self.view.addView(topTitle)
        self.view.addView(editButton)
        self.view.addView(tasksTableView)
    }
    
    override func configure() {
        super.configure()
        self.navigationController?.navigationBar.isHidden = false
        self.navigationController?.navigationBar.topItem?.backBarButtonItem = UIBarButtonItem(title: Resources.Titles.projectsSection, style: .plain, target: nil, action: nil)
        title = project.name
        
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonTapped(_:)))
        navigationItem.rightBarButtonItems = [addButton]
    
        tasksTableView.delegate = self
        tasksTableView.dataSource = self
        tasksTableView.register(TaskTableViewCell.self, forCellReuseIdentifier: Resources.Cells.taskCellIdentefier)
        tasksTableView.separatorStyle = .none
        tasksTableView.tableFooterView = UIView()
        
        topTitle.font = .boldSystemFont(ofSize: 23)
        topTitle.text = Resources.Titles.categoriesTitle
        
        editButton.setImage(UIImage(systemName: Resources.Images.edite,withConfiguration: Resources.Configurations.largeConfiguration), for: .normal)
        editButton.tintColor = .gray
        editButton.addTarget(self, action: #selector(editButtonTapped(_:)), for: .touchUpInside)
    }
    
    override func layoutViews() {
        NSLayoutConstraint.activate([
            topTitle.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 10),
            topTitle.leftAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leftAnchor, constant: 15),
            editButton.centerYAnchor.constraint(equalTo: topTitle.centerYAnchor),
            editButton.rightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.rightAnchor,constant: -20),
            tasksTableView.topAnchor.constraint(equalTo: topTitle.bottomAnchor,constant: 10),
            tasksTableView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor),
            tasksTableView.rightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.rightAnchor),
            tasksTableView.leftAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leftAnchor)
        ])
        
    }
}

extension PrjViewController {
    @objc private func addButtonTapped(_ sender:UIButton) {
        guard let alert = presenter?.showCreateCategoryAlert(project: project) else {return}
        self.present(alert,animated: true)
    }
    
    @objc private func editButtonTapped(_ sender:UIButton) {
        guard let alert = presenter?.showEditAlert(project: self.project) else {return}
        self.present(alert,animated: true)
    }
}

//MARK: - PresenterToView
extension PrjViewController:PresenterToViewPrjProtocol {
    func onUpdateSection(section: Int) {
        DispatchQueue.main.async {
            self.tasksTableView.reloadSections(IndexSet(integer: section), with: .none)
        }
    }
    
    func onFailedDeleteTask(errorText: String) {
        self.present(createErrorAlert(errorText: errorText),animated: true)
    }
    
    func onSuccessefulyDeleteTask() {
        self.presenter?.getCategories(project: self.project)
    }
    
    func onSuccessfulyDeleteCategory() {
        self.presenter?.getCategories(project: self.project)
    }
    
    func onFailedDeleteCategory(errorText: String) {
        self.present(createErrorAlert(errorText: errorText),animated: true)
    }
    
    func hideViewController() {
        self.navigationController?.popViewController(animated: true)
    }
    
    func onFailedDeleteProject(errorText: String) {
        self.present(createErrorAlert(errorText: errorText),animated: true)
    }
    
    func onFailedDeleteAllCategories(errorText: String) {
        self.present(createErrorAlert(errorText: errorText),animated: true)
    }
    
    func onFailedCreateCategory(errorText: String) {
        self.present(createErrorAlert(errorText: errorText),animated: true)
    }
    
    func failedGetCoreData(errorText: String) {
        self.present(createErrorAlert(errorText: errorText),animated: true)
    }
    
    func updateTableView() {
        DispatchQueue.main.async {
            self.tasksTableView.reloadData()
        }
    }
    
    
}

//MARK: - TableViewMethods
extension PrjViewController:UITableViewDelegate,UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        presenter?.numberOfSections() ?? 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        presenter?.numberOfRowsInSection(section: section) ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        presenter?.cellForRowAt(tableView: tableView, indexPath: indexPath) ?? UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        presenter?.trailingSwipeActionsConfigurationForRowAt(tableView: tableView, indexPath: indexPath)
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        presenter?.viewForHeaderInSection(prjViewController: self, tableView: tableView, section: section)
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        presenter?.heightForHeaderInSection() ?? 0
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        presenter?.heightForFooterInSection() ?? 0
    }
    
}


extension PrjViewController:CreateTaskViewControllerProtocol {
    func refreshView(category: CategoryCoreData, section: Int) {
        presenter?.updateSection(category: category, section: section)
    }
}
