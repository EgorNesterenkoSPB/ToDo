import UIKit

final class PrjViewController:BaseViewController {
    var presenter:(ViewToPresenterPrjProtocol & InteractorToPresenterPrjProtocol)?
    let project:ProjectCoreData
    
    init(project:ProjectCoreData) {
        self.project = project
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension PrjViewController {
    override func addViews() {
        
    }
    
    override func configure() {
        navigationController?.navigationBar.isHidden = false
        self.navigationController?.navigationBar.topItem?.backBarButtonItem = UIBarButtonItem(title: "Projects", style: .plain, target: nil, action: nil)
        title = project.name
    }
    
    override func layoutViews() {
        
    }
}

extension PrjViewController:PresenterToViewPrjProtocol {
    
}
