import UIKit
import CoreData

//MARK: - View Input (View -> Presenter)
protocol ViewToPresenterTaskProtocol {
    var view: PresenterToViewTaskProtocol? {get set}
    var router: PresenterToRouterTaskProtocol? {get set}
    var interactor: PresenterToInteractorTaskProtocol? {get set}
    func textViewDidBeginEditing(textView: UITextView)
    func textViewDidEndEditing(textView: UITextView,task:NSManagedObject)
    func userTapEditButton(task:NSManagedObject,taskViewController:TaskViewController)
    func renameTask(name:String?,task:NSManagedObject)
    func editDate(task:NSManagedObject,newDate:Date)
    func deleteDate(task:NSManagedObject)
}

//MARK: - View Output (Presenter -> View)
protocol PresenterToViewTaskProtocol {
    func failureCoreData(errorText:String)
    func onSuccessfulyDeleteTask()
    func onSuccessfulyChangeDate(date:Date)
    func onSuccessfulyDeleteDate()
}

//MARK: -  Interactor Input (Presenter -> Interactor)
protocol PresenterToInteractorTaskProtocol {
    var presenter:InteractorToPresenterTaskProtocol? {get set}
    func onRenameTask(newName:String,task:NSManagedObject)
    func editDescription(text:String,task:NSManagedObject)
    func deleteTask(task:NSManagedObject)
    func onEditeDate(task:NSManagedObject,newDate:Date)
    func onDeleteDate(task:NSManagedObject)
}

//MARK: - Interactor Output (Interactor -> Presenter)
protocol InteractorToPresenterTaskProtocol {
    func successfulyDeleteTask()
    func successfulyChangeDate(date:Date)
    func successfulyDeleteDate()
    func failureDeleteTask(errorText:String)
    func failureRenameTask(errorText:String)
    func failureEditDescription(errorText:String)
    func failureEditeTaskDate(errorText:String)
    func failureDeleteDate(errorText:String)
}

//MARK: - Router Input (Presenter -> Router)
protocol PresenterToRouterTaskProtocol {
    static func createModule(task:NSManagedObject,taskContent:TaskContent) -> TaskViewController
}
