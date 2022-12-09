import UIKit

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
    
    func textViewDidEndEditing(textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = Resources.Placeholders.textViewPlaceholder
            textView.textColor = UIColor.placeholderText
        }
    }
}

extension TaskPresenter:InteractorToPresenterTaskProtocol {
    
}
