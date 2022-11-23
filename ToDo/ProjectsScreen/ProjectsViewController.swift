import Foundation
import UIKit

final class ProjectsViewController:BaseViewController {
    
    let projectsTableView = UITableView()
    var presenter:(InteractorToPresenterProjectsProtocol & ViewToPresenterProjectsProtocol)?
        
    override func viewDidLoad() {
        super.viewDidLoad()
        do {
            try presenter?.getData()
        } catch let error {
            presenter?.showErrorAlert(errorText: "\(error)", projectsViewController: self)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        do {
            try presenter?.getData()
        } catch let error {
            presenter?.showErrorAlert(errorText: "\(error)", projectsViewController: self)
        }
        self.updateTableView()
    }
    
    
}

extension ProjectsViewController {
    override func addViews() {
        self.view.addView(projectsTableView)
    }
    
    override func configure() {
        super.configure()
        navigationController?.navigationBar.isHidden = false
        self.navigationController?.navigationBar.topItem?.backBarButtonItem = UIBarButtonItem(title: Resources.Titles.today, style: .plain, target: nil, action: nil)
        title = Resources.Titles.projectsSection
        
        projectsTableView.register(ProjectTableViewCell.self, forCellReuseIdentifier: Resources.Cells.projectCellIdentefier)
        projectsTableView.register(CommonTableViewCell.self, forCellReuseIdentifier: Resources.Cells.commonTableCellIdentefier)
        self.configureTableView(tableView: projectsTableView)
    }
    
    override func layoutViews() {
        NSLayoutConstraint.activate([
            projectsTableView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            projectsTableView.rightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.rightAnchor),
            projectsTableView.leftAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leftAnchor),
            projectsTableView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}


extension ProjectsViewController {
    private func configureTableView(tableView:UITableView) {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
    }
}


//MARK: - PresenterToViewProtocol
extension ProjectsViewController:PresenterToViewProjectsProtocol {
    
    func onFailedCoreData(errorText: String) {
        presenter?.showErrorAlert(errorText: errorText, projectsViewController: self)
    }
    
    func updateTableView() {
        DispatchQueue.main.async {
            self.projectsTableView.reloadData()
        }
    }
        
}

//MARK: - TableViewMethods
extension ProjectsViewController:UITableViewDelegate,UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        presenter?.numberOfSections() ?? 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        presenter?.numberOfRowsInSection(section: section) ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        presenter?.cellForRowAt(tableView: tableView, cellForRowAt: indexPath) ?? UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        presenter?.didSelectRowAt(tableView: tableView, indexPath: indexPath, projectsViewController: self)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        presenter?.trailingSwipeActionsConfigurationForRowAt(tableView: tableView, indexPath: indexPath, projectsViewController: self)
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        presenter?.viewForHeaderInSection(projectsViewController: self, tableView: tableView, section: section)
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        presenter?.heightForHeaderInSection(section: section) ?? 0
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        presenter?.heightForFooterInSection() ?? 0
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        self.viewWillLayoutSubviews()
        guard indexPath.section == 2 else {return} //dont show update animate at top static cells and favorite section
        let rotationTransform = CATransform3DTranslate(CATransform3DIdentity, 0, -50, 10)
        cell.layer.transform = rotationTransform
        cell.alpha = 0
        UIView.animate(withDuration: 0.75, animations: {
            cell.layer.transform = CATransform3DIdentity
            cell.alpha = 1.0
        })
    }
}

extension ProjectsViewController:CreateProjectViewControllerProtocol {
    func refreshView() {
        do {
            try presenter?.getData()
        } catch let error {
            presenter?.showErrorAlert(errorText: "\(error)", projectsViewController: self)
        }
        self.updateTableView()
    }
}


