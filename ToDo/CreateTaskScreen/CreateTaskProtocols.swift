import UIKit
import CoreData

//MARK: - View Input (View -> Presenter)
protocol ViewToPresenterCreateTaskProtocol {
    var view: PresenterToViewCreateTaskProtocol? {get set}
    var router: PresenterToRouterCreateTaskProtocol? {get set}
    var interactor: PresenterToInteractorCreateTaskProtocol? {get set}
    func textViewDidEndEditing(textView:UITextView)
    func textFieldDidEndEditing(textField:UITextField)
    func createTask(category:CategoryCoreData?,date:Date?,time:Date?,projectID:NSManagedObjectID?)
}

//MARK: - View Output (Presenter -> View)
protocol PresenterToViewCreateTaskProtocol {
    func onFailedCreateTask(errorText:String)
    func onSuccessfulyCreateTask()
}

//MARK: -  Interactor Input (Presenter -> Interactor)
protocol PresenterToInteractorCreateTaskProtocol {
    var presenter:InteractorToPresenterCreateTaskProtocol? {get set}
    func onCreateTask(name:String,description:String?,category:CategoryCoreData,settedDate:Date?)
    func onCreateCommonTask(name:String,description:String?,settedData:Date?,projectID:NSManagedObjectID)
}

//MARK: - Interactor Output (Interactor -> Presenter)
protocol InteractorToPresenterCreateTaskProtocol {
    func failedCreateTask(errorText:String)
    func successfulyCreateTask()
}

//MARK: - Router Input (Presenter -> Router)
protocol PresenterToRouterCreateTaskProtocol {
    static func createModule(category:CategoryCoreData?,section:Int?,projectName:String?) -> CreateTaskViewController
}
