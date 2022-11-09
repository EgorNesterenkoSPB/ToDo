import UIKit

final class TasksViewController:BaseViewController {
    var presenter:(ViewToPresenterTasksProtocol & InteractorToPresenterTasksProtocol)?
    let category:CategoryCoreData
    
    init(category:CategoryCoreData) {
        self.category = category
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension TasksViewController {
    override func addViews() {
        
    }
    
    override func configure() {
        
    }
    
    override func layoutViews() {
        
    }
}

extension TasksViewController:PresenterToViewTasksProtocol {
    
}
