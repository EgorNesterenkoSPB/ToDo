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
}

extension ProjectsTableSectionHeaderView {
    override func _addButtonTapped() {
        super._addButtonTapped()
        let createProjectViewController = CreateProjectRouter.createModule()
        createProjectViewController.modalPresentationStyle = .overCurrentContext
        createProjectViewController.delegate = projectsViewController
        projectsViewController.present(createProjectViewController,animated: false)
    }
}
