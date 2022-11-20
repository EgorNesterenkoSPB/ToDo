import UIKit

final class CreateTaskPresenter:ViewToPresenterCreateTaskProtocol {
    var view: PresenterToViewCreateTaskProtocol?
    var router: PresenterToRouterCreateTaskProtocol?
    var interactor: PresenterToInteractorCreateTaskProtocol?
    var name:String?
    var description:String?

    
    func textViewDidEndEditing(textView: UITextView) {
        guard !textView.text.isEmpty else {return}
        guard textView.text != Resources.Placeholders.textViewPlaceholder, textView.textColor != UIColor.placeholderText else { return}
        self.description = textView.text
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        if textField.text?.isEmpty == false {
            name = textField.text
        }
    }
    
    func createTask(category: CategoryCoreData) {
        guard let name = name,name != "" && name != " " else {return}
        interactor?.onCreateTask(name: name, description: description, category: category)
    }
    
}

extension CreateTaskPresenter:InteractorToPresenterCreateTaskProtocol {
    func failedCreateTask(errorText: String) {
        view?.onFailedCreateTask(errorText: errorText)
    }
    
    func successfulyCreateTask() {
        view?.onSuccessfulyCreateTask()
    }
    
    
}
