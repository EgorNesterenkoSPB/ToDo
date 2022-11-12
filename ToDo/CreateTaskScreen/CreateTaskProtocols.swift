import UIKit

//MARK: - View Input (View -> Presenter)
protocol ViewToPresenterCreateTaskProtocol {
    var view: PresenterToViewCreateTaskProtocol? {get set}
    var router: PresenterToRouterCreateTaskProtocol? {get set}
    var interactor: PresenterToInteractorCreateTaskProtocol? {get set}
    func textViewDidBeginEditing(textView:UITextView)
    func textViewDidEndEditing(textView:UITextView)
    func textFieldDidEndEditing(textField:UITextField,createTaskButton:UIButton)
    func createTask(category:CategoryCoreData)
}

//MARK: - View Output (Presenter -> View)
protocol PresenterToViewCreateTaskProtocol {
    func onFailedCreateTask(errorText:String)
    func onSuccessfulyCreateTask()
}

//MARK: -  Interactor Input (Presenter -> Interactor)
protocol PresenterToInteractorCreateTaskProtocol {
    var presenter:InteractorToPresenterCreateTaskProtocol? {get set}
    func onCreateTask(name:String,description:String,category:CategoryCoreData)
}

//MARK: - Interactor Output (Interactor -> Presenter)
protocol InteractorToPresenterCreateTaskProtocol {
    func failedCreateTask(errorText:String)
    func successfulyCreateTask()
}

//MARK: - Router Input (Presenter -> Router)
protocol PresenterToRouterCreateTaskProtocol {
    static func createModule(category:CategoryCoreData,section:Int) -> CreateTaskViewController
}
