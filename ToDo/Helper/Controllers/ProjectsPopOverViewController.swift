import UIKit
import CoreData

protocol ProjectsPopOverViewControllerProtocol {
    func passTappedProject(id:NSManagedObjectID,name:String)
}

class ProjectsPopOverViewController: BaseViewController {
    
    let projectsTableView = UITableView()
    var projects = [ProjectCoreData]() {
        didSet {
            self.updateTableView()
        }
    }
    var delegate:ProjectsPopOverViewControllerProtocol?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.getProject()
    }
    
    override func viewWillLayoutSubviews() {
        super.updateViewConstraints()
        self.preferredContentSize = CGSize(width: self.projectsTableView.contentSize.width, height: self.projectsTableView.contentSize.height)
    }
}


extension ProjectsPopOverViewController {
    override func addViews() {
        self.view.addView(projectsTableView)
    }
    
    override func configure() {
        super.configure()
        projectsTableView.delegate = self
        projectsTableView.dataSource = self
        projectsTableView.register(UITableViewCell.self, forCellReuseIdentifier: Resources.Cells.popOverCellIdentegfier)
        projectsTableView.backgroundColor = .clear
        projectsTableView.tableFooterView = UIView()
        projectsTableView.separatorStyle = .none
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


extension ProjectsPopOverViewController:UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        projects.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Resources.Cells.popOverCellIdentegfier, for: indexPath)
        cell.textLabel?.text = projects[indexPath.row].name
        cell.selectionStyle = .none
        cell.backgroundColor = .clear
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let project = self.projects[indexPath.row]
        guard let name = project.name else {return}
        self.delegate?.passTappedProject(id: project.objectID, name: name)
        self.dismiss(animated: true, completion: nil)
    }
}

extension ProjectsPopOverViewController {
    
    private func getProject() {
        do {
            let projects = try DataManager.shared.projects()
            self.projects = projects
        } catch let error {
            self.present(createInfoAlert(messageText: Resources.Titles.errorTitle, titleText: error.localizedDescription), animated: true, completion: nil)
        }
    }
    
    private func updateTableView() {
        DispatchQueue.main.async {
            self.projectsTableView.reloadData()
        }
    }
}



