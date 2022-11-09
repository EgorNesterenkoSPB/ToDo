import UIKit

//MARK: - View Input (View -> Presenter)
protocol ViewToPresenterCreateTaskProtocol {
    var view: PresenterToViewCreateTaskProtocol? {get set}
    var router: PresenterToRouterCreateTaskProtocol? {get set}
    var interactor: PresenterToInteractorCreateTaskProtocol? {get set}
    func textViewDidBeginEditing(textView:UITextView)
    func textViewDidEndEditing(textView:UITextView)
    func textFieldDidEndEditing(textField:UITextField,createTaskButton:UIButton)
}

//MARK: - View Output (Presenter -> View)
protocol PresenterToViewCreateTaskProtocol {

}

//MARK: -  Interactor Input (Presenter -> Interactor)
protocol PresenterToInteractorCreateTaskProtocol {
    var presenter:InteractorToPresenterCreateTaskProtocol? {get set}

}

//MARK: - Interactor Output (Interactor -> Presenter)
protocol InteractorToPresenterCreateTaskProtocol {

}

//MARK: - Router Input (Presenter -> Router)
protocol PresenterToRouterCreateTaskProtocol {
    static func createModule() -> CreateTaskViewController
}
