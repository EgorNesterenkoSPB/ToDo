import UIKit
import CoreData

//MARK: - View Input (View -> Presenter)
protocol ViewToPresenterTaskProtocol {
    var view: PresenterToViewTaskProtocol? {get set}
    var router: PresenterToRouterTaskProtocol? {get set}
    var interactor: PresenterToInteractorTaskProtocol? {get set}
    func textViewDidBeginEditing(textView: UITextView)
    func textViewDidEndEditing(textView: UITextView)

}

//MARK: - View Output (Presenter -> View)
protocol PresenterToViewTaskProtocol {
    
}

//MARK: -  Interactor Input (Presenter -> Interactor)
protocol PresenterToInteractorTaskProtocol {
    var presenter:InteractorToPresenterTaskProtocol? {get set}
}

//MARK: - Interactor Output (Interactor -> Presenter)
protocol InteractorToPresenterTaskProtocol {

}

//MARK: - Router Input (Presenter -> Router)
protocol PresenterToRouterTaskProtocol {
    static func createModule(task:NSManagedObject,taskContent:TaskContent) -> TaskViewController
}
