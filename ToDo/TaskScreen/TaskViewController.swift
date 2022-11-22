import UIKit
import CoreData

final class TaskViewController:BaseViewController {
    
    let nameTextField = UITextField()
    let descriptionTextField = UITextField()
    let dateTextField = UITextField()
    
    var presenter:(ViewToPresenterTaskProtocol & InteractorToPresenterTaskProtocol)?
    let task:NSManagedObject
    let taskContent:TaskContent
    
    init(task:NSManagedObject,taskContent:TaskContent) {
        self.taskContent = taskContent
        self.task = task
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension TaskViewController {
    
    override func addViews() {
        
    }
    
    override func configure() {
        super.configure()
    }
    
    override func layoutViews() {
        
    }
}

extension TaskViewController:PresenterToViewTaskProtocol {
    
}
