import UIKit

final class CreateCommonTaskPresenter:ViewToPresenterCreateCommonTaskProtocol {
    
    var view: PresenterToViewCreateCommonTaskProtocol?
    var router: PresenterToRouterCreateCommonTaskProtocol?
    var interactor: PresenterToInteractorCreateCommonTaskProtocol?
    var name:String?
    var description:String?
    
    func createTask(project: ProjectCoreData) {
        guard let name = name else {return}
        interactor?.onCreateTask(project: project, name: name, description: description)
    }
    
    func textViewDidEndEditing(textView: UITextView) {
        guard textView.text != Resources.Placeholders.textViewPlaceholder, textView.textColor != UIColor.placeholderText else { return}
        self.description = textView.text
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        if textField.text?.isEmpty == false {
            name = textField.text
        }
    }
    
}

extension CreateCommonTaskPresenter:InteractorToPresenterCreateCommonTaskProtocol {
    func failedCreateTask(errorText: String) {
        view?.onFailedCreateTask(errorText: errorText)
    }
    
    func successfulyCreateTask() {
        view?.onSuccessfulyCreateTask()
    }
    
    
}
