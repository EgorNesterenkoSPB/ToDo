import UIKit

final class PrjViewController:BaseViewController {
    
    let categoryTasksTableView = UITableView()
    let commonTasksTableView = UITableView()
    var presenter:(ViewToPresenterPrjProtocol & InteractorToPresenterPrjProtocol)?
    var project:ProjectCoreData
    
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
        self.view.addView(commonTasksTableView)
        self.view.addView(categoryTasksTableView)
    }
    
    override func configure() {
        super.configure()
        self.navigationController?.navigationBar.isHidden = false
        self.navigationController?.navigationBar.topItem?.backBarButtonItem = UIBarButtonItem(title: Resources.Titles.projectsSection, style: .plain, target: nil, action: nil)
        title = project.name
        
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonTapped))
        let editButton = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(editButtonTapped))
        navigationItem.rightBarButtonItems = [addButton,editButton]
    
        self.setupTableView(tableView: categoryTasksTableView)
        categoryTasksTableView.register(TaskTableViewCell.self, forCellReuseIdentifier: Resources.Cells.taskCellIdentefier)
        
        
        self.setupTableView(tableView: commonTasksTableView)
        commonTasksTableView.register(TaskTableViewCell.self, forCellReuseIdentifier: Resources.Cells.commonTaskCellIdentefier)
        
    }
    
    override func layoutViews() {
        NSLayoutConstraint.activate([
            categoryTasksTableView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor,constant: 10),
            categoryTasksTableView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor),
            categoryTasksTableView.rightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.rightAnchor),
            categoryTasksTableView.leftAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leftAnchor)
        ])
        
    }
}

extension PrjViewController {
    private func setupTableView(tableView:UITableView) {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.tableFooterView = UIView()
    }
}

extension PrjViewController {
    @objc private func addButtonTapped(_ sender:UIButton) {
        presenter?.showCreateCommonTaskScreen(project: project)
    }
    
    @objc private func editButtonTapped(_ sender:UIButton) {
        presenter?.showEditAlert(project: self.project,prjViewController: self) 
    }
}

//MARK: - PresenterToView
extension PrjViewController:PresenterToViewPrjProtocol {
    func onUpdateSection(section: Int) {
        DispatchQueue.main.async {
            self.categoryTasksTableView.reloadSections(IndexSet(integer: section), with: .none)
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
            self.categoryTasksTableView.reloadData()
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
