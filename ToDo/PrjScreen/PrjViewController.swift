import UIKit

final class PrjViewController:BaseViewController {
    
    let tasksTableView = UITableView()
    var presenter:(ViewToPresenterPrjProtocol & InteractorToPresenterPrjProtocol)?
    var project:ProjectCoreData
    
    init(project:ProjectCoreData) {
        self.project = project
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter?.getCommonTasks(project: self.project)
        presenter?.getCategories(project: self.project)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.reloadCommonTasksSection()
        self.reloadCommonTasksSection()
    }
}

extension PrjViewController {
    override func addViews() {
        self.view.addView(tasksTableView)
    }
    
    override func configure() {
        super.configure()
        self.navigationController?.navigationBar.isHidden = false
        self.navigationController?.navigationBar.topItem?.backBarButtonItem = UIBarButtonItem(title: Resources.Titles.projectsSection, style: .plain, target: nil, action: nil)
        title = project.name
        
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonTapped))
        let editButton = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(editButtonTapped))
        navigationItem.rightBarButtonItems = [addButton,editButton]
    
        tasksTableView.delegate = self
        tasksTableView.dataSource = self
        tasksTableView.separatorStyle = .none
        tasksTableView.isScrollEnabled = true
        tasksTableView.tableFooterView = UIView()
        tasksTableView.register(TaskTableViewCell.self, forCellReuseIdentifier: Resources.Cells.taskCellIdentefier)
    }
    
    override func layoutViews() {
        NSLayoutConstraint.activate([
            tasksTableView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            tasksTableView.leftAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leftAnchor),
            tasksTableView.rightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.rightAnchor),
            tasksTableView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}

extension PrjViewController {
    @objc private func addButtonTapped(_ sender:UIButton) {
        presenter?.showCreateCommonTaskScreen(project: project, prjViewController: self)
    }
    
    @objc private func editButtonTapped(_ sender:UIButton) {
        presenter?.showEditAlert(project: self.project,prjViewController: self) 
    }
}

//MARK: - PresenterToView
extension PrjViewController:PresenterToViewPrjProtocol {
    
    func updateDataCommonTasks() {
        presenter?.getCommonTasks(project: self.project)
    }
    
    
    func showRenameCategoryAlert(alert: UIAlertController) {
        self.present(alert,animated: true)
    }
    
    func onFailedRenameCategory(errorText: String) {
        self.present(createInfoAlert(messageText: errorText, titleText: Resources.Titles.errorTitle),animated: true)
    }

    
    func onFailedRenameProject(errorText: String) {
        self.present(createInfoAlert(messageText: errorText, titleText: Resources.Titles.errorTitle),animated: true)
    }
    
    func onSuccessfulyRenameProject() {
        self.configure()
    }
    
    func reloadCommonTasksSection() {
        DispatchQueue.main.async {
            self.tasksTableView.reloadSections(IndexSet(integer: 0), with: .fade)
        }
    }
    
    func onUpdateSection(section: Int) {
        DispatchQueue.main.async {
            self.tasksTableView.reloadSections(IndexSet(integer: section), with: .fade)
        }
    }
    
    func onSuccessefulyDeleteTask() {
        self.presenter?.getCategories(project: self.project)
    }
    
    func onSuccessfulyDeleteCategory() {
        self.presenter?.getCategories(project: self.project)
    }
    
    func hideViewController() {
        self.navigationController?.popViewController(animated: true)
    }
    
    func failedCoreData(errorText: String) {
        self.present(createInfoAlert(messageText: errorText, titleText: Resources.Titles.errorTitle),animated: true)
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
        switch tableView {
        case tasksTableView:
            return presenter?.numberOfSections() ?? 0
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            presenter?.numberOfRowsInSection(section: section) ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            presenter?.cellForRowAt(tableView: tableView, indexPath: indexPath) ?? UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        presenter?.didSelectRowAt(tableView: tableView, indexPath: indexPath, navigationController: navigationController)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        presenter?.trailingSwipeActionsConfigurationForRowAt(tableView: tableView, indexPath: indexPath)
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        presenter?.viewForHeaderInSection(prjViewController: self, tableView: tableView, section: section)
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        presenter?.heightForHeaderInSection(section:section) ?? 0
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

extension PrjViewController:CreateCommonTaskViewControllerProtocol {
    func updateCommonTasksTableView() {
        presenter?.getCommonTasks(project: self.project)
    }
}
