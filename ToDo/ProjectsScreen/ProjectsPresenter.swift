import UIKit

final class ProjectsPresenter:ViewToPresenterProjectsProtocol {
    var view: PresenterToViewProjectsProtocol?
    var router: PresenterToRouterProjectsProtocol?
    var interactor: PresenterToInteractorProjectsProtocol?
     var sectionsData = [
        ProjectsSection(sectionTitle: "Favorite", data: [
            Project(name: "Application", categories: [
                Category(name: "test Category", tasks: [
                    Task(name: "first task", description: "test description", priority: "hight", time: "test Time", isOverdue: false)])], hexColor: "644AFF")],
                        expandable: false),
        ProjectsSection(sectionTitle: "Projects", data: [
            Project(name: "Application", categories: [
                Category(name: "test Category", tasks: [
                    Task(name: "first task", description: "test description", priority: "hight", time: "test Time", isOverdue: false)])], hexColor: "644AFF"),
            Project(name: "Desktop", categories: [
                Category(name: "test Category", tasks: [
                    Task(name: "first task", description: "test description", priority: "hight", time: "test Time", isOverdue: false)])], hexColor: "3FFF34")],
                        expandable: false)]
    
    func numberOfSections() -> Int {
        sectionsData.count
    }
    
    func numberOfRowsInSection(section: Int) -> Int {
        if sectionsData[section].expandable {
            return sectionsData[section].data.count
        }
        else {
            return 0
        }
    }
    
    func cellForRowAt(tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Resources.Cells.projectCellIdentefier,for: indexPath) as? ProjectTableViewCell else {
            return UITableViewCell()
        }
        let project = sectionsData[indexPath.section].data[indexPath.row]
        cell.nameTitle.text = project.name
        cell.countOfTasksLabel.text = "\(countOfProjectTasks(project: project))"
        cell.circleImageView.tintColor = UIColor(hexString: project.hexColor)
        return cell
    }
    
    private func countOfProjectTasks(project:Project) -> Int {
        var count:Int = 0
        for category in project.categories {
            count += category.tasks.count
        }
        return count
    }
    
    func heightForHeaderInSection() -> CGFloat {
        60
    }
    
    func heightForFooterInSection() -> CGFloat {
        2
    }
    
    
    func viewForHeaderInSection(tableView: UITableView, section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = .clear
        headerView.tag = section
        
        let title:UILabel = {
            let label = UILabel()
            label.text = sectionsData[section].sectionTitle
            label.textColor = .black
            label.font = .boldSystemFont(ofSize: 18)
            return label
        }()
        headerView.addView(title)
        
        let addProjectButton:UIButton = {
            let button = UIButton()
            button.setImage(UIImage(systemName: Resources.Images.plusImage), for: .normal)
            button.tintColor = .gray
            button.addTarget(self, action: #selector(createProjectButtonTapped(_:)), for: .touchUpInside)
            return button
        }()
        headerView.addView(addProjectButton)
        
        let chevronImageView = UIImageView.init(image: UIImage(systemName: sectionsData[section].expandable ? Resources.Images.chevronDown : Resources.Images.chevronRight))
        chevronImageView.tintColor = .gray
        headerView.addView(chevronImageView)
        
        NSLayoutConstraint.activate([
            title.centerYAnchor.constraint(equalTo: headerView.centerYAnchor),
            title.leftAnchor.constraint(equalTo: headerView.leftAnchor, constant: 20),
            chevronImageView.centerYAnchor.constraint(equalTo: headerView.centerYAnchor),
            chevronImageView.rightAnchor.constraint(equalTo: headerView.rightAnchor,constant: -20),
            addProjectButton.centerYAnchor.constraint(equalTo: headerView.centerYAnchor),
            addProjectButton.rightAnchor.constraint(equalTo: chevronImageView.leftAnchor, constant: -30)
        ])
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(expandSection))
        headerView.addGestureRecognizer(gesture)
        return headerView
    }
}

extension ProjectsPresenter:InteractorToPresenterProjectsProtocol {
    
}

extension ProjectsPresenter {
        @objc private func expandSection(_ gesture: UITapGestureRecognizer) {
            guard let tag = gesture.view?.tag else {return}
            let sectionIndex = tag
            sectionsData[sectionIndex].expandable.toggle()
            view?.updateTableView()
        }
        
        @objc private func createProjectButtonTapped(_ sender:UIButton) {
        }
}
