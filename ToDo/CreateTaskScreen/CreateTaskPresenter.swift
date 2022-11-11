import UIKit

final class CreateTaskPresenter:ViewToPresenterCreateTaskProtocol {
    var view: PresenterToViewCreateTaskProtocol?
    var router: PresenterToRouterCreateTaskProtocol?
    var interactor: PresenterToInteractorCreateTaskProtocol?
    var name:String?
    var description:String?

    func textViewDidBeginEditing(textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = .black
        }
    }
    
    func textViewDidEndEditing(textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = Resources.Placeholders.textViewPlaceholder
            textView.textColor = UIColor.lightGray
        }
        else {
            self.description = textView.text
        }
    }
    
    func textFieldDidEndEditing(textField: UITextField, createTaskButton: UIButton) {
        if textField.text?.isEmpty == false {
            createTaskButton.tintColor = .systemOrange
            createTaskButton.isEnabled = true
            name = textField.text
        }
    }
    
    func createTask(category: CategoryCoreData) {
        guard let name = name,name != "" && name != " " else {return}
        guard let description = description,description != "" && description != " " else {return}
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
