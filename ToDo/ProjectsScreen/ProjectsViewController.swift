import Foundation
import UIKit

final class ProjectsViewController:BaseViewController {
    
    let projectsTableView = UITableView()
    let topTableView = UITableView()
    var presenter:(InteractorToPresenterProjectsProtocol & ViewToPresenterProjectsProtocol)?
    
    private enum UIConstants {
        static let topTableViewHeight = 100.0
    }
    
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
        self.view.addView(topTableView)
        self.view.addView(projectsTableView)
    }
    
    override func configure() {
        super.configure()
        navigationController?.navigationBar.isHidden = false
        self.navigationController?.navigationBar.topItem?.backBarButtonItem = UIBarButtonItem(title: Resources.Titles.today, style: .plain, target: nil, action: nil)
        title = Resources.Titles.projectsSection
        
        projectsTableView.register(ProjectTableViewCell.self, forCellReuseIdentifier: Resources.Cells.projectCellIdentefier)
        self.configureTableView(tableView: projectsTableView)
        
        topTableView.isScrollEnabled = false
        topTableView.register(CommonTableViewCell.self, forCellReuseIdentifier: Resources.Cells.commonTableCellIdentefier)
        self.configureTableView(tableView: topTableView)
    }
    
    override func layoutViews() {
        NSLayoutConstraint.activate([
            topTableView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor,constant: 15),
            topTableView.rightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.rightAnchor,constant: 0),
            topTableView.leftAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leftAnchor,constant: 0),
            topTableView.heightAnchor.constraint(equalToConstant: UIConstants.topTableViewHeight),
            projectsTableView.topAnchor.constraint(equalTo: topTableView.bottomAnchor,constant: 10),
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
            self.projectsTableView.reloadData()
        }
    }
        
}

//MARK: - TableViewMethods
extension ProjectsViewController:UITableViewDelegate,UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        switch tableView {
        case topTableView:
            return Resources.projectsModels.count
        case projectsTableView:
            return presenter?.numberOfSections() ?? 0
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch tableView {
        case topTableView:
            return Resources.projectsModels[section].options.count
        case projectsTableView:
            return presenter?.numberOfRowsInSection(section: section) ?? 0
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch tableView {
        case topTableView:
            return presenter?.cellForRowAtTopTableView(tableView: tableView, cellForRowAt: indexPath) ?? UITableViewCell()
        case projectsTableView:
            return presenter?.cellForRowAt(tableView: tableView, cellForRowAt: indexPath) ?? UITableViewCell()
        default:
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        switch tableView {
        case topTableView:
            presenter?.didSelectRowAtTopTableView(tableView: tableView, indexPath: indexPath)
        case projectsTableView:
            presenter?.didSelectRowAt(tableView: tableView, indexPath: indexPath, projectsViewController: self)
        default:
            break
        }
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        switch tableView {
        case projectsTableView:
            return presenter?.trailingSwipeActionsConfigurationForRowAt(tableView: tableView, indexPath: indexPath, projectsViewController: self)
        default:
            return nil
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        switch tableView {
        case projectsTableView:
            return presenter?.viewForHeaderInSection(projectsViewController: self, tableView: tableView, section: section)
        default:
            return nil
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch tableView {
        case projectsTableView:
            return presenter?.heightForHeaderInSection() ?? 0
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        switch tableView {
        case projectsTableView:
            return presenter?.heightForFooterInSection() ?? 0
        default:
            return 0
        }
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


