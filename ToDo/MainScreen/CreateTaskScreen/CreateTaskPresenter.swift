import UIKit

final class CreateTaskPresenter:ViewToPresenterCreateTaskProtocol {
    var view: PresenterToViewCreateTaskProtocol?
    var router: PresenterToRouterCreateTaskProtocol?
    var interactor: PresenterToInteractorCreateTaskProtocol?

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
    }
    
    func textFieldDidEndEditing(textField: UITextField, createTaskButton: UIButton) {
        if textField.text?.isEmpty == false {
            createTaskButton.tintColor = .systemOrange
            createTaskButton.isEnabled = true
        }
    }
    
}

extension CreateTaskPresenter:InteractorToPresenterCreateTaskProtocol {
    
}
