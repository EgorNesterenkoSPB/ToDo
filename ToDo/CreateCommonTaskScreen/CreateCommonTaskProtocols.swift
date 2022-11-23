import UIKit

//MARK: - View Input (View -> Presenter)
protocol ViewToPresenterCreateCommonTaskProtocol {
    var view: PresenterToViewCreateCommonTaskProtocol? {get set}
    var router: PresenterToRouterCreateCommonTaskProtocol? {get set}
    var interactor: PresenterToInteractorCreateCommonTaskProtocol? {get set}
    func createTask(project:ProjectCoreData,date:Date?, time:Date?)
    func textViewDidEndEditing(textView:UITextView)
    func textFieldDidEndEditing(textField:UITextField)
}

//MARK: - View Output (Presenter -> View)
protocol PresenterToViewCreateCommonTaskProtocol {
    func onFailedCreateTask(errorText:String)
    func onSuccessfulyCreateTask()
}

//MARK: -  Interactor Input (Presenter -> Interactor)
protocol PresenterToInteractorCreateCommonTaskProtocol {
    var presenter:InteractorToPresenterCreateCommonTaskProtocol? {get set}
    func onCreateTask(project:ProjectCoreData,name:String,description:String?,settedDate:Date?)
}

//MARK: - Interactor Output (Interactor -> Presenter)
protocol InteractorToPresenterCreateCommonTaskProtocol {
    func failedCreateTask(errorText:String)
    func successfulyCreateTask()
}

//MARK: - Router Input (Presenter -> Router)
protocol PresenterToRouterCreateCommonTaskProtocol {
    static func createModule(project:ProjectCoreData) -> CreateCommonTaskViewController

}
