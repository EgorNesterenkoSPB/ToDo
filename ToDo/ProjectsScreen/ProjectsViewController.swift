import Foundation
import UIKit

final class ProjectsViewController:BaseViewController {
    
    let tableView = UITableView()
    var presenter:(InteractorToPresenterProjectsProtocol & ViewToPresenterProjectsProtocol)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        do {
            try presenter?.getData()
        } catch let error {
            presenter?.showErrorAlert(errorText: "\(error)", projectsViewController: self)
        }
    }
}

extension ProjectsViewController {
    override func addViews() {
        self.view.addView(tableView)
    }
    
    override func configure() {
        navigationController?.navigationBar.isHidden = false
        self.navigationController?.navigationBar.topItem?.backBarButtonItem = UIBarButtonItem(title: Resources.Titles.today, style: .plain, target: nil, action: nil)
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .clear
        tableView.register(ProjectTableViewCell.self, forCellReuseIdentifier: Resources.Cells.projectCellIdentefier)
        tableView.tableFooterView = UIView()
        tableView.separatorStyle = .none
    }
    
    override func layoutViews() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            tableView.rightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.rightAnchor),
            tableView.leftAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leftAnchor),
            tableView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}


//MARK: - PresenterToViewProtocol
extension ProjectsViewController:PresenterToViewProjectsProtocol {
    func onfailedDeleteProject(errorText: String) {
        presenter?.showErrorAlert(errorText: errorText, projectsViewController: self)
    }
    
    func failedGetCoreData(errorText: String) {
        presenter?.showErrorAlert(errorText: errorText, projectsViewController: self)
    }
    
    func onFailureCreateProject(errorText: String) {
        presenter?.showErrorAlert(errorText: errorText, projectsViewController: self)
    }
    
    func updateTableView() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
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
        presenter?.didSelectRowAt(tableView: tableView, indexPath: indexPath, projectsViewController: self)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        presenter?.trailingSwipeActionsConfigurationForRowAt(tableView: tableView, indexPath: indexPath, projectsViewController: self)
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        presenter?.viewForHeaderInSection(projectsViewController: self, tableView: tableView, section: section)
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        presenter?.heightForHeaderInSection() ?? 0
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        presenter?.heightForFooterInSection() ?? 0
    }
}

extension ProjectsViewController:CreateProjectViewControllerProtocol {
    func createProject(name: String, hexColor: String,isFavorite:Bool) {
        presenter?.createProject(name: name, hexColor: hexColor,isFavorite:isFavorite)
    }
}


