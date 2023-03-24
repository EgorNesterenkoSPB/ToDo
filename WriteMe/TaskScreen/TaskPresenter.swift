import UIKit
import CoreData

final class TaskPresenter:ViewToPresenterTaskProtocol {
    var view: PresenterToViewTaskProtocol?
    var router: PresenterToRouterTaskProtocol?
    var interactor: PresenterToInteractorTaskProtocol?
    
    func textViewDidBeginEditing(textView: UITextView) {
        if textView.text == Resources.Placeholders.textViewPlaceholder {
            textView.text = nil
            textView.textColor = UIColor(named: Resources.Titles.labelAndTintColor)
        }
    }
    
    func editDate(task: NSManagedObject, newDate: Date) {
        self.interactor?.onEditeDate(task: task, newDate: newDate)
    }
    
    func deleteDate(task: NSManagedObject) {
        self.interactor?.onDeleteDate(task: task)
    }
    
    func renameTask(name: String?,task:NSManagedObject) {
        guard let newName = name,name != " " else {return}
        self.interactor?.onRenameTask(newName: newName, task: task)
    }
    
    func textViewDidEndEditing(textView: UITextView,task:NSManagedObject) {
        if textView.text.isEmpty {
            textView.text = Resources.Placeholders.textViewPlaceholder
            textView.textColor = UIColor.placeholderText
        } else {
            guard textView.text != " " else {return}
            self.interactor?.editDescription(text: textView.text, task: task)
        }
    }
    
    func userTapEditButton(task: NSManagedObject, taskViewController: TaskViewController) {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alertController.addAction(UIAlertAction(title: Resources.Titles.deleteTask, style: .destructive, handler: {_ in
            self.interactor?.deleteTask(task: task)
        }))
        alertController.addAction(UIAlertAction(title: Resources.Titles.cancelButton, style: .cancel, handler: nil))
        
        taskViewController.present(alertController,animated: true)
    }
}

extension TaskPresenter:InteractorToPresenterTaskProtocol {
    func successfulyChangeDate(date: Date) {
        self.view?.onSuccessfulyChangeDate(date: date)
    }
    
    func successfulyDeleteDate() {
        self.view?.onSuccessfulyDeleteDate()
    }
    
    func failureEditeTaskDate(errorText: String) {
        self.view?.failureCoreData(errorText: errorText)
    }
    
    func failureDeleteDate(errorText: String) {
        self.view?.failureCoreData(errorText: errorText)
    }
    
    func successfulyDeleteTask() {
        self.view?.onSuccessfulyDeleteTask()
    }
    
    func failureDeleteTask(errorText: String) {
        self.view?.failureCoreData(errorText: errorText)
    }
    
    func failureRenameTask(errorText: String) {
        self.view?.failureCoreData(errorText: errorText)
    }
    
    func failureEditDescription(errorText: String) {
        self.view?.failureCoreData(errorText: errorText)
    }
    
    
}
