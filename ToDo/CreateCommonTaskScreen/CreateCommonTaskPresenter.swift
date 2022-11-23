import UIKit

final class CreateCommonTaskPresenter:ViewToPresenterCreateCommonTaskProtocol {
    
    var view: PresenterToViewCreateCommonTaskProtocol?
    var router: PresenterToRouterCreateCommonTaskProtocol?
    var interactor: PresenterToInteractorCreateCommonTaskProtocol?
    var name:String?
    var description:String?
    
    func createTask(project: ProjectCoreData,date:Date?, time:Date?) {
        guard let name = name else {return}
        var settedDate:Date?
        if let date = date {
            if let time = time {
                settedDate = combineDateWithTime(date: date, time: time)
            } else {
                let calendar = Calendar.current
                guard let endTime = calendar.date(bySettingHour: 23, minute: 59, second: 59, of: date) else {return}
                settedDate = combineDateWithTime(date: date, time: endTime)
            }
        }
        interactor?.onCreateTask(project: project, name: name, description: description, settedDate: settedDate)
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
