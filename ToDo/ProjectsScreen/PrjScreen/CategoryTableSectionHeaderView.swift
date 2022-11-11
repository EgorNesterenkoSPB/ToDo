import UIKit


class CategoryTableSectionHeaderView: BaseTableSectionHeaderView {

    let prjViewController:PrjViewController
    let category:CategoryCoreData
    private var bottomSheetTransitioningDelegate:UIViewControllerTransitioningDelegate?
    
    init(titleText: String, section: Int, expandable: Bool,prjViewController:PrjViewController,category:CategoryCoreData) {
        self.prjViewController = prjViewController
        self.category = category
        super.init(titleText: titleText, section: section, expandable: expandable)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension CategoryTableSectionHeaderView {
    override func _addButtonTapped() {
        super._addButtonTapped()
        let createTaskViewController = CreateTaskRouter.createModule(category: self.category)
        createTaskViewController.modalPresentationStyle = .overCurrentContext
        createTaskViewController.delegate = prjViewController
        prjViewController.present(createTaskViewController,animated: false)
    }
}
