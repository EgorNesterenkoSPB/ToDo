import UIKit

final class PrjViewController:BaseViewController {
    
    let categoryTasksTableView = UITableView()
    var commonTasksTableHeight:NSLayoutConstraint?
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
        presenter?.getCommonTasks(project: self.project)
        presenter?.getCategories(project: self.project)
    }
    
    override func viewWillLayoutSubviews() {
        super.updateViewConstraints()
        self.commonTasksTableHeight?.constant = self.commonTasksTableView.contentSize.height
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
            commonTasksTableView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 10),
            commonTasksTableView.leftAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leftAnchor),
            commonTasksTableView.rightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.rightAnchor),
            categoryTasksTableView.topAnchor.constraint(equalTo: commonTasksTableView.bottomAnchor,constant: 10),
            categoryTasksTableView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor),
            categoryTasksTableView.rightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.rightAnchor),
            categoryTasksTableView.leftAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leftAnchor)
        ])
        commonTasksTableHeight = commonTasksTableView.heightAnchor.constraint(equalToConstant: 100)
        commonTasksTableHeight?.isActive = true
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
        presenter?.showCreateCommonTaskScreen(project: project, prjViewController: self)
    }
    
    @objc private func editButtonTapped(_ sender:UIButton) {
        presenter?.showEditAlert(project: self.project,prjViewController: self) 
    }
}

//MARK: - PresenterToView
extension PrjViewController:PresenterToViewPrjProtocol {
    
    func updateDataCommonTasksTable() {
        presenter?.getCommonTasks(project: self.project)
    }
    
    
    func showRenameCategoryAlert(alert: UIAlertController) {
        self.present(alert,animated: true)
    }
    
    func onFailedRenameCategory(errorText: String) {
        self.present(createErrorAlert(errorText: errorText),animated: true)
    }

    
    func onFailedRenameProject(errorText: String) {
        self.present(createErrorAlert(errorText: errorText),animated: true)
    }
    
    func onSuccessfulyRenameProject() {
        self.configure()
    }
    
    func reloadCommonTasksTableView() {
        DispatchQueue.main.async {
            self.commonTasksTableView.reloadData()
            self.viewWillLayoutSubviews()
        }
    }
    
    func onUpdateSection(section: Int) {
        DispatchQueue.main.async {
            self.categoryTasksTableView.reloadSections(IndexSet(integer: section), with: .none)
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
        self.present(createErrorAlert(errorText: errorText),animated: true)
    }
    
    func updateTableView() {
        DispatchQueue.main.async {
            self.categoryTasksTableView.reloadData()
            self.viewWillLayoutSubviews()
        }
    }
    
    
}

//MARK: - TableViewMethods
extension PrjViewController:UITableViewDelegate,UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        switch tableView {
        case categoryTasksTableView:
            return presenter?.numberOfSections() ?? 0
        case commonTasksTableView:
            return 1
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch tableView {
        case categoryTasksTableView:
            return presenter?.numberOfRowsInSection(section: section) ?? 0
        case commonTasksTableView:
            return presenter?.numberOfRowsInCommonTasksTable() ?? 0
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch tableView {
        case categoryTasksTableView:
            return presenter?.cellForRowAt(tableView: tableView, indexPath: indexPath) ?? UITableViewCell()
        case commonTasksTableView:
            return presenter?.cellForRowAtCommonTasksTable(tableView: tableView, indexPath: indexPath) ?? UITableViewCell()
        default:
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch tableView {
        case commonTasksTableView:
            presenter?.didSelectRowAtCommonTask(tableView: tableView, indexPath: indexPath)
        case categoryTasksTableView:
            presenter?.didSelectRowAtCategoryTask(tableView: tableView, indexPath: indexPath)
        default:
            break
        }
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        switch tableView {
        case categoryTasksTableView:
            return presenter?.trailingSwipeActionsConfigurationForRowAt(tableView: tableView, indexPath: indexPath)
        case commonTasksTableView:
            return presenter?.trailingSwipeActionsConfigurationForRowAtCommonTasksTable(tableView: tableView, indexPath: indexPath)
        default:
            return nil
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        switch tableView {
        case categoryTasksTableView:
            return presenter?.viewForHeaderInSection(prjViewController: self, tableView: tableView, section: section)
        default:
            return nil
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch tableView {
        case categoryTasksTableView:
            return presenter?.heightForHeaderInSection() ?? 0
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        switch tableView {
        case categoryTasksTableView:
            return presenter?.heightForFooterInSection() ?? 0
        default:
            return 0
        }
    }
    
//    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
//        self.viewWillLayoutSubviews()
//        switch tableView {
//        case categoryTasksTableView:
//            let rotationTransform = CATransform3DTranslate(CATransform3DIdentity, -500, 10, 0)
//            cell.layer.transform = rotationTransform
//            cell.alpha = 0
//            UIView.animate(withDuration: 0.75, animations: {
//                cell.layer.transform = CATransform3DIdentity
//                cell.alpha = 1.0
//            })
//        default:
//            break
//        }
//    }
    
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
