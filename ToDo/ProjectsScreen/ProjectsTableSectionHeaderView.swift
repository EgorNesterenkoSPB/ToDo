import UIKit


class ProjectsTableSectionHeaderView: BaseTableSectionHeaderView {
    
    let projectsViewController:ProjectsViewController
    private var bottomSheetTransitioningDelegate:UIViewControllerTransitioningDelegate?
    
    init(titleText: String, section: Int, expandable: Bool,projectsViewController:ProjectsViewController) {
        self.projectsViewController = projectsViewController
        super.init(titleText: titleText, section: section, expandable: expandable)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func configureView() {
        super.configureView()
        let addProjectButton:UIButton = {
            let button = UIButton()
            button.setImage(UIImage(systemName: Resources.Images.plusImage), for: .normal)
            button.tintColor = .gray
            button.addTarget(self, action: #selector(createProjectButtonTapped(_:)), for: .touchUpInside)
            return button
        }()
        self.addView(addProjectButton)
        
        NSLayoutConstraint.activate([
            addProjectButton.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            addProjectButton.rightAnchor.constraint(equalTo: chevronImageView.leftAnchor, constant: -30)
        ])
    }
}

extension ProjectsTableSectionHeaderView {
    @objc private func createProjectButtonTapped(_ sender:UIButton) {
        let createProjectViewController = CreateProjectViewController()
        createProjectViewController.modalPresentationStyle = .overCurrentContext
        createProjectViewController.delegate = projectsViewController
        projectsViewController.present(createProjectViewController,animated: false)
    }
}
